//
//  PocketAion.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import JavaScriptCore



public class PocketAion: Pocket {
    
    public static let NETWORK = "AION"

    public enum Networks: String {
        case MAINNET = "256"
        case MASTERY = "32"
        
        public func netID() -> String {
            return self.rawValue
        }
    }
    
    // Define Network Attributes
    public var defaultNetwork: AionNetwork?
    public var mainnet: AionNetwork?
    public var mastery: AionNetwork?
    public var networks: [String: AionNetwork] = [String: AionNetwork]()
    public let jsContext: JSContext = JSContext()
    
     /**
     Create new instance of Pocket.
     - Parameters:
        - devID : Developer Identifier
        - network: Name of the Blockchain network that is going to be used.
        - netID: Network ID
        - maxNodes: Maximum amount of nodes
        - requestTimeOut: Amount of time in miliseconds that the server is going to wait before returning a TimeOutException
     
     ### Usage Example: ###
     ````
        Pocket(devID: "DEVID1", network: "AION", netID: "32", maxNodes: 5, requestTimeOut: 1000)
     ````
     */
    
    public init(devID: String, netIds: [String], defaultNetID: String = Networks.MASTERY.netID(), maxNodes: Int = 5, requestTimeOut: Int = 10000) throws {
        // Super init
        super.init(devID: devID, network: PocketAion.NETWORK, netIds: netIds, maxNodes: maxNodes, requestTimeOut: requestTimeOut, schedulerProvider: .main)
        // Exception handler for jsContext
        self.jsContext.exceptionHandler = {(context: JSContext?, error: JSValue?) in
            try? self.throwErrorWith(message: error?.toString() ?? "no details")
        }
        
        do {
            let cryptoPolyfillJS = try AionUtils.getFileForResource(name: "crypto-polyfill", ext: "js")
            let promiseJs = try AionUtils.getFileForResource(name: "promiseDeps", ext: "js")
            let bigIntJs = try AionUtils.getFileForResource(name: "bigInt-polyfill", ext: "js")
            let distJS = try AionUtils.getFileForResource(name: "web3Aion", ext: "js")
            // Evaluate script
            self.jsContext.evaluateScript("var window = this;")
            self.jsContext.evaluateScript(cryptoPolyfillJS)
            self.jsContext.evaluateScript(promiseJs)
            self.jsContext.evaluateScript(bigIntJs)
            self.jsContext.evaluateScript(distJS)
            self.jsContext.evaluateScript("var aionInstance = new AionWeb3();")
        }catch let error {
            fatalError(error.localizedDescription)
        }
        
        if (netIds.isEmpty) {
            throw PocketError.custom(message: "netIds cannot be empty")
        }
        var defaultNetwork: AionNetwork?
        netIds.forEach { (netID) in
            let network = self.network(netID)
            if (netID.elementsEqual(defaultNetID)) {
                defaultNetwork = network
            }
        }
        self.defaultNetwork = defaultNetwork
    }
    
    public func network(_ netID: String) -> AionNetwork {
        let result: AionNetwork
        if let networkValue = self.networks[netID] {
            result = networkValue
        } else {
            result = AionNetwork.init(netID: netID, pocketAion: self)
            self.networks[netID] = result
            self.addBlockchain(network: PocketAion.NETWORK, netID: netID)
        }
        
        if (netID.elementsEqual(Networks.MAINNET.netID())) {
            self.mainnet = result
        } else if (netID.elementsEqual(Networks.MASTERY.netID())) {
            self.mastery = result
        }
        
        return result
    }

    private func throwErrorWith(message: String) throws {
        throw PocketError.custom(message: "Unknown error happened: \(message)")
    }
    /**
        Create a wallet by generating public and private keys for Mastery or Mainnet
            - Parameters:
                - netID: Network ID
            - Throws:
                `PocketError.walletCreation`
                if there was an error creating a wallet


        ### Usage Example ###
        ````  
        createWallet(netID: “32”)
        ````
    */
    public func createWallet(netID: String) throws -> Wallet {
        guard let account = self.jsContext.evaluateScript("aionInstance.eth.accounts.create()")?.toObject() as? [AnyHashable: Any] else {
            throw PocketError.walletCreation(message: "Failed to create account")
        }

        guard let privateKey = account["privateKey"] as? String else {
            throw PocketError.walletCreation(message: "Invalid private key")
        }

        guard let address = account["address"] as? String else {
            throw PocketError.walletCreation(message: "Invalid address")
        }

        return Wallet(address: address, privateKey: privateKey, network: PocketAion.NETWORK, netID: netID)
    }
    
