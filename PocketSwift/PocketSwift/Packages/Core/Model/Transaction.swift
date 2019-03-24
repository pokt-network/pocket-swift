//
//  Transaction.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Transaction: Model {
    public let network: String
    public let subnetwork: String
    public var serializedTransaction: String
    public var transactionMetadata: JSON?
    public var transactionData: TransactionData? = nil
    
    enum CodingKeys: String, CodingKey {
        case network
        case subnetwork
        case serializedTransaction = "serialized_tx"
        case transactionMetadata = "tx_metadata"
    }
    
    public init(network: String, subnetwork: String, serializedTransaction: String, transactionMetadata:JSON?) {
        self.network = network
        self.subnetwork = subnetwork
        self.serializedTransaction = serializedTransaction
        self.transactionMetadata = transactionMetadata
    }
    
    public init(obj: [AnyHashable: Any]!) {
        self.network = obj["network"] as? String ?? ""
        self.subnetwork = obj["subnetwork"] as? String ?? ""
        self.serializedTransaction = obj["serialized_tx"] as? String ?? ""
        self.transactionMetadata = obj["tx_metadata"] as? JSON ?? JSON.object([String : JSON]())
    }
}
