//
//  Utils.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

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
    
    class func  areNilOrClen(_ values: (String, Any?)...) -> (result: Bool, property: String) {
        for value in values {
            if value.1 == nil || (value.1 as! String).isEmpty {
                return (true, value.0)
            }
        }
        return (false, "")
    }
}
