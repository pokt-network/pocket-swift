//
//  Error+Extensions.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
