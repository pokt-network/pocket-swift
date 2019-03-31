//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/15/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class Configuration {
    
    var blockchains: [Blockchain]
    let devID: String
    let maxNodes: Int
    let requestTimeOut: Int
    var nodes: Array<Node> = []
    
    public init(devID: String, blockchains: [Blockchain] = [], maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        self.devID = devID
        self.blockchains = blockchains
        self.maxNodes = maxNodes
        self.requestTimeOut = requestTimeOut
    }
    
    func isNodeEmpty() -> Bool {
        return self.nodes.count == 0
    }
    
    
}
