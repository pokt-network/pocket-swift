//
//  NodeNotFoundError.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/17/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public enum PocketError: Error {
    case nodeNotFound
    case invalidRelay
    case invalidReport
    case invalidAddress
    case invalidParameter(message: String)
    case custom(message: String)
    case walletCreation(message: String)
    case walletImport(message: String)
    case walletPersistence(message: String)
}

extension PocketError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidAddress:
            return NSLocalizedString("The address provided is invalid", comment: "The address provided is invalid")
        case .nodeNotFound:
            return NSLocalizedString("Node is empty;", comment: "Node is empty")
        case .invalidRelay:
            return NSLocalizedString("Relay is missing a property, please verify all properties.", comment: "Relay is missing a property, please verify all properties.")
        case .invalidReport:
            return NSLocalizedString("Report is missing a property, please verify all properties.", comment: "Report is missing a property, please verify all properties.")
        case let .invalidParameter(message),
             let .custom(message),
             let .walletCreation(message),
             let .walletPersistence(message),
             let .walletImport(message):
            return NSLocalizedString(message, comment: message)
        }
    }
}
