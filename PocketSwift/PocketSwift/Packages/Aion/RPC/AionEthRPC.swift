//
//  AionRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public struct AionEthRPC: EthRPC {
    
    var pocket: Pocket
    var netID: String
    var network: String
    
    private let pocketAion: PocketAion
    
    
    init(pocketAion: PocketAion, netID: String) {
        self.pocket = pocketAion
        self.network = pocketAion.NETWORK
        self.netID = netID
        self.pocketAion = pocketAion
    }
    
    public func sendTransaction(for wallet: Wallet, with params: [AnyHashable : Any], onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do {
            //let transaction: Transaction = try self.pocketAion.createTransaction(wallet: wallet, params: params)
            //send(transaction: transaction, onSuccess: onSuccess, onError: onError)
        } catch let error {
            onError(error)
        }
    }
    
    public func sendTransaction(for wallet: Wallet, nonce: BigInt, to: String, data: String, value: BigInt, nrgPrice: BigInt, nrg: BigInt, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do {
            var txParams = [AnyHashable: Any]()
            txParams["nonce"] = nonce.toHexString()
            txParams["to"] = to
            txParams["data"] = data
            txParams["value"] = value.toHexString()
            txParams["nrgPrice"] = nrgPrice.toHexString()
            txParams["nrg"] = nrg.toHexString()
            
            //let transaction: Transaction = try self.pocketAion.createTransaction(wallet: wallet, params: txParams)
            //send(transaction: transaction, onSuccess: onSuccess, onError: onError)
        } catch let error {
            onError(error)
        }
    }
    
    public func getBalance(address: String, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
        do {
            
            if address.isEmpty {
                onError(PocketError.invalidAddress)
                return
            }
            
            let params: [String] = [address, blockTag.getValue()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getBalance, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
    
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get balance response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
    
    public func getStorageAt(address: String, position: BigInt, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
        do {
            if address.isEmpty {
                onError(PocketError.invalidAddress)
                return
            }
            
            let params: [String] = [address, position.toHexString(), blockTag.getValue()]
            guard let relay: Relay = try self.createEthRelay(ethMethod: EthRPCMethod.getStorageAt, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get storage at response"))
                    return
                }
                onSuccess(result)
            }, onError: { error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
    
    public func getTransactionCount(address: String, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
        do {
            
            if address.isEmpty {
                onError(PocketError.invalidAddress)
                return
            }
            
            let params: [String] = [address, blockTag.getValue()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getTransactionCount, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get transaction count response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
    
    public func getBlockTransactionCountByHash(blockHash: String, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
        do {
            if blockHash.isEmpty {
                onError(PocketError.invalidParameter(message: "Block hash param is missing"))
                return
            }
            
            let params: [String] = [blockHash]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getBlockTransactionCountByHash, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get block transaction count by hash count response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
    
    public func getBlockTransactionCountByNumber(blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
        do {
            let params: [String] = [blockTag.getValue()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getBlockTransactionCountByNumber, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getInteger(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get block transaction count by number count response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
    
    public func getCode(address: String, blockTag: DefaultBlock, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do {
            if address.isEmpty {
                onError(PocketError.invalidAddress)
                return
            }
            
            let params: [String] = [address, blockTag.getValue()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.getCode, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getString(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing get block transaction count by number count response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
        }
    }
    
    public func call(from: String?, to: String, nrg: BigInt?, nrgPrice: BigInt?, value: BigInt?, data: String?, blockTag: DefaultBlock, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
        do{
            if to.isEmpty {
                onError(PocketError.invalidParameter(message: "Destination address (to) param is missing"))
                return
            }
            
            var txParams = [String: Any]()
            txParams.fill("from", from, "to", to, "nrg", nrg?.toHexString(), "nrgPrice", nrgPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            
            let params: [Any] = [txParams, blockTag.getValue()]
            guard let relay = try self.createEthRelay(ethMethod: EthRPCMethod.call, params: params) else {
                onError(PocketError.invalidRelay)
                return
            }
            
            self.pocket.send(relay: relay, onSuccess: { response in
                guard let result = try? self.getString(dic: response.toDict()) else {
                    onError(PocketError.custom(message: "Error parsing call response"))
                    return
                }
                onSuccess(result)
                
            }, onError: {error in
                onError(error)
            })
        } catch let error {
            onError(error)
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
                onError(error)
            })
        }catch let error {
            onError(error)
        }
    }
    
    public func getBlockByNumber(blockTag: DefaultBlock, fullTx: Bool = false, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
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
                onError(error)
            })
        }catch let error {
            onError(error)
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
                onError(error)
            })
        }catch let error {
            onError(error)
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
                onError(error)
            })
        }catch let error {
            onError(error)
        }
    }
    
    public func getTransactionByBlockNumberAndIndex(blockTag: DefaultBlock, index: BigInt, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ()) {
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
                onError(error)
            })
        }catch let error {
            onError(error)
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
                onError(error)
            })
        }catch let error {
            onError(error)
        }
    }
    
    public func getLogs(fromBlock: DefaultBlock = .latest , toBlock: DefaultBlock = .latest, address: String?, topics: [String]?, blockhash: String?, onSuccess: @escaping ([[String: Any]]) -> (), onError: @escaping (Error) -> ()) {
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
                onError(error)
            })
        }catch let error {
            onError(error)
        }
    }
    
    public func estimateGas(from: String?, to: String, nrg: BigInt?, nrgPrice: BigInt?, value: BigInt?, data: String?, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
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
                onError(error)
            })
        }catch let error {
            onError(error)
        }
    }
}

