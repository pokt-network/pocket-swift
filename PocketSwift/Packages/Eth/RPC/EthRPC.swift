//
//  EthRPC.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt
import Web3swift
import EthereumAddress

extension EthereumTransaction {
    public static func createRawTransaction(transaction: EthereumTransaction) -> JSONRPCrequest? {
        return self.createRawTransaction(transaction: transaction)
    }
}

public class EthRPC {
    
    private enum EthRPCMethod: String {
        case getBalance = "eth_getBalance"
        case sendRawTransaction = "eth_sendRawTransaction"
        case getStorageAt = "eth_getStorageAt"
        case getTransactionCount = "eth_getTransactionCount"
        case getBlockTransactionCountByHash = "eth_getBlockTransactionCountByHash"
        case getBlockTransactionCountByNumber = "eth_getBlockTransactionCountByNumber"
        case getCode = "eth_getCode"
        case call = "eth_call"
        case getBlockByHash = "eth_getBlockByHash"
        case getBlockByNumber = "eth_getBlockByNumber"
        case getTransactionByHash = "eth_getTransactionByHash"
        case getTransactionByBlockHashAndIndex = "eth_getTransactionByBlockHashAndIndex"
        case getTransactionByBlockNumberAndIndex = "eth_getTransactionByBlockNumberAndIndex"
        case getTransactionReceipt = "eth_getTransactionReceipt"
        case getLogs = "eth_getLogs"
        case estimateGas = "eth_estimateGas"
        case protocolVersion = "eth_protocolVersion"
        case syncing = "eth_syncing"
        case gasPrice = "eth_gasPrice"
        case blockNumber = "eth_blockNumber"
    }
    
    private let ethNetwork: EthNetwork
    
    init(ethNetwork: EthNetwork) {
        self.ethNetwork = ethNetwork
    }
    
