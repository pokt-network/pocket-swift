//
//  EthRPC.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public class EthRPC {
    
    private enum EthRPCMethod: String {
        case getBalance = "eth_getBalance"
        case sendTransaction = "eth_sendTransaction"
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
    
    public func protocolVersion(callback: @escaping StringCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.protocolVersion.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func syncing(callback: @escaping JSONObjectOrBooleanCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.syncing.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func gasPrice(callback: @escaping BigIntegerCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.gasPrice.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func blockNumber(callback: @escaping BigIntegerCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.blockNumber.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBalance.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getStorageAt.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionCount.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockTransactionCountByHash.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockTransactionCountByNumber(blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do {
            let params: [String] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockTransactionCountByNumber.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getCode.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func call(from: String?, to: String, gas: BigInt?, gasPrice: BigInt?, value: BigInt?, data: String?, blockTag: BlockTag?, callback: @escaping StringCallback) {
        do {
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("from", from, "to", to, "gas", gas?.toHexString(), "gasPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.call.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockByHash.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByNumber(blockTag: BlockTag?, fullTx: Bool = false, callback: @escaping JSONObjectCallback) {
        do{
            let params: [Any] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue(), fullTx]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockByNumber.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByHash.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByBlockHashAndIndex.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockNumberAndIndex(blockTag: BlockTag?, index: BigInt, callback: @escaping JSONObjectCallback) {
        do{
            let params: [Any] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue(), index.toHexString()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByBlockNumberAndIndex.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
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
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionReceipt.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getLogs(fromBlock: BlockTag = .latest , toBlock: BlockTag = .latest, address: String?, topics: [String]?, blockhash: String?, callback: @escaping JSONArrayCallback) {
        do{
            var txParams = [String: Any]()
            txParams.fill("address", address, "topics", topics)
            
            if blockhash != nil {
                txParams["blockhash"] = blockhash!
            } else {
                txParams["fromBlock"] = fromBlock.getValue()
                txParams["toBlock"] = toBlock.getValue()
            }
            
            let params: [Any] = [txParams]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getLogs.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func estimateGas(from: String?, to: String, gas: BigInt?, gasPrice: BigInt?, value: BigInt?, data: String?, blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do{
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("to", to, "from", from, "nrg", gas?.toHexString(), "nrgPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, BlockTag.tagOrLatest(blockTag: blockTag)]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.estimateGas.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
}
