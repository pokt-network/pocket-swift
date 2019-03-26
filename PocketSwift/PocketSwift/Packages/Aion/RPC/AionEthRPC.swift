//
//  AionRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct AionEthRPC: EthRPC {
    
    var pocket: PocketCore
    var netID: Int
    var network: String
    
    private let pocketAion: PocketAion
    
    
    init(pocketAion: PocketAion, netID: Int) {
        self.pocket = pocketAion
        self.network = pocketAion.network
        self.netID = netID
        self.pocketAion = pocketAion
    }
        
    public func send(transaction: Transaction, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do {
            guard let relay = try createEthRelay(ethMethod: EthRPCMethod.sendTransaction, params: [transaction.serializedTransaction]) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                
            }, onError: { error in
                onError(error)
            })
        }catch let error {
            onError(error)
        }
    }
    
    func sendTransaction(for wallet: Wallet, with params: [AnyHashable : Any], onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do {
            let transaction: Transaction = try self.pocketAion.createTransaction(wallet: wallet, params: params)
            send(transaction: transaction, onSuccess: onSuccess, onError: onError)
        } catch let error {
            onError(error)
        }
    }
    
    func getBalance(address: String, blockTag: DefaultBlock, onSuccess: @escaping (Int64) -> (), onError: @escaping (Error) -> ()) {
        do {
            let params: [String] = [address, blockTag.rawValue]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getBalance, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
    
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get balance response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
        
        
    }
}

