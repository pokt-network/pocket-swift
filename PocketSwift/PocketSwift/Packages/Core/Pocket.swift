//
//  PocketCore.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

protocol PocketPlugin {
    func createWallet(network: String, netID: String, data: [AnyHashable: Any]?) throws -> Wallet
    func importWallet(privateKey: String, address: String?, network: String, netID: String, data: [AnyHashable : Any]?) throws -> Wallet
}

public class Pocket: NSObject {
    
    let configuration: Configuration
    private let relayController: RelayController
    private let dispatchController: DispatchController
    private let reportController: ReportController
    private var dispatch: Dispatch? = nil
    
    init(devID: String, network: String, netIds: [String], maxNodes: Int = 5, requestTimeOut: Int = 1000, schedulerProvider: SchedulerProvider = .main){
        var blockchains: [Blockchain] = []
        netIds.forEach{ netID in
            blockchains.append(Blockchain(network: network, netID: netID))
        }
        
        self.configuration = Configuration(devID: devID, blockchains: blockchains, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
        self.relayController = RelayController(with: self.configuration, and: schedulerProvider)
        self.dispatchController = DispatchController(with: self.configuration, and: schedulerProvider)
        self.reportController = ReportController(with: self.configuration, and: schedulerProvider)
    }
    
    public convenience init(devID: String, network: String, netIds: [String], maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        self.init(devID: devID, network: network, netIds: netIds, maxNodes: maxNodes, requestTimeOut: requestTimeOut, schedulerProvider: .main)
    }
    
    public convenience init(devID: String, network: String, netID: String, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        let netIds: [String] = [netID]
        self.init(devID: devID, network: network, netIds: netIds, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
    }
    
    public func send(relay: Relay, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()){
        if !relay.isValid() {
            onError(PocketError.invalidRelay)
            return
        }
        
        getNode(netID: relay.netID, network: relay.network) {node in
            guard let relayNode = node else {
                onError(PocketError.nodeNotFound)
                return
            }
            
            self.relayController.relayObserver.observe(in: self, for: {
                self.relayController.send(relay: relay, to: relayNode.ipPort)
            }, with: { response in
                let errorObject = response.toDict()?.hasError()
                
                if errorObject?.0 ?? false {
                    onError(PocketError.custom(message: errorObject?.1 ?? "Unknown Error"))
                    return
                }
                
                onSuccess(response)
            }, error: { error in
                onError(error!)
            })
        }
    }
    
    open func send(network: String, netID: String, data: String, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.send(relay: Relay.init(network: network, netID: netID, data: data, devID: self.getDispatch().configuration.devID), onSuccess: onSuccess, onError: onError)
    }
    
    public func addBlockchain(network: String, netID: String) {
        self.getDispatch().configuration.blockchains.append(Blockchain.init(network: network, netID: netID))
    }
    
    // Private interface
    func createRelay(blockchain: String, netID: String, data: String, devID: String) -> Relay {
        return Relay(network: blockchain, netID: netID, data: data, devID: devID)
    }
    
    func createReport(ip: String, message: String) -> Report {
        return Report(ip: ip, message: message)
    }
    
    func getDispatch() -> Dispatch {
        guard let dispatch = self.dispatch else {
            self.dispatch = Dispatch(configuration: self.configuration)
            return self.dispatch!
        }
        return dispatch
    }
    
    func getNode(tries: Int = 0, netID: String, network: String, callback: @escaping (_ nodes: Node?)->()) {
        if self.configuration.isNodeEmpty() {
            if tries > 0 {
                callback(nil)
                return
            }
            
            self.retrieveNodes(onSuccess: { nodes in
                self.configuration.nodes = nodes
                self.getNode(tries: tries + 1, netID: netID, network: network, callback: callback)
                
            }, onError: {error in
                callback(nil)
            })
            return
        }
        
        var nodes: Array<Node> = []
        self.configuration.nodes.forEach { node in
            if node.isEqual(netID: netID, network: network) {
                nodes.append(node)
            }
        }
        
        callback(nodes.isEmpty ? nil : nodes[Int.random(in: 0 ..< nodes.count)])
    }
    
    func send(report: Report, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()){
        if !report.isValid() {
            onError(PocketError.invalidReport)
            return
        }
        
        self.reportController.reportObserver.observe(in: self, for: {
            self.reportController.send(report: report)
        },with: {reponse in
            
        }, error: {error in
            
        })
    }
    
    func retrieveNodes(onSuccess: @escaping (_ nodes: [Node]) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.dispatchController.dispatchObserver.observe(in: self, for: {
            self.dispatchController.retrieveServiceNodes(from: self.getDispatch())
        }, with: { (response: JSON) in
            let nodes: [Node] = self.getDispatch().parseDispatchResponse(response: response)
            if !nodes.isEmpty {
                onSuccess(nodes)
            } else {
                onError(PocketError.nodeNotFound)
            }
        }, error: { error in
            onError(error!)
        })
    }
    
    deinit {
        self.dispatchController.onCleared()
        self.relayController.onCleared()
    }
}
