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
    
    /**
     Ethereum RPC
     - Parameters:
     - ethNetwork : Aion operation executor.
     
     - SeeAlso: `EthNetwork`
     */
    init(ethNetwork: EthNetwork) {
        self.ethNetwork = ethNetwork
    }
    
    
    /**
     Creates new message call transaction or a contract creation, if the data field contains code.
     - Parameters:
     - wallet: the wallet to be used in this transaction.
     - nonce: Integer of a nonce. This allows to overwrite your own pending transactions that use the same nonce.
     - to: The address the transaction is directed to.
     - nrg: Integer of the gas provided for the transaction execution. It will return unused gas.
     - nrgPrice: Integer of the gasPrice used for each paid gas.
     - value : Integer of the value sent with this transaction
     - data : The compiled code of a contract OR the hash of the invoked method signature and encoded parameters.
     - callback : listener for this transaction status.
     
     - SeeAlso: `EthStringCallback`
     - SeeAlso: `Wallet`
     - SeeAlso: `BlockTag`
     */
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
            
            let pkData = Data.init(hex: wallet.privateKey)
            
            var dataParam = Data()
            if let encodedData = data?.data(using: .utf8) {
                dataParam = encodedData
            }
            var ethTx = EthereumTransaction.init(gasPrice: gasPrice, gasLimit: gas, to: recepientAddress, value: value, data: dataParam)
            ethTx.nonce = nonce
            try Web3Signer.FallbackSigner.sign(transaction: &ethTx, privateKey: pkData, useExtraEntropy: true)
            
            guard let rawTxJSON: JSONRPCrequest = EthereumTransaction.createRawTransaction(transaction: ethTx) else {
                callback(PocketError.custom(message: "Invalid transaction data"), nil)
                return
            }
            
            guard let jsonRPCParams = rawTxJSON.params else {
                callback(PocketError.custom(message: "Invalid transaction data"), nil)
                return
            }
            
            var params = [Any]()
            for element in jsonRPCParams.params {
                params.append("\(element)")
            }
            
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.sendRawTransaction.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the current price per gas in wei.
     - Parameters:
     - callback : listener for the protocol version.
     
     - SeeAlso: `EthStringCallback`
     */
    public func protocolVersion(callback: @escaping EthStringCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.protocolVersion.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the current ethereum protocol version.
     - Parameters:
     - callback : listener for the syncing status.
     
     - SeeAlso: `EthJSONObjectOrBooleanCallback`
     */
    public func syncing(callback: @escaping EthJSONObjectOrBooleanCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.syncing.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the current price per gas in wei.
     - Parameters:
     - callback : listener for the price.
     
     - SeeAlso: `EthBigIntegerCallback`
     */
    public func gasPrice(callback: @escaping EthBigIntegerCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.gasPrice.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the number of most recent block.
     - Parameters:
     - callback : listener for the most recent block
     
     - SeeAlso: `EthBigIntegerCallback`
     */
    public func blockNumber(callback: @escaping EthBigIntegerCallback) {
        do {
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.blockNumber.rawValue, params: nil)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the number of most recent block.
     - Parameters:
     - address : address to check for balance.
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - callback : listener for balance from address.
     
     - SeeAlso: `EthBigIntegerCallback`
     - SeeAlso: `EthBlockTag`
     */
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
    
    /**
     Returns the value from a storage position at a given address.
     - Parameters:
     - address : address to check for balance.
     - position integer of the position in the storage.
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - callback : listener for balance from address.
     
     - SeeAlso: `EthStringCallback`
     - SeeAlso: `EthBlockTag`
     - SeeAlso: `BigInt`
     */
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
    
    /**
     Returns the number of transactions sent from an address.
     - Parameters:
     - address : address to check for balance.
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - callback : listener for balance from address.
     
     - SeeAlso: `EthBigIntegerCallback`
     - SeeAlso: `EthBlockTag`
     */
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
    
    /**
     Returns the number of transactions in a block from a block matching the given block hash.
     - Parameters:
     - blockHashHex : hash of a block.
     - callback : listener for the transaction count By Hash.
     
     - SeeAlso: `EthBigIntegerCallback`
     */
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
    
    /**
     Returns the number of transactions in a block matching the given block number.
     - Parameters:
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - callback : listener for the transaction count By Number.
     
     - SeeAlso: `EthBigIntegerCallback`
     - SeeAlso: `EthBlockTag`
     */
    public func getBlockTransactionCountByNumber(blockTag: EthBlockTag?, callback: @escaping EthBigIntegerCallback) {
        do {
            let params: [String] = [EthBlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockTransactionCountByNumber.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        } catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns code at a given address.
     - Parameters:
     - address : address
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - callback : listener to get the code.
     
     - SeeAlso: `EthStringCallback
     - SeeAlso: `EthBlockTag`
     */
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
    
    /**
     Executes a new message call immediately without creating a transaction on the block chain.
     - Parameters:
     - from: The address the transaction is sent from.
     - to: The address the transaction is directed to.
     - gas: Integer of the gas provided for the transaction execution.
     - gasPrice: Integer of the gasPrice used for each paid gas.
     - value: Integer of the value sent with this transaction.
     - data: Hash of the method signature and encoded parameters.
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - callback : listener for this call status.
     
     - SeeAlso: `EthStringCallback`
     - SeeAlso: `EthBlockTag`
     - SeeAlso: `BigUInt`
     */
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
    
    /**
     Returns information about a block by hash.
     - Parameters:
     - blockHash : Hash of a block.
     - fullTx : Full transaction objects.
     - callback : listener to get the Block By Hash.
     
     - SeeAlso: `EthJSONObjectCallback`
     */
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
    
    /**
     Returns information about a block by hash.
     - Parameters:
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - fullTx : Full transaction objects.
     - callback : listener to get the Block By Number.
     
     - SeeAlso: `EthJSONObjectCallback`
     - SeeAlso: `EthBlockTag`
     */
    public func getBlockByNumber(blockTag: EthBlockTag?, fullTx: Bool = false, callback: @escaping EthJSONObjectCallback) {
        do{
            let params: [Any] = [EthBlockTag.tagOrLatest(blockTag: blockTag).getValue(), fullTx]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getBlockByNumber.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the information about a transaction requested by transaction hash.
     - Parameters:
     - txHash : hash of a transaction.
     - callback : listener to get transaction by Hash.
     
     - SeeAlso: `EthJSONObjectCallback`
     */
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
    
    /**
     Returns information about a transaction by block number and transaction index position.
     - Parameters:
     - blockHash : hash of a block.
     - index:  the transaction index position.
     - callback : listener to get the transaction Block Hash Index.
     
     - SeeAlso: `EthJSONObjectCallback`
     - SeeAlso: `BigInt`
     */
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
    
    /**
     Returns information about a transaction by block number and transaction index position.
     - Parameters:
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - index:  the transaction index position.
     - callback : listener to get the transaction by block number at index.
     
     - SeeAlso: `EthJSONObjectCallback`
     - SeeAlso: `EthBlockTag`
     - SeeAlso: `BigInt`
     */
    public func getTransactionByBlockNumberAndIndex(blockTag: EthBlockTag?, index: BigInt, callback: @escaping EthJSONObjectCallback) {
        do{
            let params: [Any] = [EthBlockTag.tagOrLatest(blockTag: blockTag).getValue(), index.toHexString()]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.getTransactionByBlockNumberAndIndex.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the receipt of a transaction by transaction hash.
     - Parameters:
     - txHash : hash of a transaction.
     - callback : listener to get the transaction receipt.
     
     - SeeAlso: `EthJSONObjectCallback`
     */
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
    
    /**
     Returns an array of all logs matching a given filter object.
     - Parameters:
     - fromBlock : Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
     - toBlock : Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
     - address : Contract address or a list of addresses from which logs should originate.
     - topics : Topics are order-dependent. Each topic can also be an array of DATA with "or" options.
     - blockHash : is a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash.
     - callback : listener to get logs.
     
     - SeeAlso: `EthJSONArrayCallback`
     - SeeAlso: `EthBlockTag`
     */
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
    
    /**
     Generates and returns an estimate of how much gas is necessary to allow the transaction to complete.
     The transaction will not be added to the blockchain. Note that the estimate may be significantly more
     than the amount of gas actually used by the transaction, for a variety of reasons including EVM mechanics and node performance.
     - Parameters:
     - to: The address the transaction is directed to.
     - blockTag : integer block number, or the string "latest", "earliest" or "pending".
     - from : The address the transaction is sent from.
     - gas : Integer of the gas provided for the transaction execution.
     - gasPrice : Integer of the gasPrice used for each paid gas.
     - value : Integer of the value sent with this transaction
     - data : Hash of the method signature and encoded parameters.
     - callback : listener for the estimated gas call.
     
     - SeeAlso: `EthBigIntegerCallback`
     - SeeAlso: `BigUInt`
     - SeeAlso: `EthBlockTag`
     */
    public func estimateGas(from: String?, to: String, gas: BigInt?, gasPrice: BigInt?, value: BigInt?, data: String?, blockTag: EthBlockTag?, callback: @escaping EthBigIntegerCallback) {
        do{
            if to.isEmpty {
                callback(PocketError.invalidParameter(message: "Destination address (to) param is missing"), nil)
                return
            }
            var txParams = [String: Any]()
            txParams.fill("to", to, "from", from, "nrg", gas?.toHexString(), "nrgPrice", gasPrice?.toHexString(), "value", value?.toHexString(), "data", data)
            let params: [Any] = [txParams]
            let relay = try self.ethNetwork.createEthRelay(method: EthRPCMethod.estimateGas.rawValue, params: params)
            self.ethNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
}
