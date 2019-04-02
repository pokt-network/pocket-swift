//
//  AionNetwork.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class AionNetwork {
    public let devID: String
    public let netID: String
    public let pocketAion: PocketAion
    
    private let resultKey = "result"
    
    private var _net: AionNetRPC!
    var net: AionNetRPC {
        return _net
    }
    
    private var _eth: AionEthRPC!
    var eth: AionEthRPC {
        return _eth
    }
    
    init(netID: String, pocketAion: PocketAion ) {
        self.devID = pocketAion.devID
        self.netID = netID
        self.pocketAion = pocketAion
        self._eth = AionEthRPC(aionNetwork: self)
        self._net = AionNetRPC(aionNetwork: self)
    }
    // Create Wallet
    public func createWallet() throws -> Wallet {
        do {
            return try self.pocketAion.createWallet(netID: self.netID)
        } catch {
            throw error
        }
    }
    // Import Wallet
    public func importWallet(privateKey: String) throws -> Wallet {
        do {
            return try self.pocketAion.importWallet(privateKey: privateKey, netID: self.netID)
        } catch {
            throw error
        }
    }
    // Create Relay
    public func createAionRelay(method: String, params: [Any]?) throws -> AionRelay {
        return try AionRelay.init(netID: netID, devID: devID, method: method, params: params)
    }
    
    public func send(relay: AionRelay, callback: @escaping StringCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: AionRelay, callback: @escaping BigIntegerCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
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
    
    public func send(relay: AionRelay, callback: @escaping BooleanCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
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
    
    public func send(relay: AionRelay, callback: @escaping JSONObjectCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let resultObj = responseObj[self.resultKey] as? [String: Any]? else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            callback(nil, resultObj)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: AionRelay, callback: @escaping JSONArrayCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
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
    
    public func send(relay: AionRelay, callback: @escaping JSONObjectOrBooleanCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }
            
            guard let resultAny = responseObj[self.resultKey] else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            
            if let objectOrBoolean = try? ObjectOrBoolean.init(objectOrBoolean: resultAny) {
                callback(nil, objectOrBoolean)
            } else {
                callback(nil, nil)
            }
            
            //callback(nil, resultArr)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
}

