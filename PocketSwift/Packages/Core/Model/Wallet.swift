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

public class Wallet {
    public let address: String
    public let privateKey: String
    public let network: String
    public let netID: String
    public let data: [AnyHashable: Any]?
    
    // Constructors
    init(address: String, privateKey: String, network: String, netID: String, data: [AnyHashable: Any]?) {
        self.address = address
        self.privateKey = privateKey
        self.network = network
        self.netID = netID
        self.data = data
    }
    
    private init(jsonString: String) throws {
        var dict = try Utils.jsonStringToDictionary(string: jsonString) ?? [AnyHashable: Any]()
        address = dict["address"] as? String ?? ""
        privateKey = dict["privateKey"] as? String ?? ""
        network = dict["network"] as? String ?? ""
        netID = dict["netID"] as? String ?? ""
        data = try Utils.jsonStringToDictionary(string: dict["data"] as? String ?? "")
    }
    
    // Persistence public instance interface
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
    
    public func delete() throws -> Bool {
        return Wallet.getKeychainWrapper().removeObject(forKey: recordKey())
    }
    
    public func isSaved() -> Bool {
        return Wallet.getKeychainWrapper().allKeys().contains(self.recordKey())
    }
    
    public func equalsTo(wallet: Wallet) -> Bool {
        let selfData: [AnyHashable: Any] = self.data ?? [AnyHashable: Any]()
        let walletData: [AnyHashable: Any] = wallet.data ?? [AnyHashable: Any]()
        return self.network == wallet.network && self.netID == wallet.netID && self.address == wallet.address && self.privateKey == wallet.privateKey && NSDictionary(dictionary: selfData).isEqual(to: walletData)
    }
    
    // Persistence public class interface
    public class func getWalletsRecordKeys() -> [String] {
        return Array(Wallet.getKeychainWrapper().allKeys())
    }
    
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
    
    public func recordKey() -> String {
        return Wallet.recordKey(network: network, netID: netID, address: address)
    }
    
    private static func recordKey(network: String, netID: String, address: String) -> String {
        return network + "/" + netID + "/" + address
    }
    
    private func toJSONString() throws -> String {
        var object = [AnyHashable: Any]()
        object["address"] = address
        object["privateKey"] = privateKey
        object["network"] = network
        object["netID"] = netID
        object["data"] = try Utils.dictionaryToJsonString(dict: data)
        guard let result = try Utils.dictionaryToJsonString(dict: object) else {
            throw PocketError.walletPersistence(message: "Error serializing wallet")
        }
        return result
    }
    
    private class func getKeychainWrapper() -> KeychainWrapper {
        return KeychainWrapper.standard
    }
    
}
