//
//  Relay.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

/**
 A Model Class that represents a Relay.
 
 - Parameters:
 - data : The json string with the information needed for create the Relay.
 - devId: The id used to interact with Pocket Api.
 - network: The blockchain network name, ie: ETH, AION.
 - netID: The netid of the Blockchain.
 
 */
public class Relay: Model, Input {
    let network: String
    let netID: String
    let data: String
    let devID: String
    
    init(network: String, netID: String, data: String, devID: String) {
        self.network = network
        self.netID = netID
        self.data = data
        self.devID = devID
    }
    
    /**
      Checks if this Relay has been configured correctly.
    */
    func isValid() -> Bool {
        do {
            return try Utils.areDirty(self.network, self.data, self.devID)
        } catch {
            fatalError("There was a problem validating your relay")
        }
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("Blockchain", self.network, "NetID", "\(self.netID)", "Data", self.data, "DevID", self.devID)
        return data
    }
}