    public func sendTransaction(wallet: Wallet, toAddress: String, gas: BigUInt, gasPrice: BigUInt, value: BigUInt = BigUInt.init(0), data: String?, nonce: BigUInt, callback: @escaping EthStringCallback) {
        do {
            if !wallet.netID.elementsEqual(self.ethNetwork.netID) {
                callback(PocketError.custom(message: "Invalid wallet netid: \(wallet.netID)"), nil)
                return
            }
            guard let recepientAddress = EthereumAddress.init(toAddress) else {
                callback(PocketError.custom(message: "Invalid receipient address: \(toAddress)"), nil)
                return
            }
            guard let pkData = wallet.privateKey.data(using: .utf8) else {
                callback(PocketError.custom(message: "Invalid private key: \(wallet.privateKey)"), nil)
                return
            }
            var dataParam = Data()
            if let encodedData = data?.data(using: .utf8) {
                dataParam = encodedData
            }
            var ethTx = EthereumTransaction.init(gasPrice: gasPrice, gasLimit: gas, to: recepientAddress, value: value, data: dataParam)
            ethTx.nonce = nonce
            try Web3Signer.FallbackSigner.sign(transaction: &ethTx, privateKey: pkData, useExtraEntropy: true)
            guard let rawTx = String(data: try JSONEncoder().encode(EthereumTransaction.createRawTransaction(transaction: ethTx)), encoding: .utf8) else {
                callback(PocketError.custom(message: "Error encoding transaction"), nil)
                return
            }
            let params: [Any] = [rawTx]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.sendRawTransaction.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func protocolVersion(callback: @escaping EthStringCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.protocolVersion.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func syncing(callback: @escaping EthJSONObjectOrBooleanCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.syncing.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func gasPrice(callback: @escaping EthBigIntegerCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.gasPrice.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func blockNumber(callback: @escaping EthBigIntegerCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.blockNumber.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBalance(address: String, blockTag: EthBlockTag?, callback: @escaping EthBigIntegerCallback) {
        do {
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            let params: [String] = [address, EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBalance.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getStorageAt(address: String, position: BigInt, blockTag: EthBlockTag?, callback: @escaping EthStringCallback) {
        do {
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            let params: [String] = [address, position.toHexString(), EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getStorageAt.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionCount(address: String, blockTag: EthBlockTag?, callback: @escaping EthBigIntegerCallback) {
        do {
            
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            
            let params: [String] = [address, EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionCount.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockTransactionCountByHash(blockHash: String, callback: @escaping EthBigIntegerCallback) {
        do {
            if blockHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Block hash param is missing"), nil)
                return
            }
            let params: [String] = [blockHash]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockTransactionCountByHash.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockTransactionCountByNumber(blockTag: EthBlockTag?, callback: @escaping EthBigIntegerCallback) {
        do {
            let params: [String] = [EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockTransactionCountByNumber.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getCode(address: String, blockTag: EthBlockTag?, callback: @escaping EthStringCallback) {
        do {
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            
            let params: [String] = [address, EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getCode.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func call(from: String?, to: String, gas: BigUInt?, gasPrice: BigUInt?, value: BigUInt?, data: String?, blockTag: EthBlockTag?, callback: @escaping EthStringCallback) {
        do {
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("from", from, "to", to, "gas", gas?.toHexString(), "gasPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.call.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByHash(blockHash: String, fullTx: Bool = false, callback: @escaping EthJSONObjectCallback) {
        do{
            if blockHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Block Hash param is missing"), nil)
                return
            }
            let params: [Any] = [blockHash, fullTx]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockByHash.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByNumber(blockTag: EthBlockTag?, fullTx: Bool = false, callback: @escaping EthJSONObjectCallback) {
        do{
            let params: [Any] = [EthBlockTag.tagOrLatest(blockTag: blockTag).getValue(), fullTx]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockByNumber.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByHash(txHash: String, callback: @escaping EthJSONObjectCallback) {
        do{
            if txHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Transaction hash param is missing"), nil)
                return
            }
            let params: [Any] = [txHash]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByHash.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockHashAndIndex(blockHash: String, index: BigInt, callback: @escaping EthJSONObjectCallback) {
        do{
            if blockHash.isEmpty {
                callback(PocketError.invalidParameter(message: "One or more params are missing"), nil)
                return
            }
            
            let params: [Any] = [blockHash, index.toHexString()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByBlockHashAndIndex.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockNumberAndIndex(blockTag: EthBlockTag?, index: BigInt, callback: @escaping EthJSONObjectCallback) {
        do{
            let params: [Any] = [EthBlockTag.tagOrLatest(blockTag: blockTag).getValue(), index.toHexString()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByBlockNumberAndIndex.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionReceipt(txHash: String, callback: @escaping EthJSONObjectCallback) {
        do{
            if txHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Transaction hash param is missing"), nil)
                return
            }
            let params: [Any] = [txHash]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionReceipt.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getLogs(fromBlock: EthBlockTag? = .latest , toBlock: EthBlockTag? = .latest, address: String?, topics: [String]?, blockhash: String?, callback: @escaping EthJSONArrayCallback) {
        do{
            var txParams = [String: Any]()
            txParams.fill("address", address, "topics", topics)
            
            if blockhash != nil {
                txParams["blockhash"] = blockhash!
            } else {
                txParams["fromBlock"] = EthBlockTag.tagOrLatest(blockTag: fromBlock).getValue()
                txParams["toBlock"] = EthBlockTag.tagOrLatest(blockTag: toBlock).getValue()
            }
            
            let params: [Any] = [txParams]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getLogs.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func estimateGas(from: String?, to: String, gas: BigInt?, gasPrice: BigInt?, value: BigInt?, data: String?, blockTag: EthBlockTag?, callback: @escaping EthBigIntegerCallback) {
        do{
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("to", to, "from", from, "nrg", gas?.toHexString(), "nrgPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.estimateGas.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
}
