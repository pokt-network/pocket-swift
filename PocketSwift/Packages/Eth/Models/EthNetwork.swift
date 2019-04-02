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
    
    //public var net: NetRPC
    
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
            let responseObj = response.toDict()
            //if let result = responseObj["result"]
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping BooleanCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping JSONObjectCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping JSONArrayCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping JSONObjectOrBooleanCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func send(relay: EthRelay, callback: @escaping AnyArrayCallback) {
        self.pocketEth.send(relay: relay, onSuccess: { (response) in
            
        }) { (error) in
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
}
