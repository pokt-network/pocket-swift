//
//  RelayData.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

struct RelayData: Input {
    let jsonrpc: String
    let method: String
    let params: [String]
    
    init(jsonrpc: String, method: String, params: [String]) {
        self.jsonrpc = jsonrpc
        self.method = method
        self.params = params
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("jsonrpc", self.jsonrpc, "method", self.method, "params", self.params)
        return data
    }
}
