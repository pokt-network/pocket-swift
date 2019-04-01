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
    
    private let relayController: RelayController
    private let dispatchController: DispatchController
    private let reportController: ReportController
    private let dispatch: Dispatch
    public var devID: String {
        get {
            return self.dispatch.configuration.devID
        }
    }
    
    init(devID: String, network: String, netIds: [String], maxNodes: Int = 5, requestTimeOut: Int = 1000, schedulerProvider: SchedulerProvider = .main){
        var blockchains: [Blockchain] = []
        netIds.forEach{ netID in
            blockchains.append(Blockchain(network: network, netID: netID))
        }
        
        let configuration = Configuration(devID: devID, blockchains: blockchains, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
        self.dispatch = Dispatch(configuration: configuration)
        
        // TODO: Check if we need this
        self.relayController = RelayController(with: configuration, and: schedulerProvider)
        self.dispatchController = DispatchController(with: configuration, and: schedulerProvider)
        self.reportController = ReportController(with: configuration, and: schedulerProvider)
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
        
        getNode(network: relay.network, netID: relay.netID, retrieveNodes: true) {node in
            guard let relayNode = node else {
                onError(PocketError.nodeNotFound)
                return
            }
            
            self.relayController.relayObserver.observe(in: self, for: {
                self.relayController.send(relay: relay, to: relayNode.ipPort)
            }, with: { response in
                let errorObject = response.toDict()?.hasError()
                
                if errorObject?.0 ?? false {
                    // We don't report in this case cause the node responded, could be due to a bad request
                    onError(PocketError.custom(message: errorObject?.1 ?? "Unknown Error"))
                    return
                }
                
                onSuccess(response)
            }, error: { error in
                onError(error!)
                // Report node error
                self.send(report: Report.init(ip: node?.ip ?? "unknown node IP", message: error?.localizedDescription ?? "Unknown error"), onSuccess: { (response) in
                    // TODO: figure out what to do with the report response
                }, onError: { (error) in
                    // TODO: figure out what to do with the report error
                })
            })
        }
    }
    
    open func send(network: String, netID: String, data: String, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.send(relay: Relay.init(network: network, netID: netID, data: data, devID: self.dispatch.configuration.devID), onSuccess: onSuccess, onError: onError)
    }
    
    public func addBlockchain(network: String, netID: String) {
        self.dispatch.configuration.blockchains.append(Blockchain.init(network: network, netID: netID))
    }
    
    // Private interface
    static func getRandomNode(nodes: [Node]) -> Node? {
        return nodes.isEmpty ? nil : nodes[Int.random(in: 0 ..< nodes.count)]
    }
    
    func getNode(network: String, netID: String, retrieveNodes: Bool = false, callback: @escaping (_ node: Node?)->()) {
        var nodes: [Node] = []
        self.dispatch.configuration.nodes.forEach { (node) in
            if node.network.elementsEqual(network) && node.netID.elementsEqual(netID) {
                nodes.append(node)
            }
        }
        
        if (nodes.isEmpty && retrieveNodes) {
            self.retrieveNodes(onSuccess: { (retrievedNodes) in
                callback(Pocket.getRandomNode(nodes: nodes))
            }) { (error) in
                callback(nil)
            }
        } else {
            callback(Pocket.getRandomNode(nodes: nodes))
        }
    }
    
    func retrieveNodes(onSuccess: @escaping (_ nodes: [Node]) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.dispatchController.dispatchObserver.observe(in: self, for: {
            self.dispatchController.retrieveServiceNodes(from: self.dispatch)
        }, with: { (response: JSON) in
            let nodes: [Node] = self.dispatch.parseDispatchResponse(response: response)
            if !nodes.isEmpty {
                onSuccess(nodes)
            } else {
                onError(PocketError.nodeNotFound)
            }
        }, error: { error in
            onError(error!)
        })
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
    
    deinit {
        self.dispatchController.onCleared()
        self.relayController.onCleared()
        self.reportController.onCleared()
    }
}
