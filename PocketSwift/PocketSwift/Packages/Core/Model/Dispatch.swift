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
        dictionary.keys.forEach { key in
            let data: [String] = key.components(separatedBy: "|")
            
            if data.count != 3 {
                fatalError("Failed to parsed service nodes with error: Node information is missing 1 or more params: \(data.toString())");
            }
            
            if let ipPortArray = dictionary[key]?.value() as? Array<JSON> {
                ipPortArray.forEach { ipPort in
                    nodes.append(Node(network: data[0], netID: Int(data[2]) ?? 0, version: data[1], ipPort: ipPort.value() as! String))
                }
            }
        }
        
        return nodes
    }
    
    func parseDispatchResponse(response: JSON) -> [Node] {
        var nodes: [Node] = []
        if let reponseArray = response.value() as? [[String: JSON]] {
            reponseArray.forEach { dict in
                if !dict.isEmpty {
                    nodes.append(contentsOf: createNodesArray(dictionary: dict))
                }
            }
        }
        if let responseObject = response.value() as? [String: JSON] {
            nodes.append(contentsOf: createNodesArray(dictionary: responseObject))
        }
        if !nodes.isEmpty {
            self.configuration.nodes = nodes
        }
        return nodes
    }
}
