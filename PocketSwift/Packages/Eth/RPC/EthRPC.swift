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
    }
    
    private let ethNetwork: EthNetwork
    
    init(ethNetwork: EthNetwork) {
        self.ethNetwork = ethNetwork
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
    
    public func call(from: String?, to: String, nrg: BigInt?, nrgPrice: BigInt?, value: BigInt?, data: String?, blockTag: BlockTag?, callback: @escaping StringCallback) {
        do {
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            
            var txParams = [String: Any]()
            txParams.fill("from", from, "to", to, "gas", nrg?.toHexString(), "gasPrice", nrgPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams, BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.call.rawValue, params: params)
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getString(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing call response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByHash(blockHash: String, fullTx: Bool = false, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
        do{
            
            if blockHash.isEmpty {
                onError(PocketError.invalidParameter(message: "Block Hash param is missing"))
                return
            }
            
            let params: [Any] = [blockHash, fullTx]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getBlockByHash, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSON(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get block by hash count response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getBlockByNumber(blockTag: BlockTag, fullTx: Bool = false, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
        do{
            let params: [Any] = [blockTag.getValue(), fullTx]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getBlockByNumber, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSON(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get block by number response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByHash(txHash: String, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
        do{
            
            if txHash.isEmpty {
                onError(PocketError.invalidParameter(message: "Transaction hash param is missing"))
                return
            }
            
            let params: [Any] = [txHash]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getTransactionByHash, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSON(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get transaction by hash response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockHashAndIndex(blockHash: String, index: BigInt, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
        do{
            if blockHash.isEmpty {
                onError(PocketError.invalidParameter(message: "One or more params are missing"))
                return
            }
            
            let params: [Any] = [blockHash, index.toHexString()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getTransactionByBlockHashAndIndex, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSON(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get transaction by hash and index response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionByBlockNumberAndIndex(blockTag: BlockTag, index: BigInt, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
        do{
            let params: [Any] = [blockTag.getNumber(), index.toHexString()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getTransactionByBlockNumberAndIndex, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSON(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get transaction by hash and number response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getTransactionReceipt(txHash: String, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
        do{
            
            if txHash.isEmpty {
                onError(PocketError.invalidParameter(message: "Transaction hash param is missing"))
                return
            }
            
            let params: [Any] = [txHash]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getTransactionReceipt, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSON(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get transaction receipt response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func getLogs(fromBlock: BlockTag = .latest , toBlock: BlockTag = .latest, address: String?, topics: [String]?, blockhash: String?, onSuccess: @escaping ([[String: Any]]) -> (), onError: @escaping (Error) -> ()) {
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
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getLogs, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getJSONArray(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get transaction receipt response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    public func estimateGas(from: String?, to: String, nrg: BigInt?, nrgPrice: BigInt?, value: BigInt?, data: String?, blockTag: BlockTag, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
        do{
            if to.isEmpty {
                onError(PocketError.invalidParameter(message: "Destination address (to) param is missing"))
                return
            }
            
            var txParams = [String: Any]()
            txParams.fill("to", to, "from", from, "nrg", nrg?.toHexString(), "nrgPrice", nrgPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            
            let params: [Any] = [txParams, blockTag.getValue()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.estimateGas, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get estimateGas response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                callback(PocketError.custom(message: error.localizedDescription), nil)
            })
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
}
