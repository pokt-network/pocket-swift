//
//  PocketCore.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class PocketCore: NSObject {
    
    private let configuration: Configuration
    
    
    public init(devID: String, networkName: String, netIDs:[Int], version: Int, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        var blockchains: [String] = []
        netIDs.forEach{ netID in
            //blockchains.append(Blockchain(name: networkName, netID: netID, version: version))
        }
        
        self.configuration = Configuration(devID: devID, blockchains: blockchains, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
        //self.relayController = RelayController()
    }
    
    public convenience init(devID: String, networkName: String, netID: Int , version: Int, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        let netIDs: [Int] = [netID]
        self.init(devID: devID, networkName: networkName, netIDs: netIDs, version: version, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
    }
        
}
