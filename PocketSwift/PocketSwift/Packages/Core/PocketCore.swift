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
        self.relayController = RelayController(with: self.configuration)
        self.dispatchController = DispatchController(with: self.configuration)
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
        if !relay.isValid() {
            onError(PocketError.invalidRelay)
            return
        }
        
        let node: Node? = getNode(netID: relay.netID, network: relay.blockchain, version: relay.version)
        guard let relayNode = node else {
            onError(PocketError.nodeNotFound)
            return
        }
        
        self.relayController.send(relay: relay, to: relayNode.ipPort)
        self.relayController.relayObserver.observe(in: self, with: { response in
            onSuccess(response)
        }, error: { error in
            onError(error)
        })
    }
    
    public func retrieveNodes(onSuccess: @escaping (_ findNodes: Bool) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.dispatchController.retrieveServiceNodes(from: self.getDispatch())
        self.dispatchController.dispatchObserver.observe(in: self, with: { (response: JSON) in
            let nodes: [Node] = self.getDispatch().parseDispatchResponse(response: response)
            if nodes.isEmpty {
                onSuccess(false)
            } else {
                onSuccess(true)
            }
        }, error: { error in
            onError(error)
        })
    }
    
    deinit {
        self.dispatchController.onCleared()
        self.relayController.onCleared()
    }
}
