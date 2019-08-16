//
//  Dictionary+Extension.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/6/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    mutating func fill(_ data: Any?...) {
        if data.count % 2 != 0 {
            fatalError("You need to add pair values")
        }
        
        var key: Int = 0
        repeat {
            if data[key + 1] == nil {
                key += 2
                continue
            }
            
            self[data[key] as! String] = data[key + 1]
            key += 2
        } while key < data.count - 1
    }
    
    func toJson() throws -> String? {
        return try Utils.serializeObjectToJson(object: self)
    }
    
    func hasError() -> (Bool, String?) {
        if self["error"] != nil {
            return (true, (self["error"] as! [String: Any])["message"] as? String)
        }
        return (false, nil)
    }
}
