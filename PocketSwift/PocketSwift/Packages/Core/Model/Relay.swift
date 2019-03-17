//
//  Relay.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Relay: Model, Input {
    let blockchain: String
    let netID: Int
    let version: String
    let data: String
    let devID: String
    
    init(blockchain: String, netID: Int, version: String, data: String, devID: String) {
        self.blockchain = blockchain
        self.netID = netID
        self.version = version
        self.data = data
        self.devID = devID
    }
    
    private func isValid() -> Bool {
        do {
            return try Utils.areDirty(self.blockchain, self.version, self.data, self.devID)
        } catch {
            fatalError("There was a problem validating your relay")
        }
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("Blockchain", self.blockchain, "NetID", "\(self.netID)", "Version", self.version, "Data", self.data, "DevID", self.devID)
        return data
    }
}
