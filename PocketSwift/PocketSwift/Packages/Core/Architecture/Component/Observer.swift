//
//  Observer.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

typealias Observer<ObservedType> = (_ value: ObservedType) -> ()
