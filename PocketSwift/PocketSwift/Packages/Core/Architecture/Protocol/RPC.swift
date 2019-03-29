//
//  RPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

protocol RPC {
    var pocket: PocketCore {get set}
    var netID: Int {get set}
    var network: String {get set}
}

extension RPC {
    func createEthRelay(ethMethod: EthRPCMethod, params: [Any]) throws -> Relay?  {
        do{
            let relayData: RelayData = RelayData(jsonrpc: "2.0", method: ethMethod.rawValue, params: params)
            
            guard let relayDataJson = try relayData.toParameters().toJson() else {
                throw PocketError.invalidRelay
            }
            
            let relay: Relay = self.pocket.createRelay(blockchain: self.network, netID: self.netID, data: relayDataJson, devID: self.pocket.configuration.devID)
            return relay
        }catch let error {
            throw error
        }
    }
    
    func createNetRelay(netMethod: NetRPCMethod, params: [Any] = []) throws -> Relay?  {
        do{
            let relayData: RelayData = RelayData(jsonrpc: "2.0", method: netMethod.rawValue, params: params)
            
            guard let relayDataJson = try relayData.toParameters().toJson() else {
                throw PocketError.invalidRelay
            }
            
            let relay: Relay = self.pocket.createRelay(blockchain: self.network, netID: self.netID, data: relayDataJson, devID: self.pocket.configuration.devID)
            return relay
        }catch let error {
            throw error
        }
    }
    
    func getInteger(dic: [String: Any]?) throws -> BigInt {
        guard let result: BigInt = (dic?["result"] as? String)?.toHex() else {
            throw PocketError.custom(message: "Error parsing integer response")
        }
        
        return result
    }
    
    func getString(dic: [String: Any]?) throws -> String {
        guard let result: String = (dic?["result"] as? String) else {
            throw PocketError.custom(message: "Error parsing string response")
        }
        
        return result
    }
    
    func getBool(dic: [String: Any]?) throws -> Bool {
        guard let result: Bool = (dic?["result"] as? Bool) else {
            throw PocketError.custom(message: "Error parsing bool response")
        }
        
        return result
    }
    
    func getJSON(dic: [String: Any]?) throws -> [String: Any] {
        guard let result: [String: Any] = (dic?["result"] as? [String: Any]) else {
            throw PocketError.custom(message: "Error parsing JSON response")
        }
        return result
    }
    
    func getJSONArray(dic: [String: Any]?) throws -> [[String: Any]] {
        guard let result: [[String: Any]] = (dic?["result"] as? [[String: Any]]) else {
            throw PocketError.custom(message: "Error parsing JSON Array response")
        }
        
        return result
    }
}
