//
//  BigInt+Extensions.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/26/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public extension BigInt {
    func toHexString() -> String {
        let hex = String(self, radix: 16)
        let string = "0x".appending(hex)
        
        return string
    }
    
    func noPrefixHex() -> String {
        return String(self, radix: 16)
    }
}
