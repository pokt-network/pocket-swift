//
//  Blockchain.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

/**
 A Model Class that represents a Blockchain.
 
 - Parameters:
 - name : The name of the Blockchain.
 - netID: The netid of the Blockchain.
 
 */
public struct Blockchain: Model, Input {
    let network: String
    let netID: String
    
    public init(network: String, netID: String) {
        self.network = network
        self.netID = netID
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("Name", self.network, "NetID", self.netID)
        return data
    }
}