    /**
        Import and access a wallet on Mastery or Mainnet network. 
            - Parameters:
                - privateKey: wallet private key
                - netID: Network ID
            - Throws:
                `PocketError.walletCreation`
                if there was an error importing a wallet


        ### Usage Example ###
        ````  
        importWallet(privateKey: "0x0",netID: “32”)
        ````
    */
    public func importWallet(privateKey: String, netID: String) throws -> Wallet {

        if (self.jsContext.evaluateScript("var account = aionInstance.eth.accounts.privateKeyToAccount('\(privateKey)')") != nil) {
            guard let account = self.jsContext.objectForKeyedSubscript("account")?.toObject() as? [AnyHashable: Any] else {
                throw PocketError.walletImport(message: "Failed to create account object")
            }
            guard let address = account["address"] as? String else {
                throw PocketError.walletImport(message: "Failed to import wallet with error")
            }
            guard let privateKey = account["privateKey"] as? String else {
                throw PocketError.walletImport(message: "Failed to import wallet with error")
            }
            return Wallet(address: address, privateKey: privateKey, network: PocketAion.NETWORK, netID: netID)
        }

        throw PocketError.walletImport(message: "Failed to create account js object")
    }
    
    /**
        Signing the transaction before it’s sent to the Aion network.
        - Parameters:
            - privateKey: wallet private key
            - params: Parameters
    */

    internal func signTransaction(params: [String: Any], privateKey: String) throws -> String {
        var signetTx: String?
        // Transaction params
        guard let nonce =  params["nonce"] as? String else {
            throw PocketError.custom(message: "Failed to retrieve nonce")
        }
        
        guard let to =  params["to"] as? String else {
            throw PocketError.custom(message: "Failed to retrieve the receiver of the transaction (to) ")
        }
        // Optional params
        let data = params["data"] as? String ?? ""
        let value =  params["value"] as? String ?? ""
        let gasPrice = params["gasPrice"] as? String ?? ""
        let gas =  params["gas"] as? String ?? ""
        
        // Promise Handler
        let promiseBlock: @convention(block) (JavaScriptCore.JSValue, JavaScriptCore.JSValue) -> () = { (error, result) in
            // Check for errors
            if !error.isNull {
                try? self.throwErrorWith(message: "Failed to sign transaction with error: \(error)")
            }else{
                // Retrieve result object and raw transaction
                let resultObject = result.toObject() as! [AnyHashable: Any]
                
                guard let rawTx = resultObject["rawTransaction"] as? String else {
                    try? self.throwErrorWith(message: "Failed to retrieve signed transaction")
                    return
                }
                // Assign pocket transaction value
                signetTx = rawTx
            }
        }
        
        // Create Window object from js value
        guard let window = self.jsContext.objectForKeyedSubscript("window") else {
            throw PocketError.custom(message: "Failed to retrieve window js object")
        }
        
        // Set the promise block handler to the transactionCreationCallback
        window.setObject(promiseBlock, forKeyedSubscript: "transactionCreationCallback" as NSString)
        
        // Retrieve SignTransaction JS File
        guard let signTxJSStr = try? AionUtils.getFileForResource(name: "signTransaction", ext: "js") else {
            throw PocketError.custom(message: "Failed to retrieve sign-transaction js file")
        }
        
        // Check if is empty and evaluate script with the transaction parameters using string format %@
        if !signTxJSStr.isEmpty {
            let string = String(format: signTxJSStr, nonce, to, value, data, gas, gasPrice, privateKey)
            jsContext.evaluateScript(string)
        }else {
            throw PocketError.custom(message: "Failed to retrieve signed tx js string")
        }
        
        // Clean global objects from context
        removeJSGlobalObjects()
        
        return signetTx ?? ""
    }
    
    private func removeJSGlobalObjects() {
        self.jsContext.evaluateScript("window.transactionCreationCallback = ''")
        self.jsContext.evaluateScript("account = ''")
    }
    
    deinit {
        self.removeJSGlobalObjects()
    }

}
