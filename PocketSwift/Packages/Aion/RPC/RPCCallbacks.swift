//
//  RPCCallbacks.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public typealias StringCallback = (PocketError?, String?) -> Void
public typealias BigIntegerCallback = (PocketError?, BigInt?) -> Void
public typealias BooleanCallback = (PocketError?, Bool?) -> Void
public typealias JSONObjectCallback = (PocketError?, [String: Any]?) -> Void
public typealias JSONArrayCallback = (PocketError?, [[String: Any]]?) -> Void
public typealias JSONObjectOrBooleanCallback = (PocketError?, ObjectOrBoolean?) -> Void
public typealias AnyArrayCallback = (PocketError?, [Any]?) -> Void
