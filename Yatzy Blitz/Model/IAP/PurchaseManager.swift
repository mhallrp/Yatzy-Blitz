//import StoreKit
//
//class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
//
//    static let shared = PurchaseManager()
//    let removeAdsProductID = "01" //update product id here
//    var products: [SKProduct] = []
//
//    func fetchProducts() {
//        let productIDs = Set([removeAdsProductID])
//        let request = SKProductsRequest(productIdentifiers: productIDs)
//        request.delegate = self
//        request.start()
//    }
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        products = response.products
//    }
//
//    func purchase(product: SKProduct) {
//        if SKPaymentQueue.canMakePayments() {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(payment)
//        }
//    }
//
//    func restorePurchases() {
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchased:
//                if transaction.payment.productIdentifier == removeAdsProductID {
//                    UserDefaults.standard.set(true, forKey: "adsRemoved")
//                }
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .restored:
//                if transaction.payment.productIdentifier == removeAdsProductID {
//                    UserDefaults.standard.set(true, forKey: "adsRemoved")
//                }
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .failed, .deferred, .purchasing:
//                break
//            @unknown default:
//                break
//            }
//        }
//    }
//}
//
//


//** DEFAULT VALUE FOR PURCHASE RESULT
//@State private var hasPurchased = UserDefaults.standard.bool(forKey: "adsRemoved")

//** ACTION BUTTON TO  BE ADDED INTO UI

//Button(action: {
//    if let product = PurchaseManager.shared.products.first {
//        PurchaseManager.shared.purchase(product: product)
//    }
//}) {
//}
//.onAppear {
//    PurchaseManager.shared.fetchProducts()
//    self.hasPurchased = UserDefaults.standard.bool(forKey: "adsRemoved")
//}
//.onChange(of: UserDefaults.standard.bool(forKey: "adsRemoved")) { newValue in
//    self.hasPurchased = newValue
//}
//.pressAction { isPressed[2] = true }
//onRelease: { isPressed[2] = false }
//    .buttonStyle(MainButtonView(text: hasPurchased ? "Ads Removed!" : "Remove Ads", isPressed: isPressed[2]))
