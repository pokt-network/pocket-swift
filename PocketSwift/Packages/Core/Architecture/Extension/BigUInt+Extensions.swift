//
//  BigUInt+Extensions.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

extension BigUInt {
    func toHexString() -> String {
        let hex = String(self, radix: 16)
        let string = "0x".appending(hex)
        
        return string
    }
}
