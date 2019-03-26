//
//  EthRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

protocol EthRPC {
    var pocket: PocketCore {get set}
    var netID: Int {get set}
    var network: String {get set}
    func send(transaction: Transaction, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func sendTransaction(for wallet: Wallet, with params: [AnyHashable : Any], onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func getBalance(address: String, blockTag: DefaultBlock, onSuccess: @escaping (Int64) -> (), onError: @escaping (Error) -> ())
}

extension EthRPC {
    func createEthRelay(ethMethod: EthRPCMethod, params: [String]) throws -> Relay?  {
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
    
    func getInteger(dic: [String: Any]?) throws -> Int64 {
        guard let result: Int64 = (dic?["result"] as? String)?.toHex() else {
            throw PocketError.custom(message: "Error parsing get balance response")
        }
        
        return result
    }
}
