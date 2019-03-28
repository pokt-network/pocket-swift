//
//  EthRPCMethod.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public enum EthRPCMethod: String {
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
