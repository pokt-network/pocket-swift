//
//  Network.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Network {
    let eth: EthRPC
    
    init(eth: EthRPC) {
        self.eth = eth
    }
}
