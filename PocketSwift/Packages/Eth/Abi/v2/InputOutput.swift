//
//  File.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
public struct InputOutput {
    
    public let name: String
    public let type: String
    
    // private keys
    private let nameKey = "name"
    private let typeKey = "type"
    
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    private init(inputOutputDict: [String: Any]) throws {
        self.name = inputOutputDict[nameKey] as! String
        self.type = inputOutputDict[typeKey] as! String
    }
    
    public static func parse(inputOutputDicts: [[String: Any]]) throws -> [InputOutput] {
        var result: [InputOutput] = [InputOutput]()
        for inputOutputDict in inputOutputDicts {
            result.append(try InputOutput.init(inputOutputDict: inputOutputDict))
        }
        return result
    }
    
}
