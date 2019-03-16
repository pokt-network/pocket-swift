//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/15/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class Configuration {
    
    let devID: String
    let blockchains: [String]
    let maxNodes: Int
    let requestTimeOut: Int
    
    public init(devID: String, blockchains: [String] = [], maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        self.devID = devID
        self.blockchains = blockchains
        self.maxNodes = maxNodes
        self.requestTimeOut = requestTimeOut
    }
    
    
}
