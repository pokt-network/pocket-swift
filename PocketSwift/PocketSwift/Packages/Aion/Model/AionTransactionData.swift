//
//  AionTransactionData.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

struct AionTransactionData: TransactionData {
    let nonce: String
    let to: String
    let data: String
    let value: String
    let gasPrice: String
    let gas: String
    
    init(nonce: Any?, to: Any?, data: Any?, value: Any?, gasPrice: Any?, gas: Any?) throws {
        let tupleValidation = Utils.areNilOrClen(("nonce", nonce), ("receiver of the transaction (to)", to), ("value", value), ("gas price", gasPrice), ("gas value", gas))
        
        if tupleValidation.result {
            throw PocketError.transactionCreation(message: "Failed to retrieve the \(tupleValidation.property)")
        }
        self.nonce = nonce as! String
        self.to = to as! String
        self.data = data as? String ?? ""
        self.value = value as! String
        self.gasPrice = gasPrice as! String
        self.gas = gas as! String
    }
    
    func getStringFormatted(signTx: String, privateKey: String) -> String {
        return String(format: signTx, self.nonce, self.to, self.value, self.data, self.gas, self.gasPrice, privateKey)
    }
}
