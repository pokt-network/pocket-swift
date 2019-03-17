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
    private let dispatchController: DispatchController
    private var dispatch: Dispatch? = nil
    
    public init(devID: String, networkName: String, netIDs:[Int], version: String, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        var blockchains: [Blockchain] = []
        netIDs.forEach{ netID in
            blockchains.append(Blockchain(name: networkName, netID: netID, version: version))
        }
        
        self.configuration = Configuration(devID: devID, blockchains: blockchains, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
        self.relayController = RelayController()
        self.dispatchController = DispatchController()
    }
    
    public convenience init(devID: String, networkName: String, netID: Int , version: String, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        let netIDs: [Int] = [netID]
        self.init(devID: devID, networkName: networkName, netIDs: netIDs, version: version, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
    }
    
    public func createRelay(blockchain: String, netID: Int, version: String, data: String, devID: String) -> Relay {
        return Relay(blockchain: blockchain, netID: netID, version: version, data: data, devID: devID)
    }
    
    func getDispatch() -> Dispatch {
        guard let dispatch = self.dispatch else {
            self.dispatch = Dispatch(configuration: self.configuration)
            return self.dispatch!
        }
        return dispatch
    }
    
    func getNode(netID: Int, network: String, version: String) -> Node? {
        if self.configuration.isNodeEmpty() {
            return nil
        }
        
        var nodes: Array<Node> = []
        self.configuration.nodes.forEach { node in
            if node.isEqual(netID: netID, network: network, version: version) {
                nodes.append(node)
            }
        }
        
        return nodes.isEmpty ? nil : nodes[Int.random(in: 0 ..< nodes.count)]
    }
    
    public func send(relay: Relay, onSuccess: @escaping (_ data: Relay) ->(), onError: @escaping (_ error: Error) -> ()){
        self.relayController.send(relay: relay)
        self.relayController.relayObserver.observe(in: self, with: { response in
            onSuccess(response)
        }, error: { error in
            onError(error)
        })
    }
    
    public func retrieveNodes(onSuccess: @escaping (_ nodes: [Node]) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.dispatchController.retrieveServiceNodes(from: self.getDispatch())
        self.dispatchController.dispatchObserver.observe(in: self, with: { response in
            print(response)
        }, error: { error in
            
        })
    }
    
    deinit {
        self.dispatchController.onCleared()
        self.relayController.onCleared()
    }
}
