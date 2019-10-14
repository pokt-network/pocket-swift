//
//  Wallet.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RNCryptor
import SwiftKeychainWrapper

/**
 A Model Class that represents a Wallet.
 
 Used to represent a Crypto Wallet.
 - Parameters:
 - privateKey : The private key for this wallet.
 - address: The wallet address.
 - network: The blockchain network name, ie: ETH, AION.
 - netID: The netid of the Blockchain.
 
 */
public class Wallet {
    public let address: String
    public let privateKey: String
    public let network: String
    public let netID: String
    
    // Constructors
    public init(address: String, privateKey: String, network: String, netID: String) {
        self.address = address
        self.privateKey = privateKey
        self.network = network
        self.netID = netID
    }
    
    private init(jsonString: String) throws {
        let dict = try Utils.jsonStringToDictionary(string: jsonString) ?? [AnyHashable: Any]()
        address = dict["address"] as? String ?? ""
        privateKey = dict["privateKey"] as? String ?? ""
        network = dict["network"] as? String ?? ""
        netID = dict["netID"] as? String ?? ""
    }
    
    /**
     Encrypt and Store a Wallet locally
     - Parameters:
        - passphrase: The passphrase for this wallet.
     
     - Returns: true if the `Wallet` was saved
     */

    public func save(passphrase: String) throws -> Bool {
        if isValid() {
            guard let jsonData = try toJSONString().data(using: .utf8) else {
                throw PocketError.walletPersistence(message: "Error encoding the wallet data")
            }
            let ciphertext = RNCryptor.encrypt(data: jsonData, withPassword: passphrase)
            return  Wallet.getKeychainWrapper().set(ciphertext, forKey: recordKey())
        } else {
            throw PocketError.walletPersistence(message: "Invalid wallet")
        }
    }
    
    
    /**
        Delete a Wallet previously encrypted
            - Parameters:
                - passphrase: The passphrase for this wallet.
     
            - Throws: `PocketError.walletPersistence`
                if there was an error storing the Wallet
     
            - Returns: true if the `Wallet` was deleted
     */
    public func delete() throws -> Bool {
        return Wallet.getKeychainWrapper().removeObject(forKey: recordKey())
    }

    /**
        Verify if a Wallet is saved
            - Parameters:
                - passphrase: The passphrase for this wallet.

            - Returns: true if the `Wallet` is saved
     */   
    public func isSaved() -> Bool {
        return Wallet.getKeychainWrapper().allKeys().contains(self.recordKey())
    }
    /**
        Verify if a Wallet data is correct
            - Parameters:
                - wallet: the private key of a wallet

            - Returns: true if the `Wallet` is correct
     */    
    public func equalsTo(wallet: Wallet) -> Bool {
        return self.network == wallet.network && self.netID == wallet.netID && self.address == wallet.address && self.privateKey == wallet.privateKey
    }
    /**
        Obtain the stored walled in keychain
            - Parameters: None
               
            - Returns: an array of encrypted keys 
     */        
    public class func getWalletsRecordKeys() -> [String] {
        return Array(Wallet.getKeychainWrapper().allKeys())
    }
    
    
    /**
     Decrypts a Wallet
     - Parameters:
     - address: The wallet address.
     - network: The blockchain network name, ie: ETH, AION.
     - netID: The netid of the Blockchain.
     - passphrase: The passphrase for this wallet.
     
     
     - Throws: `PocketError.walletPersistence`
                if `Wallet` cannot be decrypted
     
     - Returns: a `Wallet`
     - SeeAlso: `Wallet`
     */
    
    public class func retrieveWallet(network: String, netID: String, address: String, passphrase: String) throws -> Wallet {
        guard let encryptedWalletData = Wallet.getKeychainWrapper().data(forKey: Wallet.recordKey(network: network, netID: netID, address: address)) else {
            throw PocketError.walletPersistence(message: "Error deserializing wallet data")
        }
        guard let decryptedWalletJSON = String.init(data: try RNCryptor.decrypt(data: encryptedWalletData, withPassword: passphrase), encoding: .utf8) else {
            throw PocketError.walletPersistence(message: "Error decrypting wallet data")
        }
        let wallet = try Wallet(jsonString: decryptedWalletJSON)
        return wallet
    }

    public class func isSaved(network: String, netID: String, address: String) -> Bool {
        return Wallet.getKeychainWrapper().allKeys().contains(Wallet.recordKey(network: network, netID: netID, address: address))
    }
    
    // Private functions
    private func isValid() -> Bool {
        return !network.isEmpty && !address.isEmpty && !privateKey.isEmpty && !netID.isEmpty
    }
    
    
    /**
     Retrieves all record keys for this Wallet.
     - Returns: a valid record key
     */
    public func recordKey() -> String {
        return Wallet.recordKey(network: network, netID: netID, address: address)
    }
    
    /**
     Retrieves all record keys for this Wallet.
     - Parameters:
     - address: The wallet address.
     - network: The blockchain network name, ie: ETH, AION.
     - netID: The netid of the Blockchain.
     
     - Returns: a valid record key
     */
    private static func recordKey(network: String, netID: String, address: String) -> String {
        return network + "/" + netID + "/" + address
    }
    
    private func toJSONString() throws -> String {
        var object = [AnyHashable: Any]()
        object["address"] = address
        object["privateKey"] = privateKey
        object["network"] = network
        object["netID"] = netID
        guard let result = try Utils.dictionaryToJsonString(dict: object) else {
            throw PocketError.walletPersistence(message: "Error serializing wallet")
        }
        return result
    }
    
    private class func getKeychainWrapper() -> KeychainWrapper {
        return KeychainWrapper.standard
    }
    
}
