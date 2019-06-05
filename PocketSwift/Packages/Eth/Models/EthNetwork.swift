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
    /**
     Initialize Pocket ETH
        - Parameters:
            - netIds: Network ID number
            - pocketEth: PocketEth
       
         ### Usage Example: ###
        ````
            Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
        ````
     */
    init(netID: String, pocketEth: PocketEth) {
        self.netID = netID
        self.pocketEth = pocketEth
        self.devID = pocketEth.devID
        self._eth = EthRPC.init(ethNetwork: self)
        self._net = NetRPC.init(ethNetwork: self)
    }

    /**
     Import an existing ETH Wallet
     - Parameters:
        - privateKey: Wallet private key

     ### Usage Example: ###
     ````
        pocketEth.rinkeby.importWallet(privateKey: PRIVATE_KEY)
     ````
     */
    
    public func importWallet(privateKey: String) throws -> Wallet {
        let privateKeyData = Data(hex: privateKey)
        guard let keyStore = PlainKeystore.init(privateKey: privateKeyData) else {
            throw PocketError.walletImport(message: "Invalid private key")
        }
        return try EthNetwork.walletFromKeystore(keyStore: keyStore, netID: self.netID)
    }

    /**
        Creates a new ETH Wallet:
            - Parameters: none
            - Throws: `PocketError.walletCreation`
                Invalid private key generated

         ### Usage Example: ###
         ````
            pocketEth.rinkeby.createWallet()
        ````
    */    
    
    public func createWallet() throws -> Wallet {
        guard let privateKey = SECP256K1.generatePrivateKey() else {
            throw PocketError.walletCreation(message: "Invalid private key generated")
        }
        guard let keyStore = PlainKeystore.init(privateKey: privateKey) else {
            throw PocketError.walletCreation(message: "Invalid private key generated")
        }
        return try EthNetwork.walletFromKeystore(keyStore: keyStore, netID: self.netID)
    }
    /**
        Creates a relay to send to the Service Node 
    */
    public func createEthRelay(method: String, params: [Any]?) throws -> EthRelay {
        return try EthRelay.init(netID: netID, devID: devID, method: method, params: params)
    }
    /**
        Sends a relay request to the Service Node and callback returns a string or error
    */    
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
    /**
        Sends a relay request to the Service Node and callback returns a BigInteger or error
    */     
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
    /**
        Sends a relay request to the Service Node and callback returns a Bool or error
    */      
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
    /**
        Sends a relay request to the Service Node and callback returns a JSONObject or error
    */      
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

    /**
        Sends a relay request to the Service Node and callback returns a JSONArray or error
    */     
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
    /**
        Sends a relay request to the Service Node and callback returns a JSONObjectOrBoolean or error
    */      
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
/**
        Initializes an Eth contract:
            - Parameters:
                - address: contract address
                - abi: smart contract application binary interface 
            - returns: 
                Initialized Eth contract with the associated network 

         ### Usage Example: ###
         ````
            createEthContract(address: "0x...", abiDefinition: '[]')
        ````
    */        
    public func createEthContract(address: String, abiDefinition: String) throws -> EthContract {
        return try EthContract.init(ethNetwork: self, address: address, abiDefinition: abiDefinition)
    }
    /**
        Retrieve Wallet from Keychain:
            - Parameters:
                - netID: Network identifier
                - keyStore: 
            - returns: 
                Initialized Eth contract with the associated network 

        ### Usage Example: ###
        ````
            createEthContract(address: "0x...", abiDefinition: '[]')
        ````
    */           
    private static func walletFromKeystore(keyStore: PlainKeystore, netID: String) throws -> Wallet {
        guard let address = keyStore.addresses?.first else {
            throw PocketError.custom(message: "Error reading wallet data")
        }
        let keystorePrivateKey = try keyStore.UNSAFE_getPrivateKeyData(account: address).toHexString()
        let wallet = Wallet.init(address: address.address, privateKey: keystorePrivateKey, network: PocketEth.NETWORK, netID: netID)
        return wallet
    }
    
}
