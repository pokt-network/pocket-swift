//
//  BlockTag.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public enum BlockTag {
    case earliest
    case latest
    case number(_ value: BigInt)
    
    func getValue() -> String {
        switch self {
        case .earliest:
            return "earliest"
        case .latest:
            return "latest"
        case let .number(value):
            return value.toHexString()
        }
    }
    
    static func tagOrLatest(blockTag: BlockTag?) -> BlockTag {
        if let result = blockTag {
            return result
        } else {
            return BlockTag.latest
        }
    }
}
