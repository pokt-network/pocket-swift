//
//  NodeNotFoundError.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/17/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

enum PocketError: Error {
    case nodeNotFound
    case invalidRelay
    case custom(message: String)
}

extension PocketError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .nodeNotFound:
            return NSLocalizedString("Node is empty;", comment: "Node is empty")
        case .invalidRelay:
            return NSLocalizedString("Relay is missing a property, please verify all properties.", comment: "Relay is missing a property, please verify all properties.")
        case let .custom(message) :
            return NSLocalizedString(message, comment: message)
        }
    }
}
