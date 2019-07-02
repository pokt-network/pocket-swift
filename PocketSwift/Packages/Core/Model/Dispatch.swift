//
//  Dispatch.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

/**
 A Model Class that wraps the user Configuration.
 
 - Parameters:
 - configuration : The configuration to be used.
 
 - SeeAlso: `Configuration`
 */

struct Dispatch: Input {
    public var configuration: Configuration
    
    public init(configuration: Configuration) {
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
    
    /**
        Creates an ArrayList of Node elements

        - Parameters:
            - jsonObject the jsonObject from the jsonArray response

        - Return: 
            - A list of Node

        See Node
     */
    private func createNodesArray(dictionary: [String: JSON]) -> [Node] {
        if dictionary.isEmpty {
            fatalError("Failed to parse Node objec")
        }
        
        var nodes: [Node] = []
        let network = dictionary["name"]?.value() as! String
        let netID = dictionary["netid"]?.value() as! String
        
        if let ipPortArray = dictionary["ips"]?.value() as? Array<JSON> {
            ipPortArray.forEach { ipPort in
                nodes.append(Node(network: network, netID: netID, ipPort: ipPort.value() as! String))
            }
        }
        
        return nodes
    }
    
    /**
     Parse the response from the Dispatch service
     
     - Parameters:
     - response : the response from the Dispatcher.
     
     - SeeAlso: `Node`
     - SeeAlso: `JSON`
     - Returns: An Array of `Node`
     */
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
