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
    
    /**
     Ethereum RPC
        - Parameters:
            - aionNetwork : Aion operation executor.
     
     - SeeAlso: `AionNetwork`
     */
    
    init(aionNetwork: AionNetwork) {
        self.aionNetwork = aionNetwork
    }
    
    /**
     Returns the current price per gas in wei.
        - Parameters:
            - callback : listener for the protocol version.
     
     - SeeAlso: `StringCallback`
     */
    public func protocolVersion(callback: @escaping StringCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.protocolVersion.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the current ethereum protocol version.
        - Parameters:
            - callback : listener for the syncing status.
     
     - SeeAlso: `JSONObjectOrBooleanCallback`
     */
    public func syncing(callback: @escaping JSONObjectOrBooleanCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.syncing.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the current price per gas in wei.
        - Parameters:
            - callback : listener for the price.
     
     - SeeAlso: `BigIntegerCallback`
     */
    public func gasPrice(callback: @escaping BigIntegerCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.gasPrice.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
        } catch let error  {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the number of most recent block.
        - Parameters:
            - callback : listener for the most recent block
     
     - SeeAlso: `BigIntegerCallback`
     */
    public func blockNumber(callback: @escaping BigIntegerCallback) {
        do {
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.blockNumber.rawValue, params: nil)
            self.aionNetwork.send(relay: relay, callback: callback)
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
     
     - SeeAlso: `BigIntegerCallback`
     - SeeAlso: `BlockTag`
     */
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
    
    /**
     Returns the value from a storage position at a given address.
         - Parameters:
            - address : address to check for balance.
            - position integer of the position in the storage.
            - blockTag : integer block number, or the string "latest", "earliest" or "pending".
            - callback : listener for balance from address.
     
     - SeeAlso: `StringCallback`
     - SeeAlso: `BlockTag`
     - SeeAlso: `BigInt`
     */
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
    
    
    /**
     Returns the number of transactions sent from an address.
     - Parameters:
        - address : address to check for balance.
        - blockTag : integer block number, or the string "latest", "earliest" or "pending".
        - callback : listener for balance from address.
     
     - SeeAlso: `BigIntegerCallback`
     - SeeAlso: `BlockTag`
     */
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
    
    /**
     Returns the number of transactions in a block from a block matching the given block hash.
        - Parameters:
            - blockHashHex : hash of a block.
            - callback : listener for the transaction count By Hash.
     
     - SeeAlso: `BigIntegerCallback`
     */
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
    
    /**
     Returns the number of transactions in a block matching the given block number.
        - Parameters:
            - blockTag : integer block number, or the string "latest", "earliest" or "pending".
            - callback : listener for the transaction count By Number.
     
     - SeeAlso: `BigIntegerCallback`
     - SeeAlso: `BlockTag`
     */
    public func getBlockTransactionCountByNumber(blockTag: BlockTag?, callback: @escaping BigIntegerCallback) {
        do {
            let params: [String] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBlockTransactionCountByNumber.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
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
     
        - SeeAlso: `StringCallback`
     - SeeAlso: `BlockTag`
     */
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
     
     - SeeAlso: `StringCallback`
     - SeeAlso: `BlockTag`
     - SeeAlso: `BigUInt`
     */
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
    
    /**
     Returns information about a block by hash.
        - Parameters:
            - blockHash : Hash of a block.
            - fullTx : Full transaction objects.
            - callback : listener to get the Block By Hash.
     
     - SeeAlso: `JSONObjectCallback`
     */
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
    
    /**
     Returns information about a block by hash.
         - Parameters:
            - blockTag : integer block number, or the string "latest", "earliest" or "pending".
            - fullTx : Full transaction objects.
            - callback : listener to get the Block By Number.
     
     - SeeAlso: `JSONObjectCallback`
     - SeeAlso: `BlockTag`
     */
    public func getBlockByNumber(blockTag: BlockTag?, fullTx: Bool = false, callback: @escaping JSONObjectCallback) {
        do{
            let params: [Any] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue(), fullTx]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getBlockByNumber.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the information about a transaction requested by transaction hash.
        - Parameters:
            - txHash : hash of a transaction.
            - callback : listener to get transaction by Hash.
     
     - SeeAlso: `JSONObjectCallback`
     */
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
    
    
    /**
     Returns information about a transaction by block number and transaction index position.
        - Parameters:
            - blockHash : hash of a block.
            - index:  the transaction index position.
            - callback : listener to get the transaction Block Hash Index.
     
     - SeeAlso: `JSONObjectCallback`
     - SeeAlso: `BigInt`
     */
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
    
    
    /**
     Returns information about a transaction by block number and transaction index position.
        - Parameters:
            - blockTag : integer block number, or the string "latest", "earliest" or "pending".
            - index:  the transaction index position.
            - callback : listener to get the transaction by block number at index.
     
     - SeeAlso: `JSONObjectCallback`
     - SeeAlso: `BlockTag`
     - SeeAlso: `BigInt`
     */
    public func getTransactionByBlockNumberAndIndex(blockTag: BlockTag?, index: BigInt, callback: @escaping JSONObjectCallback) {
        do{
            let params: [Any] = [BlockTag.tagOrLatest(blockTag: blockTag).getValue(), index.toHexString()]
            let relay = try self.aionNetwork.createAionRelay(method: AionEthRPCMethod.getTransactionByBlockNumberAndIndex.rawValue, params: params)
            self.aionNetwork.send(relay: relay, callback: callback)
        }catch let error {
            callback(PocketError.custom(message: error.localizedDescription), nil)
        }
    }
    
    /**
     Returns the receipt of a transaction by transaction hash.
        - Parameters:
            - txHash : hash of a transaction.
            - callback : listener to get the transaction receipt.
     
     - SeeAlso: `JSONObjectCallback`
     */
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
    
    /**
     Returns an array of all logs matching a given filter object.
        - Parameters:
            - fromBlock : Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
            - toBlock : Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
            - address : Contract address or a list of addresses from which logs should originate.
            - topics : Topics are order-dependent. Each topic can also be an array of DATA with "or" options.
            - blockHash : is a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash.
            - callback : listener to get logs.
     
     - SeeAlso: `JSONObjectCallback`
     */
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
     
     - SeeAlso: `BigIntegerCallback`
     - SeeAlso: `BigUInt`
     - SeeAlso: `BlockTag`
     */
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
     
     - SeeAlso: `StringCallback`
     - SeeAlso: `Wallet`
     - SeeAlso: `BlockTag`
     */
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

