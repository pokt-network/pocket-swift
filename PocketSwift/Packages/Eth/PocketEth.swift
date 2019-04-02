//
//  Eth.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import secp256k1_swift
import Web3swift

public class PocketEth: Pocket, PocketPlugin {
    
    public static let NETWORK = "ETH"
    public enum Networks {
        case Mainnet
        case Ropsten
        case Rinkeby
        case Goerli
        case Kovan
        
        public var netID: String {
            get {
                switch self {
                    case .Mainnet : return "1"
                    case .Ropsten : return "3"
                    case .Rinkeby : return "4"
                    case .Goerli : return "5"
                    case .Kovan : return "42"
                }
            }
        }
    }
    
    // Attributes
    public var defaultNetwork: EthNetwork?
    public var mainnet: EthNetwork?
    public var ropsten: EthNetwork?
    public var rinkeby: EthNetwork?
    public var goerli: EthNetwork?
    public var kovan: EthNetwork?
    public var networks: [String: EthNetwork] = [String: EthNetwork]()
    
    init(devID: String, netIds: [String], defaultNetID: String = PocketEth.Networks.Rinkeby.netID, maxNodes: Int = 5, requestTimeOut: Int = 10000) throws {
        super.init(devID: devID, network: PocketEth.NETWORK, netIds: netIds, maxNodes: maxNodes, requestTimeOut: requestTimeOut, schedulerProvider: .main)
        if (netIds.isEmpty) {
            throw PocketError.custom(message: "netIds cannot be empty")
        }
        var defaultNetwork: EthNetwork?
        netIds.forEach { (netID) in
            let network = self.network(netID: netID)
            if (netID.elementsEqual(defaultNetID)) {
                defaultNetwork = network
            }
        }
        self.defaultNetwork = defaultNetwork
    }
    
    public func network(netID: String) -> EthNetwork {
        let result: EthNetwork
        if let networkValue = self.networks[netID] {
            result = networkValue
        } else {
            result = EthNetwork.init(netID: netID, pocketEth: self)
            self.networks[netID] = result
            self.addBlockchain(network: PocketEth.NETWORK, netID: netID)
        }
        
        if (netID.elementsEqual(PocketEth.Networks.Mainnet.netID)) {
            self.mainnet = result
        } else if (netID.elementsEqual(PocketEth.Networks.Ropsten.netID)) {
            self.ropsten = result
        } else if (netID.elementsEqual(PocketEth.Networks.Rinkeby.netID)) {
            self.rinkeby = result
        } else if (netID.elementsEqual(PocketEth.Networks.Goerli.netID)) {
            self.goerli = result
        } else if (netID.elementsEqual(PocketEth.Networks.Kovan.netID)) {
            self.kovan = result
        }
        
        return result
    }
    
    public func importWallet(privateKey: String, address: String?, network: String, netID: String, data: [AnyHashable : Any]?) throws -> Wallet {
        let privateKeyData = Data(hex: privateKey)
        guard let keyStore = PlainKeystore.init(privateKey: privateKeyData) else {
            throw PocketError.walletCreation(message: "Invalid private key")
        }
        return try PocketEth.walletFromKeystore(keyStore: keyStore, netID: netID, data: data)
    }
    
    public func createWallet(network: String, netID: String, data: [AnyHashable : Any]?) throws -> Wallet {
        guard let privateKey = SECP256K1.generatePrivateKey() else {
            throw PocketError.walletCreation(message: "Invalid private key generated")
        }
        guard let keyStore = PlainKeystore.init(privateKey: privateKey) else {
            throw PocketError.walletCreation(message: "Invalid private key generated")
        }
        return try PocketEth.walletFromKeystore(keyStore: keyStore, netID: netID, data: data)
    }
    
    // Private interface
    private static func walletFromKeystore(keyStore: PlainKeystore, netID: String, data: [AnyHashable : Any]?) throws -> Wallet {
        guard let address = keyStore.addresses?.first else {
            throw PocketError.custom(message: "Error reading wallet data")
        }
        let keystorePrivateKey = try keyStore.UNSAFE_getPrivateKeyData(account: address).toHexString()
        let wallet = Wallet.init(address: address.address, privateKey: keystorePrivateKey, network: PocketEth.NETWORK, netID: netID, data: data)
        return wallet
    }
}
