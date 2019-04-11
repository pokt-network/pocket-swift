//
//  EthRPCCallbacks.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public typealias EthStringCallback = (PocketError?, String?) -> Void
public typealias EthBigIntegerCallback = (PocketError?, BigInt?) -> Void
public typealias EthBooleanCallback = (PocketError?, Bool?) -> Void
public typealias EthJSONObjectCallback = (PocketError?, [String: Any]?) -> Void
public typealias EthJSONArrayCallback = (PocketError?, [[String: Any]]?) -> Void
public typealias EthJSONObjectOrBooleanCallback = (PocketError?, EthObjectOrBoolean?) -> Void
public typealias EthAnyArrayCallback = (PocketError?, [Any]?) -> Void
