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

    enum Networks: String {
        case MAINNET = "256"
        case MASTERY = "32"
        
        func netID() -> String {
            return self.rawValue
        }
    }
    
    // Attributes
    public var defaultNetwork: AionNetwork?
    public var mainnet: AionNetwork?
    public var mastery: AionNetwork?
    public var networks: [String: AionNetwork] = [String: AionNetwork]()
    private let jsContext: JSContext = JSContext()
    
    init(devID: String, netIds: [String], defaultNetID: String = Networks.MASTERY.netID(), maxNodes: Int = 5, requestTimeOut: Int = 10000) throws {
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
    // Create Wallet
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

        return Wallet(address: address, privateKey: privateKey, network: PocketAion.NETWORK, netID: netID, data: nil)
    }
    // Import Wallet
    internal func importWallet(privateKey: String, netID: String) throws -> Wallet {

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
            return Wallet(address: address, privateKey: privateKey, network: PocketAion.NETWORK, netID: netID, data: nil)
        }

        throw PocketError.walletImport(message: "Failed to create account js object")
    }
    
    private func removeJSGlobalObjects() {
        self.jsContext.evaluateScript("window.transactionCreationCallback = ''")
        self.jsContext.evaluateScript("account = ''")
    }
    
    deinit {
        self.removeJSGlobalObjects()
    }

}
