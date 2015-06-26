////
////  StoreKitHelper.swift
////  HappyNashville
////
////  Created by Richmond Watkins on 6/25/15.
////  Copyright (c) 2015 Richmond Watkins. All rights reserved.
////
//
//import UIKit
//import StoreKit
//
//class StoreKitHelper: NSObject,SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
//    var request : SKProductsRequest?
//    var queue : SKPaymentQueue = SKPaymentQueue.defaultQueue()
//    
//    
//    class var defaultHelper : StoreKitHelper {
//        struct Static {
//            static let instance : StoreKitHelper = StoreKitHelper()
//        }
//        
//        return Static.instance
//    }
//    
//    override init() {
//        super.init()
//    }
//    
//    
//    func initPurchase() {
//        if SKPaymentQueue.canMakePayments() {
//            println("user can make payments")
//            self.request = SKProductsRequest(productIdentifiers: NSSet(object: "com.richmondwatkins.HappyNashville") as Set<NSObject>)
//            self.request?.delegate = self
//            self.request?.start()
//        } else {
//            println("user cannot make payments")
//        }
//    }
//    
//    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
//        var adprodfound : Bool = false
//        var count = response.products.count
//        
//        if count > 0 {
//            for p in response.products {
//                if p is SKProduct {
//                    var prod = p as! SKProduct
//                    if prod.productIdentifier == "com.richmondwatkins.HappyNashville"{
//                        adprodfound = true
//                        
//                        buyProduct(prod)
//                    }
//                }
//            }
//        }
//        
//        if !adprodfound {
//            println("remove ad product not available")
//        }
//    }
//    
//    func buyProduct(product: SKProduct){
//        println("Sending the Payment Request to Apple");
//        var payment = SKPayment(product: product)
//        SKPaymentQueue.defaultQueue().addPayment(payment);
//        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
//    }
//    
//    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
//        println("Received Payment Transaction Response from Apple");
//        
//        for transaction:AnyObject in transactions {
//            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
//                switch trans.transactionState {
//                case .Purchased:
//                    NSNotificationCenter.defaultCenter().postNotificationName("removeAds", object: nil)
//                    
//                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
//                    break;
//                case .Failed:
//                    println("Purchased Failed");
//                    NSNotificationCenter.defaultCenter().postNotificationName("adPurchasedFailed", object: nil)
//                    
//                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
//                    break;
//                    // case .Restored:
//                    //[self restoreTransaction:transaction];
//                default:
//                    break;
//                }
//            }
//        }
//    }
//    
//    
//    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
//        print("failed")
//    }
//    
//    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
//        
//        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        
//        defaults.setBool(true, forKey: "hasPurchases")
//        
//        defaults.synchronize()
//    }
//  
//}
