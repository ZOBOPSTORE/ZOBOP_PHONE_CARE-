import Foundation
import StoreKit

@MainActor
final class SubscriptionStore: ObservableObject {
    static let monthlyID = "com.zobop.phonecare.premium.monthly"
    static let yearlyID = "com.zobop.phonecare.premium.yearly"
    static let productIDs = [monthlyID, yearlyID]

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private var updatesTask: Task<Void, Never>?
    private var didStart = false

    var isPremium: Bool { !purchasedProductIDs.isEmpty }

    deinit { updatesTask?.cancel() }

    func start() async {
        guard !didStart else { return }
        didStart = true
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                do {
                    let transaction = try self.checkVerified(result)
                    if Self.productIDs.contains(transaction.productID) {
                        await self.refreshEntitlements()
                    }
                    await transaction.finish()
                } catch {
                    self.errorMessage = "A purchase could not be verified."
                }
            }
        }
        await load()
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: Self.productIDs).sorted { $0.price < $1.price }
            await refreshEntitlements()
        } catch {
            errorMessage = "Premium plans could not be loaded. Please try again."
        }
    }

    func purchase(_ product: Product) async {
        isLoading = true
        defer { isLoading = false }
        do {
            switch try await product.purchase() {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = "Purchase could not be completed."
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            errorMessage = "Restore could not be completed."
        }
    }

    private func refreshEntitlements() async {
        var active: Set<String> = []
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result), Self.productIDs.contains(transaction.productID) {
                active.insert(transaction.productID)
            }
        }
        purchasedProductIDs = active
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe): return safe
        case .unverified: throw StoreError.failedVerification
        }
    }

    enum StoreError: Error { case failedVerification }
}
