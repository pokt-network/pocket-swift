//
//  Wallet.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Wallet {
    public let address: String
    public let privateKey: String
    public let subNetwork: String
    public let data: [AnyHashable: Any]?
    
    init(address: String, privateKey: String, subNetwork: String, data: [AnyHashable: Any]?) {
        self.address = address
        self.privateKey = privateKey
        self.subNetwork = subNetwork
        self.data = data
    }
}
