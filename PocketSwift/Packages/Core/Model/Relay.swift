//
//  Relay.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

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
