//
//  DefaultBlock.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/25/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public enum DefaultBlock {
    case earliest
    case latest
    case pending
    case number(_ value: BigInt)
    
    func getValue() -> String {
        switch self {
        case .earliest:
            return "earliest"
        case .latest:
            return "latest"
        case let .number(value):
            return value.toHexString()
        default:
            return "pending"
        }
    }
    
    func getNumber() -> String {
        switch self {
        case let .number(value):
            return value.toHexString()
        default:
            return "0x0"
        }
    }
    
}
