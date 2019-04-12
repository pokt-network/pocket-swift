//
//  EthNetwork.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import secp256k1_swift
import Web3swift

public class EthNetwork {
    
    public let devID: String
    public let netID: String
    public let pocketEth: PocketEth
    
    private let resultKey = "result"
    
    private var _net: NetRPC!
    public var net: NetRPC {
        return _net
    }
    
    private var _eth: EthRPC!
    public var eth: EthRPC {
        return _eth
    }
    
    init(netID: String, pocketEth: PocketEth) {
        self.netID = netID
        self.pocketEth = pocketEth
        self.devID = pocketEth.devID
        self._eth = EthRPC.init(ethNetwork: self)
        self._net = NetRPC.init(ethNetwork: self)
    }
    
    public func importWallet(privateKey: String) throws -> Wallet {
        let privateKeyData = Data(hex: privateKey)
        guard let keyStore = PlainKeystore.init(privateKey: privateKeyData) else {
            throw PocketError.walletImport(message: "Invalid private key")
        }
        return try EthNetwork.walletFromKeystore(keyStore: keyStore, netID: self.netID)
    }
    
    public func createWallet() throws -> Wallet {
        guard let privateKey = SECP256K1.generatePrivateKey() else {
            throw PocketError.walletCreation(message: "Invalid private key generated")
        }
        guard let keyStore = PlainKeystore.init(privateKey: privateKey) else {
            throw PocketError.walletCreation(message: "Invalid private key generated")
        }
        return try EthNetwork.walletFromKeystore(keyStore: keyStore, netID: self.netID)
    }
    
    public func createEthRelay(method: String, params: [Any]?) throws -> EthRelay {
        return try EthRelay.init(netID: netID, devID: devID, method: method, params: params)
    }
    
    public func send(relay: EthRelay, callback: @escaping EthStringCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let result = responseObj[self.resultKey] as? String? else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            
            callback(nil, result)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping EthBigIntegerCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let result = responseObj[self.resultKey] as? String? else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            
            let bigIntResult = result?.toBigInt()
            callback(nil, bigIntResult)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping EthBooleanCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let boolResult = responseObj[self.resultKey] as? Bool? else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            callback(nil, boolResult)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping EthJSONObjectCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            let result = responseObj[self.resultKey] as? [String: Any]?
            if result == nil {
                callback(nil, nil)
            } else {
                callback(nil, result ?? [String: Any]())
            }
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping EthJSONArrayCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let resultArr = responseObj[self.resultKey] as? [[String: Any]]? else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            
            callback(nil, resultArr)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping EthJSONObjectOrBooleanCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let resultAny = responseObj[self.resultKey] else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            
            if let objectOrBoolean = try? EthObjectOrBoolean.init(objectOrBoolean: resultAny) {
                 callback(nil, objectOrBoolean)
            } else {
                callback(nil, nil)
            }
           
            //callback(nil, resultArr)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func createEthContract(address: String, abiDefinition: String) throws -> EthContract {
        return try EthContract.init(ethNetwork: self, address: address, abiDefinition: abiDefinition)
    }
    
    // Private interface
    private static func walletFromKeystore(keyStore: PlainKeystore, netID: String) throws -> Wallet {
        guard let address = keyStore.addresses?.first else {
            throw PocketError.custom(message: "Error reading wallet data")
        }
        let keystorePrivateKey = try keyStore.UNSAFE_getPrivateKeyData(account: address).toHexString()
        let wallet = Wallet.init(address: address.address, privateKey: keystorePrivateKey, network: PocketEth.NETWORK, netID: netID)
        return wallet
    }
    
}
