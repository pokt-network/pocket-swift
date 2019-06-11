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
        }
    }

    /**
     If none was specified, make the default BlockTag "Latest"
    */
    static func tagOrLatest(blockTag: BlockTag?) -> BlockTag {
        if let result = blockTag {
            return result
        } else {
            return BlockTag.latest
        }
    }
}
