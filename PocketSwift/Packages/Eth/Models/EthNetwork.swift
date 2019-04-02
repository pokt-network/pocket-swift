//
//  EthNetwork.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
public class EthNetwork {
    
    public let devID: String
    public let netID: String
    public let pocketEth: PocketEth
    
    private let resultKey = "result"
    
    private var _net: NetRPC!
    var net: NetRPC {
        return _net
    }
    
    private var _eth: EthRPC!
    var eth: EthRPC {
        return _eth
    }
    
    init(netID: String, pocketEth: PocketEth) {
        self.netID = netID
        self.pocketEth = pocketEth
        self.devID = pocketEth.devID
        self._eth = EthRPC.init(ethNetwork: self)
        self._net = NetRPC.init(ethNetwork: self)
    }
    
    public func createEthRelay(method: String, params: [Any]?) throws -> EthRelay {
        return try EthRelay.init(netID: netID, devID: devID, method: method, params: params)
    }
    
    public func send(relay: EthRelay, callback: @escaping StringCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping BigIntegerCallback) {
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
    
    public func send(relay: EthRelay, callback: @escaping BooleanCallback) {
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
    
    public func send(relay: EthRelay, callback: @escaping JSONObjectCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
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
    
    public func send(relay: EthRelay, callback: @escaping JSONArrayCallback) {
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
    
    public func send(relay: EthRelay, callback: @escaping JSONObjectOrBooleanCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
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
