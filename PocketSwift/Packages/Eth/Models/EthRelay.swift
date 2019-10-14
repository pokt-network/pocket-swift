//
//  EthRelay.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class EthRelay: Relay {
    
    private let relayData: RelayData
    
    /**
     Eth Relay RPC model class
        - Parameters:
            - netID: the netId of the blockchain.
            - devID: the id used to interact with Pocket Api.
            - method: RPC method.
            - params: extra params.
     
     - SeeAlso: `RelayData`
     */
    init(netID: String, devID: String, method: String, params: [Any]?) throws {
        self.relayData = RelayData.init(method: method, params: params)
        let data = try self.relayData.toParameters().toJson() ?? "{}"
        super.init(network: PocketEth.NETWORK, netID: netID, data: data, devID: devID, httpMethod: nil, path: nil, queryParams: nil, headers: nil)
    }
    
    required init(from decoder: Decoder) throws {
        self.relayData = RelayData.init(method: "blank_method", params: [])
        try super.init(from: decoder)
    }
    
    private struct RelayData: Input {
        let jsonrpc = "2.0"
        let method: String
        let params: [Any]
        let id = Int(Date().timeIntervalSince1970)
        
        init(method: String, params: [Any]?) {
            self.method = method
            if let params = params {
                self.params = params
            } else {
                self.params = []
            }
        }
        
        func toParameters() -> Parameters {
            var data: Parameters = [:]
            data.fill("jsonrpc", self.jsonrpc, "method", self.method, "params", self.params, "id", self.id)
            return data
        }
    }
    
}
