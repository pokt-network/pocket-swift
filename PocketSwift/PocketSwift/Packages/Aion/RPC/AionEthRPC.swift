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
    private let network: String
    
    
    init(pocketAion: PocketAion) {
        self.pocket = pocketAion
        self.network = pocketAion.network
    }
        
    public func send(transaction: Transaction, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do {
            let relayData: RelayData = RelayData(jsonrpc: "2.0", method: EthRPCMethod.sendTransaction.rawValue, params: [transaction.serializedTransaction])
            
            guard let relayDataJson = try relayData.toParameters().toJson() else {
                onError(PocketError.invalidRelay)
                return
            }
            
            let relay: Relay = self.pocket.createRelay(blockchain: self.network, netID: 4, data: relayDataJson, devID: self.pocket.configuration.devID)
            self.pocket.send(relay: relay, onSuccess: { response in
                    
            }, onError: { error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
}

