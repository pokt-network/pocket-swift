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

class Utils {
    private init(){}
        
    class func areDirty(_ values: String?...) throws -> Bool {
        for value in values {
            if value == nil || value!.isEmpty {
                return false
            }
        }
        return true
    }
    
    class func  areNilOrClean(_ values: (String, Any?)...) -> (result: Bool, property: String) {
        for value in values {
            if value.1 == nil || (value.1 as! String).isEmpty {
                return (true, value.0)
            }
        }
        return (false, "")
    }
    
    class func jsonStringToDictionary(string: String) throws -> [AnyHashable: Any]? {
        guard let object = string.data(using: .utf8, allowLossyConversion: false) else {
            throw JsonSerializationError.jsonToDictError
        }
        
        guard let rawData = try JSONSerialization.jsonObject(with: object, options: .allowFragments) as? [AnyHashable: Any] else {
            throw JsonSerializationError.jsonToDictError
        }
        
        return rawData
    }
    
    class func dictionaryToJsonString(dict: [AnyHashable: Any]?) throws -> String? {
        let object = dict ?? [AnyHashable: Any]()
        let data = try JSONSerialization.data(withJSONObject: object, options: .sortedKeys)
        return String(data: data, encoding: .utf8)
    }
}
