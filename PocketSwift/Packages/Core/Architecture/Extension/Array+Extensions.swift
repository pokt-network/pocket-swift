//
//  Array+Extensions.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/17/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

extension Array {
    
    func toString() -> String {
        var result: String = ""
        self.forEach { element in
            result.append("\(element), ")
        }
        
        return result
    }
}
