//
//  Utils.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public enum JsonSerializationError: Error {
    case jsonToDictError
    case jsonToArrayError
}

/**
 Pocket Core Utility class
 */

class Utils {
    private init(){}
    
    /**
     Method used to pre-check for null or empty values.
     - Parameters:
        - values : the values to be pre-checked
     
     - Throws: `Error` if params are invalid.
     - Returns: true if values are valid
     */
    class func areDirty(_ values: String?...) throws -> Bool {
        for value in values {
            if value == nil || value!.isEmpty {
                return false
            }
        }
        return true
    }
    
    /**
     Method used to pre-check for null or empty values.
     - Parameters:
        - values : the values to be pre-checked
     
     - Throws: `Error` if params are invalid.
     - Returns: tuple with the value of the property and a boolean that determines if values are valid
     */
    class func  areNilOrClean(_ values: (String, Any?)...) -> (result: Bool, property: String) {
        for value in values {
            if value.1 == nil || (value.1 as! String).isEmpty {
                return (true, value.0)
            }
        }
        return (false, "")
    }
    
    
    /**
     Method used to convert a JSON into a Dictionary.
     - Parameters:
        - string : the JSON object as string
     
     - Throws: `Error` if string is not a valid JSON
     - Returns: Dictionary that represents the JSON Object
     */
    class func jsonStringToDictionary(string: String) throws -> [AnyHashable: Any]? {
        guard let object = string.data(using: .utf8, allowLossyConversion: false) else {
            throw JsonSerializationError.jsonToDictError
        }
        
        guard let rawData = try JSONSerialization.jsonObject(with: object, options: .allowFragments) as? [AnyHashable: Any] else {
            throw JsonSerializationError.jsonToDictError
        }
        
        return rawData
    }
    /**
     Method used to serialize a Dictionary into a JSON.
     - Parameters:
     - dic : the JSON object as Dictionary
     
     - Throws: `Error` if string is not a valid JSON
     - Returns: String that represents the JSON Object
     */
    static func serializeObjectToJson(object: [AnyHashable: Any]) throws -> String? {
        do {
            if #available(iOS 11.0, *) {
                let data = try JSONSerialization.data(withJSONObject: object, options: .sortedKeys)
                return String(data: data, encoding: .utf8)
            } else {
                // Fallback on earlier versions
                let data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
                return String(data: data, encoding: .utf8)
            }
        } catch {
            throw error
        }

    }
    /**
     Method used to convert a Dictionary into a JSON.
     - Parameters:
        - dic : the JSON object as Dictionary
     
     - Throws: `Error` if string is not a valid JSON
     - Returns: String that represents the JSON Object
     */
    class func dictionaryToJsonString(dict: [AnyHashable: Any]?) throws -> String? {
        let object = dict ?? [AnyHashable: Any]()
        
        return try Utils.serializeObjectToJson(object: object)
    }
}
