//
//  Blockchain.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Blockchain: Model, Input {
    let network: String
    let netID: String
    
    init(network: String, netID: String) {
        self.network = network
        self.netID = netID
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("Name", self.network, "NetID", self.netID)
        return data
    }
}
