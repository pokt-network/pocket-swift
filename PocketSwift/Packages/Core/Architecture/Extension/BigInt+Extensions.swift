//
//  Int64+Extensions.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/26/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

extension BigInt {
    func toHexString() -> String {
        let hex = String(self, radix: 16)
        let string = "0x".appending(hex)
        
        return string
    }
}
