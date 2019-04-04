//
//  AionContract.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt
import JavaScriptCore

public class AionContract {
    
    private let aionNetwork: AionNetwork
    private let address: String
    private var functions = [String: Any]()
    
    public init(aionNetwork: AionNetwork, address: String, abiDefinition: String) throws {
        self.aionNetwork = aionNetwork
        self.address = address
        guard let abi = abiDefinition.toDictArray() else {
            throw PocketError.custom(message: "Error parsing abiDefinition JSON: \(abiDefinition)")
        }
        
        // Filter out functions from the abi array
        for element in abi {
            if (element["type"] as! String) == "function" {
                let functionName = element["name"] as! String
                // Create new key value for the function
                functions[functionName] = element
            }
        }
        
    }
    
    private func encodeParameters(params: [Any], functionJSON: [String: Any]) throws -> String? {
        guard let functionJSONStr = try? functionJSON.toJson() else{
            throw PocketError.custom(message: "Failed to retrieve function json string.")
        }
        
        guard let formattedRpcParams = RpcParamsUtil.formatRpcParams(params: params) else {
            throw PocketError.custom(message: "Failed to format rpc params.")
        }
        
        let functionParamsStr = formattedRpcParams.joined(separator: ",")
        
        let encodedFunction = try self.encodeFunction(functionStr: functionJSONStr, params: functionParamsStr)
        
        return encodedFunction
    }
    
    private func encodeFunction(functionStr: String, params: String) throws -> String {
        // Generate code to run
        let jsContext = self.aionNetwork.pocketAion.jsContext
        guard let jsFile = try? AionUtils.getFileForResource(name: "encodeFunction", ext: "js") else{
            throw PocketError.custom(message: "Failed to retrieve encodeFunction.js file")
        }
        
        // Check if is empty and evaluate script with the transaction parameters using string format %@
        if !jsFile.isEmpty {
            let jsCode = String(format: jsFile, functionStr, params)
            // Evaluate js code
            jsContext.evaluateScript(jsCode)
        }else {
            throw PocketError.custom(message: "Failed to retrieve signed tx js string")
        }
        
        // Retrieve
        guard let functionCallData = jsContext.objectForKeyedSubscript("functionCallData") else {
            throw PocketError.custom(message: "Failed to retrieve window js object")
        }
        
        // return function call result
        return functionCallData.toString()
    }
    
    private func decodeReturnData(encodedResult: String, function: [String: Any]) throws -> [Any] {
        
        let jsContext = self.aionNetwork.pocketAion.jsContext
        
        // Generate code to run
        guard let jsFile = try? AionUtils.getFileForResource(name: "decodeFunctionReturn", ext: "js") else {
            throw PocketError.custom(message: "Failed to retrieve encodeFunction")
        }
        
        guard let functionStr = try? function.toJson() else{
            throw PocketError.custom(message: "Failed to parse function object")
        }
        
        // Check if is empty and evaluate script with the transaction parameters using string format %@
        if !jsFile.isEmpty {
            let jsCode = String(format: jsFile, encodedResult, functionStr)
            // Evaluate js code
            jsContext.evaluateScript(jsCode)
        }else {
            throw PocketError.custom(message: "Failed to retrieve signed tx js string")
        }
        
        // Retrieve
        guard let decodedResponse = jsContext.objectForKeyedSubscript("decodedValue") else {
            throw PocketError.custom(message: "Failed to retrieve decoded response")
        }
        
        var result: [Any] = []
        if decodedResponse.isArray {
            result = decodedResponse.toArray()
        } else {
            result = []
            result.append(decodedResponse.toObject()!)
        }
        
        return result
    }
    
    public func executeConstantFunction(functionName: String, functionParams: [Any] = [Any](), fromAddress: String?, gas: BigUInt?, gasPrice: BigUInt?, value: BigUInt?, blockTag: BlockTag?, callback: @escaping AnyArrayCallback) throws {
        
        guard let abiFunction = self.functions[functionName] as? [String: Any] else {
            throw PocketError.custom(message: "Invalid function name: \(functionName)")
        }
        
        guard let encodedFunctionData = try encodeParameters(params: functionParams, functionJSON: abiFunction) else {
            throw PocketError.custom(message: "Invalid function data for params: \(functionParams)")
        }
        
        self.aionNetwork.eth.call(from: fromAddress, to: self.address, gas: gas, gasPrice: gasPrice, value: value, data: encodedFunctionData, blockTag: blockTag) { (error, result) in
            if let error = error {
                callback(error, nil)
                return
            }
            
            guard let callResponseHex = result else {
                callback(PocketError.custom(message: "Invalid response hex: \(result ?? "No data returned")"), nil)
                return
            }
            do {
                let decodedDict = try self.decodeReturnData(encodedResult: callResponseHex, function: abiFunction)
                
                callback(nil, decodedDict)
            }catch{
                callback(PocketError.custom(message: "Error decoding response hex: \(callResponseHex)"), nil)
                return
            }
            
        }
        
    }
    
    public func executeFunction(functionName: String, wallet: Wallet, functionParams: [Any] = [Any](), nonce: BigUInt?, gas: BigUInt, gasPrice: BigUInt, value: BigUInt?, callback: @escaping StringCallback) throws {
        
        guard let abiFunction = self.functions[functionName] as? [String: Any] else {
            throw PocketError.custom(message: "Invalid function name: \(functionName)")
        }
        
        guard let encodedFunctionData = try encodeParameters(params: functionParams, functionJSON: abiFunction) else {
            throw PocketError.custom(message: "Invalid function data for params: \(functionParams)")
        }
        
        if let nonceParam = nonce {
            self.aionNetwork.eth.sendTransaction(wallet: wallet, nonce: nonceParam, to: self.address, nrg: gas, nrgPrice: gasPrice, value: value, data: encodedFunctionData) { (error, result) in
                
                if let error = error {
                    callback(error, nil)
                    return
                }
                
                callback(nil, result)
            }
        } else {
            // Fetch the current nonce and send the transaction
            self.aionNetwork.eth.getTransactionCount(address: wallet.address, blockTag: nil) { (error, transactionCount) in
                if let error = error {
                    callback(error, nil)
                    return
                }
                
                guard let txCount = transactionCount else {
                    callback(PocketError.custom(message: "Invalid transaction count: \(String(describing: transactionCount))"), nil)
                    return
                }
                
                self.aionNetwork.eth.sendTransaction(wallet: wallet, nonce: BigUInt(txCount), to: self.address, nrg: gas, nrgPrice: gasPrice, value: value, data: encodedFunctionData) { (error, result) in
                    
                    if let error = error {
                        callback(error, nil)
                        return
                    }
                    
                    callback(nil, result)
                }
                
            }
        }
    }
}
