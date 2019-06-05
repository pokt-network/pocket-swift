//
//  AionNetRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/25/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public struct AionNetRPC {
    
    private enum NetRPCMethod: String {
        case version = "net_version"
        case listening = "net_listening"
        case peerCount = "net_peerCount"
    }
    
    private let aionNetwork: AionNetwork
    
    init(aionNetwork: AionNetwork) {
        self.aionNetwork = aionNetwork
    }
    /**
        Returns the current network id. ("1": Ethereum Mainnet, "4": Rinkeby Testnet, etc)
     */      
    public func version(callback: @escaping StringCallback) {
        do {
            let aionRelay = try AionRelay.init(netID: self.aionNetwork.netID, devID: aionNetwork.devID, method: NetRPCMethod.version.rawValue, params: nil)
            self.aionNetwork.send(relay: aionRelay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    /**
        Returns true if client is actively listening for network connections on the ETH network.
     */       
    public func listening(callback: @escaping BooleanCallback) {
        do {
            let aionRelay = try AionRelay.init(netID: self.aionNetwork.netID, devID: aionNetwork.devID, method: NetRPCMethod.listening.rawValue, params: nil)
            self.aionNetwork.send(relay: aionRelay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    /**
        Returns number of peers currently connected to the client on the ETH network.
     */     
    public func peerCount(callback: @escaping BigIntegerCallback) {
        do {
            let aionRelay = try AionRelay.init(netID: self.aionNetwork.netID, devID: aionNetwork.devID, method: NetRPCMethod.peerCount.rawValue, params: nil)
            self.aionNetwork.send(relay: aionRelay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
}
