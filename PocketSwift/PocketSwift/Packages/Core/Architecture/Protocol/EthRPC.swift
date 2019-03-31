//
//  EthRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

protocol EthRPC: RPC {
    //func send(transaction: Transaction, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func sendTransaction(for wallet: Wallet, with params: [AnyHashable : Any], onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func getBalance(address: String, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
    func getStorageAt(address: String, position: BigInt, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
    func getTransactionCount(address: String, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
    func getBlockTransactionCountByHash(blockHash: String, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
    func getBlockTransactionCountByNumber(blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
    func getCode(address: String, blockTag: DefaultBlock, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func call(from: String?, to: String, nrg: BigInt?, nrgPrice: BigInt?, value: BigInt?, data: String?, blockTag: DefaultBlock, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func getBlockByHash(blockHash: String, fullTx: Bool, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ())
    func getBlockByNumber(blockTag: DefaultBlock, fullTx: Bool, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ())
    func getTransactionByHash(txHash: String, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ())
    func getTransactionByBlockHashAndIndex(blockHash: String, index: BigInt, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ())
    func getTransactionByBlockNumberAndIndex(blockTag: DefaultBlock, index: BigInt, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ())
    func getTransactionReceipt(txHash: String, onSuccess: @escaping ([String: Any]) -> (), onError: @escaping (Error) -> ())
    func getLogs(fromBlock: DefaultBlock, toBlock: DefaultBlock, address: String?, topics: [String]?, blockhash: String?, onSuccess: @escaping ([[String: Any]]) -> (), onError: @escaping (Error) -> ())
    func estimateGas(from: String?, to: String, nrg: BigInt?, nrgPrice: BigInt?, value: BigInt?, data: String?, blockTag: DefaultBlock, onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
}
