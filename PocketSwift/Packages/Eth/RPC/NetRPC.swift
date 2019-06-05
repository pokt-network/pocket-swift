//
//  NetRPC.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public struct NetRPC {
    
    private enum NetRPCMethod: String {
        case version = "net_version"
        case listening = "net_listening"
        case peerCount = "net_peerCount"
    }
    
    private let ethNetwork: EthNetwork
    
    init(ethNetwork: EthNetwork) {
        self.ethNetwork = ethNetwork
    }
    /**
        Returns the current network id. ("1": Ethereum Mainnet, "4": Rinkeby Testnet, etc)
     */    
    public func version(callback: @escaping EthStringCallback) {
        do {
            let ethRelay = try EthRelay.init(netID: self.ethNetwork.netID, devID: ethNetwork.devID, method: NetRPCMethod.version.rawValue, params: nil)
            self.ethNetwork.send(relay: ethRelay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    /**
        Returns true if client is actively listening for network connections on the ETH network.
     */    
    public func listening(callback: @escaping EthBooleanCallback) {
        do {
            let ethRelay = try EthRelay.init(netID: self.ethNetwork.netID, devID: ethNetwork.devID, method: NetRPCMethod.listening.rawValue, params: nil)
            self.ethNetwork.send(relay: ethRelay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    /**
        Returns number of peers currently connected to the client on the ETH network.
     */    
    public func peerCount(callback: @escaping EthBigIntegerCallback) {
        do {
            let ethRelay = try EthRelay.init(netID: self.ethNetwork.netID, devID: ethNetwork.devID, method: NetRPCMethod.peerCount.rawValue, params: nil)
            self.ethNetwork.send(relay: ethRelay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
}
