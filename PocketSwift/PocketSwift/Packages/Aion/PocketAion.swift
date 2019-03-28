//
//  PocketAion.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import JavaScriptCore

public class PocketAion: PocketCore, PocketPlugin {
    var NETWORK: String = "AION"
    private let jsContext: JSContext = JSContext()
    private var networks: [Int: Network] = [:]
    
    init(devID: String, netIDs: [Int], maxNodes: Int = 5, requestTimeOut: Int = 1000, schedulerProvider: SchedulerProvider) {
        super.init(devID: devID, networkName: self.NETWORK, netIDs: netIDs, maxNodes: maxNodes, requestTimeOut: requestTimeOut, schedulerProvider: schedulerProvider)
        
        self.jsContext.exceptionHandler = {(context: JSContext?, error: JSValue?) in
            try? self.throwErrorWith(message: error?.toString() ?? "no details")
        }
        
        do {
            let cryptoPolyfillJS = try AionUtils.getFileForResource(name: "crypto-polyfill", ext: "js")
            let promiseJs = try AionUtils.getFileForResource(name: "promiseDeps", ext: "js")
            let bigIntJs = try AionUtils.getFileForResource(name: "bigInt-polyfill", ext: "js")
            let distJS = try AionUtils.getFileForResource(name: "web3Aion", ext: "js")
            
            self.jsContext.evaluateScript("var window = this;")
            self.jsContext.evaluateScript(cryptoPolyfillJS)
            self.jsContext.evaluateScript(promiseJs)
            self.jsContext.evaluateScript(bigIntJs)
            self.jsContext.evaluateScript(distJS)
            self.jsContext.evaluateScript("var aionInstance = new AionWeb3();")
        }catch let error {
            fatalError(error.localizedDescription)
        }
        
        netIDs.forEach{ netID in
            self.networks[netID] = Network(eth: AionEthRPC(pocketAion: self, netID: netID), net: AionNetRPC(pocketAion: self, netID: netID))
        }
        
    }
    
    public convenience init(devID: String, netIDs: [Int], maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        self.init(devID: devID, netIDs: netIDs, maxNodes: maxNodes, requestTimeOut: requestTimeOut, schedulerProvider: .main)
    }
    
    public convenience init(devID: String, netID: Int, maxNodes: Int = 5, requestTimeOut: Int = 1000) {
        let netIDs: [Int] = [netID]
        self.init(devID: devID, netIDs: netIDs, maxNodes: maxNodes, requestTimeOut: requestTimeOut)
    }
    
    public func network(_ netID: Int) -> Network {
        if !self.networks.keys.contains(netID) {
            fatalError("The Network ID provided is not available")
        }
        return self.networks[netID]!
    }
    
    
    private func throwErrorWith(message: String) throws {
        throw PocketError.custom(message: "Unknown error happened: \(message)")
    }
    
    override public func createWallet(networkID: Int, data: [AnyHashable : Any]?) throws -> Wallet {
        guard let account = self.jsContext.evaluateScript("aionInstance.eth.accounts.create()")?.toObject() as? [AnyHashable: Any] else {
            throw PocketError.walletCreation(message: "Failed to create account")
        }
        
        guard let privateKey = account["privateKey"] as? String else {
            throw PocketError.walletCreation(message: "Invalid private key")
        }
        
        guard let address = account["address"] as? String else {
            throw PocketError.walletCreation(message: "Invalid address")
        }
        
        return Wallet(address: address, privateKey: privateKey, networkID: networkID, data: data)
    }
    
    override public func importWallet(address: String?, privateKey: String, networkID: Int, data: [AnyHashable : Any]?) throws -> Wallet {
        guard let publicKey = address else {
            throw PocketError.walletImport(message: "Invalid public key")
        }
        
        if (self.jsContext.evaluateScript("var account = aionInstance.eth.accounts.privateKeyToAccount('\(privateKey)')") != nil) {
            guard let account = self.jsContext.objectForKeyedSubscript("account")?.toObject() as? [AnyHashable: Any] else {
                throw PocketError.walletImport(message: "Failed to create account object")
            }
            
            if account["address"] as? String != publicKey {
                throw PocketError.walletImport(message: "Invalid address provided.")
            }
            
            return Wallet(address: publicKey, privateKey: privateKey, networkID: networkID, data: nil)
        }
        
        throw PocketError.walletImport(message: "Failed to create account js object")
    }
    
    public func createTransaction(wallet: Wallet, params: [AnyHashable : Any]) throws -> Transaction {
        var pocketTx = Transaction(obj: ["network": self.network, "subnetwork": wallet.networkID])
        let pocketTxData = try AionTransactionData(nonce: params["nonce"], to: params["to"], data: params["data"], value: params["value"], gasPrice: params["nrgPrice"], gas: params["nrg"])
        
        pocketTx.transactionData = pocketTxData
        
        let promiseBlock: @convention(block) (JavaScriptCore.JSValue, JavaScriptCore.JSValue) -> () = { (error, result) in
            if !error.isNull {
                try? self.throwErrorWith(message: "Failed to sign transaction with error: \(error)")
            }else{
                let resultObject = result.toObject() as! [AnyHashable: Any]
                
                guard let rawTx = resultObject["rawTransaction"] as? String else {
                    try? self.throwErrorWith(message: "Failed to retrieve raw signed transaction")
                    return
                }
                
                pocketTx.serializedTransaction = rawTx
            }
        }
        
        guard let window = self.jsContext.objectForKeyedSubscript("window") else {
            throw PocketError.transactionCreation(message: "Failed to retrieve window js object")
        }
        
        window.setObject(promiseBlock, forKeyedSubscript: "transactionCreationCallback" as NSString)
        let signTxJSStr = try AionUtils.getFileForResource(name: "signTransaction", ext: "js")
        
        if !signTxJSStr.isEmpty {
            self.jsContext.evaluateScript(pocketTxData.getStringFormatted(signTx: signTxJSStr, privateKey: wallet.privateKey))
        }else {
            throw PocketError.transactionCreation(message: "Failed to retrieve signed tx js string")
        }
        
        self.removeJSGlobalObjects()
        
        return pocketTx
    }
    
    private func removeJSGlobalObjects() {
        self.jsContext.evaluateScript("window.transactionCreationCallback = ''")
        self.jsContext.evaluateScript("account = ''")
    }
    
    deinit {
        self.removeJSGlobalObjects()
    }

}
