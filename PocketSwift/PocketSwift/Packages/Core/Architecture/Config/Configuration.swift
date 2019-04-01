//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/15/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class Configuration {
    
    public var blockchains: [Blockchain]
    public let devID: String
    public let maxNodes: Int
    public let requestTimeOut: Int
    public var nodes: Array<Node> = []
    
    public init(devID: String, blockchains: [Blockchain] = [], maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        self.devID = devID
        self.blockchains = blockchains
        self.maxNodes = maxNodes
        self.requestTimeOut = requestTimeOut
    }
}
