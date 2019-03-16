//
//  Dynamic.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

class Dynamic {
    var errorCallback: ((_ error: Error?) -> ())? = nil
    func clean() {
        preconditionFailure("This method must be overridden")
    }
}
