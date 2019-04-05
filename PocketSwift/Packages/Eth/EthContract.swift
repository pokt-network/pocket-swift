//
//  EthContract.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt
import Web3swift
import EthereumABI

public class EthContract {
    
    private let ethNetwork: EthNetwork
    private let address: String
    private var functions: [String: ABI.Element]! = [String: ABI.Element]()
    
    init(ethNetwork: EthNetwork, address: String, abiDefinition: String) throws {
        self.ethNetwork = ethNetwork
        self.address = address
        guard let abiDefinitionData = abiDefinition.data(using: .utf8) else {
            throw PocketError.custom(message: "Error parsing abiDefinition JSON: \(abiDefinition)")
        }
        do {
            let abi = try JSONDecoder().decode([ABI.Record].self, from: abiDefinitionData)
            let abiNative = try abi.map({ (record) -> ABI.Element in
                return try record.parse()
            })
            
            // Filter out functions from the abi array
            for abiFunction in abiNative {
                switch abiFunction {
                case .function(let function):
                    guard let name = function.name else {continue}
                    self.functions[name] = abiFunction
                default:
                    continue
                }
            }
        } catch let error {
            throw PocketError.custom(message: error.localizedDescription)
        }
    }
    
    public func executeConstantFunction(functionName: String, functionParams: [AnyObject] = [AnyObject](), fromAddress: String?, gas: BigUInt?, gasPrice: BigUInt?, value: BigUInt?, blockTag: EthBlockTag?, callback: @escaping AnyArrayCallback) throws {
        guard let abiFunction = self.functions[functionName] else {
            throw PocketError.custom(message: "Invalid function name: \(functionName)")
        }
        
        guard let encodedFunctionData = abiFunction.encodeParameters(functionParams) else {
            throw PocketError.custom(message: "Invalid function data for params: \(functionParams)")
        }
        
        let encodedHexData = encodedFunctionData.toHexString()
        self.ethNetwork.eth.call(from: fromAddress, to: self.address, gas: gas, gasPrice: gasPrice, value: value, data: encodedHexData, blockTag: blockTag) { (error, callResponse) in
            if let error = error {
                callback(error, nil)
                return
            }
            
            guard let callResponseHex = callResponse?.data(using: .utf8) else {
                callback(PocketError.custom(message: "Invalid response hex: \(callResponse ?? "No data returned")"), nil)
                return
            }
            
            guard let decodedDict = abiFunction.decodeReturnData(callResponseHex) else {
                callback(PocketError.custom(message: "Error decoding response hex: \(callResponseHex)"), nil)
                return
            }
            
            var result: [Any] = []
            for (_, value) in decodedDict {
                result.append(value)
            }
            
            callback(nil, result)
        }
    }
    
    public func executeFunction(functionName: String, wallet: Wallet, functionParams: [AnyObject] = [AnyObject](), nonce: BigUInt?, gas: BigUInt, gasPrice: BigUInt, value: BigUInt, callback: @escaping StringCallback) throws {
        guard let abiFunction = self.functions[functionName] else {
            throw PocketError.custom(message: "Invalid function name: \(functionName)")
        }
        
        guard let encodedFunctionData = abiFunction.encodeParameters(functionParams) else {
            throw PocketError.custom(message: "Invalid function data for params: \(functionParams)")
        }
        
        let encodedHexData = encodedFunctionData.toHexString()
        
        if let nonceParam = nonce {
            self.ethNetwork.eth.sendTransaction(wallet: wallet, toAddress: self.address, gas: gas, gasPrice: gasPrice, data: encodedHexData, nonce: nonceParam, callback: callback)
        } else {
            // Fetch the current nonce and send the transaction
            self.ethNetwork.eth.getTransactionCount(address: wallet.address, blockTag: nil) { (error, transactionCount) in
                if let error = error {
                    callback(error, nil)
                    return
                }
                
                guard let transactionCountBigInt = transactionCount else {
                    callback(PocketError.custom(message: "Invalid transaction count: \(String(describing: transactionCount))"), nil)
                    return
                }
                
                self.ethNetwork.eth.sendTransaction(wallet: wallet, toAddress: self.address, gas: gas, gasPrice: gasPrice, data: encodedHexData, nonce: BigUInt.init(transactionCountBigInt), callback: callback)
                
            }
        }
    }
}
