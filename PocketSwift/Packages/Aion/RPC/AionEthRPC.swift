//
//  AionRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public struct AionEthRPC {
    
    private enum AionEthRPCMethod: String {
        case getBalance = "eth_getBalance"
        case sendTransaction = "eth_sendRawTransaction"
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
    
    private let aionNetwork: AionNetwork
    
    init(aionNetwork: AionNetwork) {
        self.aionNetwork = aionNetwork
    }
    
    public func protocolVersion(callback: @escaping StringCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.protocolVersion.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func syncing(callback: @escaping JSONObjectOrBooleanCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.syncing.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func gasPrice(callback: @escaping BigIntegerCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.gasPrice.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func blockNumber(callback: @escaping BigIntegerCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.blockNumber.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBalance(address: String, blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do {
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            let params: [String] = [address, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBalance.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getStorageAt(address: String, position: BigInt, blockTag: BlockTag?, callback: @escaping StringCallback) {
        do {
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            let params: [String] = [address, position.toHexString(), BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getStorageAt.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionCount(address: String, blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do {
            
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            
            let params: [String] = [address, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getTransactionCount.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockTransactionCountByHash(blockHash: String, callback: @escaping BigIntegerCallback) {
        do {
            if blockHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Block hash param is missing"), nil)
                return
            }
            let params: [String] = [blockHash]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBlockTransactionCountByHash.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockTransactionCountByNumber(blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do {
            let params: [String] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBlockTransactionCountByNumber.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getCode(address: String, blockTag: BlockTag?, callback: @escaping StringCallback) {
        do {
            if address.isEmpty {
                callback(PocketError.invalidAddress, nil)
                return
            }
            
            let params: [String] = [address, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getCode.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func call(from: String?, to: String, gas: BigUInt?, gasPrice: BigUInt?, value: BigUInt?, data: String?, blockTag: BlockTag?, callback: @escaping StringCallback) {
        do {
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("from", from, "to", to, "gas", gas?.toHexString(), "gasPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.call.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByHash(blockHash: String, fullTx: Bool = false, callback: @escaping JSONObjectCallback) {
        do{
            if blockHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Block Hash param is missing"), nil)
                return
            }
            let params: [Any] = [blockHash, fullTx]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBlockByHash.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByNumber(blockTag: BlockTag?, fullTx: Bool = false, callback: @escaping JSONObjectCallback) {
        do{
            let params: [Any] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue(), fullTx]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBlockByNumber.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByHash(txHash: String, callback: @escaping JSONObjectCallback) {
        do{
            if txHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Transaction hash param is missing"), nil)
                return
            }
            let params: [Any] = [txHash]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getTransactionByHash.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockHashAndIndex(blockHash: String, index: BigInt, callback: @escaping JSONObjectCallback) {
        do{
            if blockHash.isEmpty {
                callback(PocketError.invalidParameter(message: "One or more params are missing"), nil)
                return
            }
            
            let params: [Any] = [blockHash, index.toHexString()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getTransactionByBlockHashAndIndex.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockNumberAndIndex(blockTag: BlockTag?, index: BigInt, callback: @escaping JSONObjectCallback) {
        do{
            let params: [Any] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue(), index.toHexString()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getTransactionByBlockNumberAndIndex.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionReceipt(txHash: String, callback: @escaping JSONObjectCallback) {
        do{
            if txHash.isEmpty {
                callback(PocketError.invalidParameter(message: "Transaction hash param is missing"), nil)
                return
            }
            let params: [Any] = [txHash]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getTransactionReceipt.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getLogs(fromBlock: BlockTag? = .latest , toBlock: BlockTag? = .latest, address: String?, topics: [String]?, blockhash: String?, callback: @escaping JSONObjectCallback) {
        do{
            var txParams = [String: Any]()
            txParams.fill("address", address, "topics", topics)
            
            if blockhash != nil {
                txParams["blockhash"] = blockhash!
            } else {
                txParams["fromBlock"] = fromBlock?.getValue()
                txParams["toBlock"] = toBlock?.getValue()
            }
            
            let params: [Any] = [txParams]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getLogs.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func estimateGas(from: String?, to: String, gas: BigUInt?, gasPrice: BigUInt?, value: BigUInt?, data: String?, blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do{
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("to", to, "from", from, "nrg", gas?.toHexString(), "nrgPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.estimateGas.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }

    public func sendTransaction(wallet: Wallet, nonce: BigUInt, to: String, nrg: BigUInt?, nrgPrice: BigUInt?, value: BigUInt?, data: String?, callback: @escaping StringCallback) {
        do {
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("from", wallet.address, "nonce", nonce.toHexString(), "to", to, "gas", nrg?.toHexString() ?? "", "gasPrice", nrgPrice?.toHexString() ?? "", "value", value?.toHexString() ?? "", "data", data ?? "")
            // Sign Transaction
            let txData = try self.aionNetwork.pocketAion.signTransaction(params: txParams, privateKey: wallet.privateKey)
            let params: [Any] = [txData]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.sendTransaction.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
}

