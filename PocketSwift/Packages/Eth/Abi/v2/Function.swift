//
//  Function.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
public struct Function {
    
    public let name: String
    public let constant: Bool
    public let payable: Bool
    public let inputs: [InputOutput]
    public let outputs: [InputOutput]
    
    // Private constants
    private static let constantKey = "constant"
    private static let inputsKey = "inputs"
    private static let nameKey = "name"
    private static let outputsKey = "outputs"
    private static let payableKey = "payable"
    private static let typeKey = "type"
    private static let functionTypeValue = "function"
    
    public init(name: String, constant: Bool, payable: Bool, inputs: [InputOutput], outputs: [InputOutput]) {
        self.name = name
        self.constant = constant
        self.payable = payable
        self.inputs = inputs
        self.outputs = outputs
    }
    
    public static func parse(functionDict: [String: Any]) throws -> Function? {
        if let type = functionDict[constantKey] as? String {
            if (!type.elementsEqual(functionTypeValue)) {
                return nil
            }
        }
        let name = functionDict[nameKey] as! String
        let constant = functionDict[constantKey] as! Bool
        let payable = functionDict[payableKey] as! Bool
        let inputs = try InputOutput.parse(inputOutputDicts: functionDict[inputsKey] as! [[String: Any]])
        let outputs = try InputOutput.parse(inputOutputDicts: functionDict[outputsKey] as! [[String: Any]])
        return Function.init(name: name, constant: constant, payable: payable, inputs: inputs, outputs: outputs)
    }
}
