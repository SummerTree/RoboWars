

import Foundation
import SpriteKit
import StoreKit

extension Home {
    
    // In-App Purchase Methods
    
    
    func setUpPurchasing (){
        
        //if at least some prodcuts haven't been bought start the SKPaymentQueue
        if (productIdentifiers.count != 0 &&  SKPaymentQueue.canMakePayments() == true){
            
            
            purchasingEnabled = true
            SKPaymentQueue.default().add(self)
            requestProductData()
            
            if(debugMode){
                
                print("These products have not been purchased for \(productIdentifiers)")
                print("(Consumables are considered unpurchased since they can be bought multiple times)")
                
            }
            
            
        } else {
            
            purchasingEnabled = true
            
            if(productIdentifiers.count == 0){
                
                if(debugMode){
                    
                    print("All products have been purchased")
                    
                    
                }
                
                
            }
            if(SKPaymentQueue.canMakePayments() == false){
                
                if(debugMode){
                    
                    print("User can't make payments, so we aren't setting up SKPaymentQueue")
                    
                    
                }
                
                
            }
            
        }
        
        
        
        
    }
    
    
    func requestProductData()
    {
        
        request = SKProductsRequest(productIdentifiers:
            self.productIdentifiers as Set<String>)
        request!.delegate = self
        request!.start()
        
        
    }
    
    @objc(productsRequest:didReceiveResponse:) func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products:[SKProduct] = response.products
        
        if (products.count != 0) {
            for i in 0 ..< products.count
            {
                self.product = products[i]
                self.productsArray.append(product!)
                
                
            }
            
        } else {
            if(debugMode){
                
                print("No products found")
            }
        }
        
        let invalidProducts:[String] = response.invalidProductIdentifiers
        
        for invalidProduct in invalidProducts
        {
            if(debugMode){
                
                print("Product not found: \(invalidProduct)")
                
            }
        }
    }
    
    func buyProduct( _ ID:String ) {
        
        if SKPaymentQueue.canMakePayments() {
            
            for itemToBuy in productsArray {
                
                if (itemToBuy.productIdentifier == ID) {
                    
                    let payment = SKPayment(product: itemToBuy)
                    SKPaymentQueue.default().add(payment)
                    
                    break
                }
                
                
            }
            
            
            
        } else {
            let alert:UIAlertController = UIAlertController(title: "In-App Purchasing Not Enabled", message: "Please enable them in Settings", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            let vc:UIViewController = self.view!.window!.rootViewController!
            
            vc.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
            }
        }
    }
    
    func deliverProduct(_ transaction:SKPaymentTransaction) {
        
        
        defaults.set("Purchased", forKey: transaction.payment.productIdentifier)
        
        lockOrUnlockButtonsThatRequireProducts()
        
        
        if (debugMode){
            
            print( " Defaults now knows that \(transaction.payment.productIdentifier) has a saved value of  \(defaults.object(forKey: transaction.payment.productIdentifier) )")
        }
        
        
        
    }
    
    func restorePurchasesSilently() {
        
        restoreSilently = true
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        
    }
    
    
    func restorePurchases() {
        
        restoreSilently = false
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
       
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
    
        
        for transaction:SKPaymentTransaction in queue.transactions {
            
            
            
            defaults.set("Purchased", forKey: transaction.payment.productIdentifier)
            if (debugMode){
                
                print( " Defaults now knows that \(transaction.payment.productIdentifier) has a saved value of  \(defaults.object(forKey: transaction.payment.productIdentifier) )")
            }
            
        }
        
        lockOrUnlockButtonsThatRequireProducts()
        
        ////// show alert or not
        
        if ( restoreSilently == false){
            
            showRestoreAlert()
        }
        
        
        
        
    }
    
    
    func showRestoreAlert(){
        
        
        let alert:UIAlertController = UIAlertController(title: "Thank you", message: "Your past purchases have been restored", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        
        let vc:UIViewController = self.view!.window!.rootViewController!
        
        vc.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
}
