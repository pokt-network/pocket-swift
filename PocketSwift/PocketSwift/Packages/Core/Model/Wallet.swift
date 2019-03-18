//
//  Wallet.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Wallet: Model {
    let address: String
    let privateKey: String
    let subNetwork: String
    let data: String
    
    init(address: String, privateKey: String, subNetwork: String, data: String) {
        self.address = address
        self.privateKey = privateKey
        self.subNetwork = subNetwork
        self.data = data
    }
}
