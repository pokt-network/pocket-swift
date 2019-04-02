//
//  EthContract.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
public class EthContract {
    
    private let ethNetwork: EthNetwork
    private let address: String
    private let abiDefinition: [[String: Any]]
    private var functions: [String: Function] = [String: Function]()
    
    init(ethNetwork: EthNetwork, address: String, abiDefinition: String) throws {
        self.ethNetwork = ethNetwork
        self.address = address
        guard let abiDefinitionData = abiDefinition.data(using: .utf8) else {
            throw PocketError.custom(message: "Error parsing abiDefinition JSON: \(abiDefinition)")
        }
        guard let abiDefinitionArray = try JSONSerialization.jsonObject(with: abiDefinitionData, options: []) as? [[String: Any]] else {
            throw PocketError.custom(message: "Error parsing abiDefinition JSON: \(abiDefinition)")
        }
        self.abiDefinition = abiDefinitionArray
        self.functions = try self.parseFunctions()
    }
    
    private func parseFunctions() throws -> [String: Function] {
        var result: [String: Function] = [String: Function]()
        for functionDict: [String: Any] in self.abiDefinition {
            if let function = try Function.parse(functionDict: functionDict) {
                result[function.name] = function
            }
        }
        return result
    }
    
}
