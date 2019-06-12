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
    
    /**
        Defines RPC methods to obtain network information(version: network id, listening: see if it can pick up on network information, peerCount: how many peers connected to the network )
    */
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
        Returns the current network id. ("256": Aion  Mainnet, "32": Mastery Testnet)
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
        Returns true if client is actively listening for network connections on the Aion network.
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
        Returns number of peers currently connected to the client on the Aion network.
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
