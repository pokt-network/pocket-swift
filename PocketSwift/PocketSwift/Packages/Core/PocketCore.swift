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
    private let relayController: RelayController
    
    public init(devID: String, networkName: String, netIDs:[Int], version: String, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        var blockchains: [Blockchain] = []
        netIDs.forEach{ netID in
            blockchains.append(Blockchain(name: networkName, netID: netID, version: version))
        }
        
        self.configuration = Configuration(devID: devID, blockchains: blockchains, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
        self.relayController = RelayController()
    }
    
    public convenience init(devID: String, networkName: String, netID: Int , version: String, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        let netIDs: [Int] = [netID]
        self.init(devID: devID, networkName: networkName, netIDs: netIDs, version: version, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
    }
    
    public func createRelay(blockchain: String, netID: Int, version: String, data: String, devID: String) -> Relay {
        return Relay(blockchain: blockchain, netID: netID, version: version, data: data, devID: devID)
    }
    
    public func send(relay: Relay, onSuccess: @escaping (_ data: Relay) ->(), onError: @escaping (_ error: Error) -> ()){
        self.relayController.send(relay: relay)
        self.relayController.relayObserver.observe(in: self, with: { response in
            onSuccess(response)
        }, error: { error in
            onError(error)
        })
    }
        
}
