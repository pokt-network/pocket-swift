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
    
    init(name: String, netID: Int) {
        self.name = name
        self.netID = netID
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("Name", self.name, "NetID", "\(self.netID)")
        return data
    }
}
