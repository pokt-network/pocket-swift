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
    
    func parseDispatchResponse(response: JSON) -> [Node] {
        var nodes: [Node] = []
        if let reponseArray = response.value() as? [[String: [String]]] {
            reponseArray.forEach { dict in
                if !dict.isEmpty {
                    let key = dict.keys.first!
                    let data: [String] = key.components(separatedBy: "|")
                    
                    dict[key]?.forEach { ipPort in
                        nodes.append(Node(network: data[0], netID: Int(data[1]) ?? 0, version: data[2], ipPort: ipPort))
                    }
                }
            }
        }
        if let responseObject = response.value() as? [String: [String]] {
            if responseObject.isEmpty {
                fatalError("Failed to parse Node objec")
            }
            let key = responseObject.keys.first!
            let data: [String] = key.components(separatedBy: "|")
            
            if data.count != 3 {
                fatalError("Failed to parsed service nodes with error: Node information is missing 1 or more params: \(data.toString())");
            }
            
            responseObject[key]?.forEach{ ipPort in
                nodes.append(Node(network: data[0], netID: Int(data[1]) ?? 0, version: data[2], ipPort: ipPort))
            }
            
        }
        if !nodes.isEmpty {
            self.configuration.nodes = nodes
        }
        return nodes
    }
}
