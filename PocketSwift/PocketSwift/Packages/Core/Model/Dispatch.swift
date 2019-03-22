//
//  Dispatch.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

struct Dispatch: Input {
    var configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration   }
    
    private func getBlockchains() -> Array<Parameters> {
        var blockchains: Array<Parameters> = []
        self.configuration.blockchains.forEach{ item in
            blockchains.append(item.toParameters())
        }
        return blockchains
    }
    
    func toParameters() -> Parameters {
        var parameter: Parameters = [:]
        parameter.fill("DevID", self.configuration.devID, "Blockchains", self.getBlockchains())
        return parameter
    }
    
    private func createNodesArray(dictionary: [String: JSON]) -> [Node] {
        if dictionary.isEmpty {
            fatalError("Failed to parse Node objec")
        }
        
        var nodes: [Node] = []
        let network = dictionary["name"]?.value() as! String
        let netID = dictionary["netid"]?.value() as! String
        
        if let ipPortArray = dictionary["ips"]?.value() as? Array<JSON> {
            ipPortArray.forEach { ipPort in
                nodes.append(Node(network: network, netID: Int(netID) ?? 0, ipPort: ipPort.value() as! String))
            }
        }
        
        return nodes
    }
    
    func parseDispatchResponse(response: JSON) -> [Node] {
        var nodes: [Node] = []
        
        if let reponseArray = response.value() as? [JSON] {
            reponseArray.forEach { responseJson in
                if let responseDict = responseJson.value() as? [String: JSON] {
                    if !responseDict.isEmpty {
                        nodes.append(contentsOf: createNodesArray(dictionary: responseDict))
                    }
                }
            }
        }
        if !nodes.isEmpty {
            self.configuration.nodes = nodes
        }
        return nodes
    }
}
