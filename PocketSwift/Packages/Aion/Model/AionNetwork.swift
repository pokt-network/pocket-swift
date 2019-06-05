//
//  AionNetwork.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public class AionNetwork {
    public let devID: String
    public let netID: String
    public let pocketAion: PocketAion
    
    private let resultKey = "result"
    
    private var _net: AionNetRPC!
    public var net: AionNetRPC {
        return _net
    }
    
    private var _eth: AionEthRPC!
    public var eth: AionEthRPC {
        return _eth
    }
    
    init(netID: String, pocketAion: PocketAion ) {
        self.devID = pocketAion.devID
        self.netID = netID
        self.pocketAion = pocketAion
        self._eth = AionEthRPC(aionNetwork: self)
        self._net = AionNetRPC(aionNetwork: self)
    }
    /**
        Creates a new Aion Wallet:
            - Parameters: none
            - Throws: `error`

         ### Usage Example: ###
         ````
            pocketAion.mastery?.createWallet()
        ````
    */     
    public func createWallet() throws -> Wallet {
        do {
            return try self.pocketAion.createWallet(netID: self.netID)
        } catch {
            throw error
        }
    }
    /**
     Import an existing Aion Wallet
     - Parameters:
        - privateKey: Wallet private key

     ### Usage Example: ###
     ````
        pocketAion.mastery?.importWallet(privateKey: 'your_private_key')
     ````
     */ 
    public func importWallet(privateKey: String) throws -> Wallet {
        do {
            return try self.pocketAion.importWallet(privateKey: privateKey, netID: self.netID)
        } catch {
            throw error
        }
    }
    /**
        Creates a relay to send to the Service Node 
    */
    public func createAionRelay(method: String, params: [Any]?) throws -> AionRelay {
        return try AionRelay.init(netID: netID, devID: devID, method: method, params: params)
    }
    /**
        Sends a relay request to the Service Node and callback returns a string or error
    */       
    public func send(relay: AionRelay, callback: @escaping StringCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
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
    /**
        Sends a relay request to the Service Node and callback returns a BigInteger or error
    */     
    public func send(relay: AionRelay, callback: @escaping BigIntegerCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
            guard let responseObj = response.toDict() else {
                callback(PocketError.custom(message: "Error parsing relay response \(response)"), nil)
                return
            }

            guard let result = responseObj[self.resultKey] else {
                callback(PocketError.custom(message: "Error parsing relay response result: \(response)"), nil)
                return
            }
            
            let resultStr = "\(result)"
            
            let bigIntResult = resultStr.toBigInt()
            callback(nil, bigIntResult)
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    /**
        Sends a relay request to the Service Node and callback returns a Bool or error
    */       
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
    /**
        Sends a relay request to the Service Node and callback returns a JSONObject or error
    */     
    public func send(relay: AionRelay, callback: @escaping JSONObjectCallback) {
        self.pocketAion.send(relay: relay, onSuccess: { (response) in
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
    /**
        Sends a relay request to the Service Node and callback returns a JSONArray or error
    */     
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
    /**
        Sends a relay request to the Service Node and callback returns a JSONObjectOrBoolean or error
    */     
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

