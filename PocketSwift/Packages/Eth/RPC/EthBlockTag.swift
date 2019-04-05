//
//  EthBlockTag.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public enum EthBlockTag {
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
    
    static func tagOrLatest(blockTag: EthBlockTag?) -> EthBlockTag {
        if let result = blockTag {
            return result
        } else {
            return EthBlockTag.latest
        }
    }
}
