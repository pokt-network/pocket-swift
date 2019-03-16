//
//  Blockchain.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Blockchain: Model, Input {
    let name: String
    let netID: Int
    let version: String
    
    init(name: String, netID: Int, version: String) {
        self.name = name
        self.netID = netID
        self.version = version
    }
    
    func toParameters() -> [String : String] {
        var data: Parameters = [:]
        data.fill("Name", self.name, "NetID", "\(self.netID)", "Version", self.version)
        return data
    }
}
