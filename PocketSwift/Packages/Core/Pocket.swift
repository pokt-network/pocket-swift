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
    
    private let dispatch: Dispatch
    public var devID: String {
        get {
            return self.dispatch.configuration.devID
        }
    }
    
    /**
     Create new instance of Pocket.
     - Parameters:
        - devID : Developer Identifier
        - network: Name of the Blockchain network that is going to be used.
        - netIds: Arrays of Network ID
        - maxNodes: Maximum amount of nodes
        - requestTimeOut: Amount of time in miliseconds that the server is going to wait before returning a TimeOutException
        - schedulerProvider: This object determines which network strategy is going to be used (Sync vs Async)
     
     ### Usage Example: ###
     ````
        Pocket(devID: "DEVID1", network: "ETH", netIds: ["4", "1"], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .main)
     ````
     */
    
    init(devID: String, network: String, netIds: [String], maxNodes: Int = 5, requestTimeOut: Int = 1000, schedulerProvider: SchedulerProvider = .main){
        var blockchains: [Blockchain] = []
        netIds.forEach{ netID in
            blockchains.append(Blockchain(network: network, netID: netID))
        }
        
        let configuration = Configuration(devID: devID, blockchains: blockchains, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
        self.dispatch = Dispatch(configuration: configuration)
        
        // TODO: Check if we need this
//        self.relayController = RelayController(with: configuration, and: schedulerProvider)
//        self.dispatchController = DispatchController(with: configuration, and: schedulerProvider)
//        self.reportController = ReportController(with: configuration, and: schedulerProvider)
    }
    
    /**
     Create new instance of Pocket.
     - Parameters:
        - devID : Developer Identifier
        - network: Name of the Blockchain network that is going to be used.
        - netIds: Arrays of Network ID
        - maxNodes: Maximum amount of nodes
        - requestTimeOut: Amount of time in miliseconds that the server is going to wait before returning a TimeOutException
     
     ### Usage Example: ###
     ````
        Pocket(devID: "DEVID1", network: "ETH", netIds: ["4", "1"], maxNodes: 5, requestTimeOut: 1000)
     ````
     */
    
    public convenience init(devID: String, network: String, netIds: [String], maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        self.init(devID: devID, network: network, netIds: netIds, maxNodes: maxNodes, requestTimeOut: requestTimeOut, schedulerProvider: .main)
    }
    
    /**
     Create new instance of Pocket.
     - Parameters:
        - devID : Developer Identifier
        - network: Name of the Blockchain network that is going to be used.
        - netID: Network ID
        - maxNodes: Maximum amount of nodes
        - requestTimeOut: Amount of time in miliseconds that the server is going to wait before returning a TimeOutException
     
     ### Usage Example: ###
     ````
        Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
     ````
     */
    
    public convenience init(devID: String, network: String, netID: String, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        let netIds: [String] = [netID]
        self.init(devID: devID, network: network, netIds: netIds, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
    }
    
    /**
     Send a relay object to the server and returns an String with the response. This response depends of the structure of the Relay.
     - Parameters:
        - relay : Relay Object
        - onSuccess: Callback that is going to be called if the server returns a positive response.
        - onError: Callback that is going to be called if the server returns a negative response.
     
     ### Usage Example: ###
     ````
         let pocket = Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
         let relay = Relay.init(network: "ETH", netID: "10", data: data, devID: "DEVID1")
         pocket.send(relay: relay, onSuccess: { response in
            //Positive Response
         }, onError: {error in
            // Negative Response
         })
     ````
     - SeeAlso: `Relay`
     */
    
    public func send(relay: Relay, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()) {
        if !relay.isValid() {
            onError(PocketError.invalidRelay)
            return
        }
        
        getNode(network: relay.network, netID: relay.netID, retrieveNodes: true) {node in
            guard let relayNode = node else {
                onError(PocketError.nodeNotFound)
                return
            }
            
            let relayController = RelayController(with: self.dispatch.configuration, and: .main)
            
            relayController.relayObserver.observe(in: self, for: {
                relayController.send(relay: relay, to: relayNode.ipPort)
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
                    print("Lolo")
                }, onError: { (error) in
                    // TODO: figure out what to do with the report error
                    print("Lala")
                })
            })
        }
    }
    
    /**
     Create a relay object and send it to the server and returns an String with the response. This response depends of the structure of the Relay.
     - Parameters:
        - relay : Relay Object
        - onSuccess: Callback that is going to be called if the server returns a positive response.
        - onError: Callback that is going to be called if the server returns a negative response.
     
     ### Usage Example: ###
     ````
         let pocket = Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
         let relay = Relay.init(network: "ETH", netID: "10", data: data, devID: "DEVID1")
         pocket.send(relay: relay, onSuccess: { response in
            //Positive Response
         }, onError: {error in
            // Negative Response
         })
     ````
     - SeeAlso: `Relay`
     */
    
    open func send(network: String, netID: String, data: String, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()) {
        self.send(relay: Relay.init(network: network, netID: netID, data: data, devID: self.dispatch.configuration.devID, httpMethod: nil, path: nil, queryParams: nil, headers: nil), onSuccess: onSuccess, onError: onError)
    }
    
    /**
     Adds a new Blockchain to the dispatch configuration.
     - Parameters:
         - network: Name of the Blockchain network that is going to be used.
         - netID: Network ID
     
     ### Usage Example: ###
     ````
        let pocket = Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
        pocket.addBlockchain("AION", "254")
     ````
     */
    
    public func addBlockchain(network: String, netID: String) {
        self.dispatch.configuration.blockchains.append(Blockchain.init(network: network, netID: netID))
    }
    
    // Private interface
    /**
     Randomly selects a valid node
     - Parameters:
        - network: Name of the Blockchain network that is going to be used.
        - netID: Network ID
     
     ### Usage Example: ###
     ````
        self.retrieveNodes(onSuccess: { (retrievedNodes) in
            callback(Pocket.getRandomNode(nodes: retrievedNodes))
        }) { (error) in
            callback(nil)
        }
     ````
     - SeeAlso: `Node`
     - Returns: a valid random `Node`
     */
    static func getRandomNode(nodes: [Node]) -> Node? {
        return nodes.isEmpty ? nil : nodes[Int.random(in: 0 ..< nodes.count)]
    }
    
    /**
     Gets a random node. If the dispatch node list is empty, a new list of nodes will be obtained from Pocket backend.
     - Parameters:
        - network: Name of the Blockchain network that is going to be used.
        - netID: Network ID
        - retrieveNodes: Whether to retrieve new nodes.
        - callback: returns a Node if exits
     
     ### Usage Example: ###
     ````
         getNode(network: relay.network, netID: relay.netID, retrieveNodes: true) {node in
            guard let relayNode = node else {
                onError(PocketError.nodeNotFound)
                return
            }
         }
     ````
     - SeeAlso: `Node`
     */
    
    func getNode(network: String, netID: String, retrieveNodes: Bool = false, callback: @escaping (_ node: Node?)->()) {
        var nodes: [Node] = []
        self.dispatch.configuration.nodes.forEach { (node) in
            if node.network.elementsEqual(network) && node.netID.elementsEqual(netID) {
                nodes.append(node)
            }
        }
        
        if (nodes.isEmpty && retrieveNodes) {
            self.retrieveNodes(onSuccess: { (retrievedNodes) in
                callback(Pocket.getRandomNode(nodes: retrievedNodes))
            }) { (error) in
                callback(nil)
            }
        } else {
            callback(Pocket.getRandomNode(nodes: nodes))
        }
    }
    
    /**
     Parses the list of service nodes from Pocket dispatch
     - Parameters:
        - callback: callback listener for the parse operation.
     
     ### Usage Example: ###
     ````
        self.retrieveNodes(onSuccess: { (retrievedNodes) in
            callback(Pocket.getRandomNode(nodes: retrievedNodes))
        }) { (error) in
            callback(nil)
        }
     ````
     - SeeAlso: `Node`
     */
    
    func retrieveNodes(onSuccess: @escaping (_ nodes: [Node]) ->(), onError: @escaping (_ error: Error) -> ()) {
        
        let dispatchController = DispatchController(with: self.dispatch.configuration, and: .main)
        
        dispatchController.dispatchObserver.observe(in: self, for: {
            dispatchController.retrieveServiceNodes(from: self.dispatch)
        }, with: { (response: JSON) in
            let nodes: [Node] = self.dispatch.parseDispatchResponse(response: response)
            if !nodes.isEmpty {
                onSuccess(nodes)
            } else {
                onError(PocketError.nodeNotFound)
            }
        }) { (error) in
            onError(error!)
        }
    }
    
    /**
     Create a report object and send it to the server and returns an String with the response. This response depends of the structure of the Relay.
     - Parameters:
        - report : Report Object
        - onSuccess: Callback that is going to be called if the server returns a positive response.
        - onError: Callback that is going to be called if the server returns a negative response.
     
     ### Usage Example: ###
     ````
        let pocket = Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
        let report = Report.init(ip: nodes[0].ip, message: "Test please ignore")
        pocket.send(report: report, onSuccess: { response in
            //Positive Response
        }, onError: {error in
            // Negative Response
        })
    
     ````
     - SeeAlso: `Report`
     */
    
    func send(report: Report, onSuccess: @escaping (_ data: String) ->(), onError: @escaping (_ error: Error) -> ()){
        if !report.isValid() {
            onError(PocketError.invalidReport)
            return
        }

        let reportController = ReportController(with: self.dispatch.configuration, and: .main)
        
        reportController.reportObserver.observe(in: self, for: {
            reportController.send(report: report)
        },with: {reponse in

        }, error: {error in

        })
    }
    
    deinit {
    }
}
