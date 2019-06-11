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

    /**
     Allows a user to define a block parameter on how they want to access data from blockchain
        - "earliest" for the earliest/genesis block
        - "latest" - for the latest mined block 
    */
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

    /**
     If none was specified, make the default BlockTag "Latest"
    */ 
    static func tagOrLatest(blockTag: EthBlockTag?) -> EthBlockTag {
        if let result = blockTag {
            return result
        } else {
            return EthBlockTag.latest
        }
    }
}
