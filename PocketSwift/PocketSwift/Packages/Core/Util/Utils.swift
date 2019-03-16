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
        
    class func  areDirty(_ values: String...) throws -> Bool {
        for value in values {
            if value.isEmpty {
                return false
            }
        }
        return true
    }
}
