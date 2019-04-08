//
//  BigUInt+Extensions.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public extension BigUInt {
    func toHexString() -> String {
        let hex = String(self, radix: 16)
        let string = "0x".appending(hex)
        
        return string
    }
    
    func noPrefixHex() -> String {
        return String(self, radix: 16)
    }
}
