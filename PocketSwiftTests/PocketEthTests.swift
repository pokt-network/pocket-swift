//
//  PocketEthTests.swift
//  PocketSwiftTests
//
//  Created by Luis De Leon on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import BigInt

@testable import PocketSwift

class PocketEthTests: QuickSpec {
    
    // Test Variables
    // Change DEVID to a registered developer ID
    let DEVID = "DEVID1"
    let MASTERY_NETWORK = 32;
    let MAX_NODES = 10;
    let TIMEOUT = 10000;
    let BLOCK_HASH = "0x89007206f2c5356505465949e9a2f4f37cee6da9dc04cc86271ab9aeb5ab076d";
    let BLOCK_NUMBER = 4123837;
    //let CALL_TO = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89";
    let CALL_DATA = "0x22e6d17f00000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000001000000000000000000000000700989575bb2c2cafffdc3c4f583dccf904f90cb00000000000000000000000000000000000000000000000000000000000000a00fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000c48656c6c6f20576f726c64210000000000000000000000000000000000000000";
    let TX_HASH = "0x5cdcf19fc3934f345fcc9204e48ad9087e5fd2817063d3f6fd0cf4ed9add2a18";
    let CONTRACT_ADDRESS = "0x700989575bb2c2cafffdc3c4f583dccf904f90cb";
    let CONTRACT_ABI = "[{\"outputs\":[{\"name\":\"\",\"type\":\"uint128\"},{\"name\":\"\",\"type\":\"bool\"},{\"name\":\"\",\"type\":\"address\"},{\"name\":\"\",\"type\":\"string\"},{\"name\":\"\",\"type\":\"bytes32\"}],\"letant\":true,\"payable\":false,\"inputs\":[{\"name\":\"a\",\"type\":\"uint128\"},{\"name\":\"b\",\"type\":\"bool\"},{\"name\":\"c\",\"type\":\"address\"},{\"name\":\"d\",\"type\":\"string\"},{\"name\":\"e\",\"type\":\"bytes32\"}],\"name\":\"echo\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint128\"}],\"letant\":true,\"payable\":false,\"inputs\":[],\"name\":\"pocketTestState\",\"type\":\"function\"},{\"outputs\":[],\"letant\":false,\"payable\":false,\"inputs\":[{\"name\":\"a\",\"type\":\"uint128\"}],\"name\":\"addToState\",\"type\":\"function\"},{\"outputs\":[{\"name\":\"\",\"type\":\"uint128\"}],\"letant\":true,\"payable\":false,\"inputs\":[{\"name\":\"a\",\"type\":\"uint128\"},{\"name\":\"b\",\"type\":\"uint128\"}],\"name\":\"multiply\",\"type\":\"function\"}]";
    let FUNCTION_NAME = "multiply";
    let FUNCTION_PARAMS = [2, 10];
    let PRIVATE_KEY = "b7942b268ade435dfc184a965035c878eb7c1814de09fcc384bf109edbf96108";
    let ADDRESS = "0xE1B33AFb88C77E343ECbB9388829eEf6123a980a";
    let ADDRESS_SECONDARY = "0x79b306dFD6369B3Ce6E1c993891C4503c327B47e";
    
    override func spec() {
        describe("Pocket Eth Wallet management tests") {
            
            var pocketEth: PocketEth!
            
            beforeEach {
                do {
                    pocketEth = try PocketEth(devID: self.DEVID, netIds: [PocketEth.Networks.Rinkeby.netID], maxNodes: 5, requestTimeOut: 10000)
                } catch {
                    XCTFail()
                }
            }
            
            it("should instantiate a Pocket Aion instance") {
                expect(pocketEth).toNot(beNil())
            }
            
            it("should create a new Wallet instance") {
                let wallet = try? pocketEth.rinkeby?.createWallet()
                expect(wallet).notTo(beNil())
                expect(wallet?.address).notTo(beNil())
                expect(wallet?.netID).notTo(beNil())
                expect(wallet?.privateKey).notTo(beNil())
            }
            
            it("should import a Wallet instance") {
                let wallet = try? pocketEth.rinkeby?.importWallet(privateKey: self.PRIVATE_KEY)
                
                expect(wallet).notTo(beNil())
                expect(wallet?.address).notTo(beNil())
                expect(wallet?.netID).notTo(beNil())
                expect(wallet?.privateKey).notTo(beNil())

            }
            
            it("should fail to import a Wallet due to bad Private Key") {
                do {
                    let _ = try pocketEth.rinkeby?.importWallet(privateKey: self.PRIVATE_KEY+"0x00x")
                } catch {
                    expect(error).to(matchError(PocketError.walletImport(message: "Invalid private key")))
                }
            }
        }
        
        describe("PocketEth ETH Namespace RPC Calls") {
            
            var pocketEth: PocketEth!
            
            beforeEach {
                do {
                    pocketEth = try PocketEth(devID: self.DEVID, netIds: [PocketEth.Networks.Rinkeby.netID], maxNodes: 5, requestTimeOut: 10000)
                } catch {
                    XCTFail()
                }
            }
            
            it("should retrieve the protocol version") {
                pocketEth.rinkeby?.eth.protocolVersion( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should retrieve the sync status of the node") {
                pocketEth.rinkeby?.eth.syncing( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(EthObjectOrBoolean.self))
                })
            }
            
            it("should retrieve the actual gas price") {
                pocketEth.rinkeby?.eth.gasPrice( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should retrieve the actual block number") {
                pocketEth.rinkeby?.eth.blockNumber( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should retrieve an account balance") {
                pocketEth.rinkeby?.eth.getBalance(address: self.ADDRESS, blockTag:  EthBlockTag.latest , callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beGreaterThanOrEqualTo(result))
                })
            }
            
            it("should fail to retrieve account balance") {
                pocketEth.rinkeby?.eth.getBalance(address: "", blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            
            it("should retrieve a storage information") {
                pocketEth.rinkeby?.eth.getStorageAt(address: self.CONTRACT_ADDRESS, position: BigInt(0), blockTag: nil, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should fail to retrieve a storage information by passing empty address") {
                pocketEth.rinkeby?.eth.getStorageAt(address: "", position: BigInt(0), blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            
            it("should retrieve an address transaction count") {
                pocketEth.rinkeby?.eth.getTransactionCount(address: self.ADDRESS, blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should fail to retrieve an address transaction count by passing empty address") {
                pocketEth.rinkeby?.eth.getTransactionCount(address: "", blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            
            it("should retrieve a block transaction count") {
                pocketEth.rinkeby?.eth.getBlockTransactionCountByHash(blockHash: self.BLOCK_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should fail to retrieve a block transaction count by passing empty block hash") {
                pocketEth.rinkeby?.eth.getBlockTransactionCountByHash(blockHash: "", callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            
            it("should retrieve a block transaction count by using the block number") {
                pocketEth.rinkeby?.eth.getBlockTransactionCountByNumber(blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should retrieve the code at the given address") {
                pocketEth.rinkeby?.eth.getCode(address: self.CONTRACT_ADDRESS, blockTag: nil, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should fail to retrieve the code at the given address by using empty address") {
                pocketEth.rinkeby?.eth.getCode(address: "", blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // call
            it("should execute a new message call") {
                pocketEth.rinkeby?.eth.call(from: nil, to: self.CONTRACT_ADDRESS, gas: BigUInt(50000), gasPrice: BigUInt(20000000000), value: BigUInt(20000000000), data: self.CALL_DATA, blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should fail to execute a new message call without destination address") {
                pocketEth.rinkeby?.eth.call(from: nil, to: "", gas: BigUInt(50000), gasPrice: BigUInt(20000000000), value: BigUInt(20000000000), data: self.CALL_DATA, blockTag:  EthBlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getBlockByHash
            it("should retrieve the block information with the block hash") {
                pocketEth.rinkeby?.eth.getBlockByHash(blockHash: self.BLOCK_HASH, fullTx: true, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve the block information with an empty block hash") {
                pocketEth.rinkeby?.eth.getBlockByHash(blockHash: "", fullTx: true, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getBlockByNumber
            it("should retrieve the block information with the block number") {
                pocketEth.rinkeby?.eth.getBlockByNumber(blockTag:  EthBlockTag.number(BigInt(self.BLOCK_NUMBER)), fullTx: true, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            // getTransactionByHash
            it("should retrieve a transaction information with the transaction hash") {
                pocketEth.rinkeby?.eth.getTransactionByHash(txHash: self.TX_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail retrieve a transaction information with an empty tx hash") {
                pocketEth.rinkeby?.eth.getTransactionByHash(txHash: "", callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getTransactionByBlockHashAndIndex
            it("should retrieve a transaction information with the block hash and index") {
                pocketEth.rinkeby?.eth.getTransactionByBlockHashAndIndex(blockHash: self.BLOCK_HASH, index: BigInt(0), callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve a transaction information with an empty block hash") {
                pocketEth.rinkeby?.eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getTransactionByBlockNumberAndIndex
            it("should retrieve a transaction information with the block hash and index") {
                pocketEth.rinkeby?.eth.getTransactionByBlockNumberAndIndex(blockTag:  EthBlockTag.number(BigInt(self.BLOCK_NUMBER)), index: BigInt(0), callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve a transaction information with an empty block hash") {
                pocketEth.rinkeby?.eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getTransactionReceipt
            it("should retrieve a transaction receipt using the transaction hash") {
                pocketEth.rinkeby?.eth.getTransactionReceipt(txHash: self.TX_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve a transaction receipt using an empty transaction hash") {
                pocketEth.rinkeby?.eth.getTransactionReceipt(txHash: "", callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getLogs
            it("should retrieve the logs with the block hash") {
                pocketEth.rinkeby?.eth.getLogs(fromBlock: nil, toBlock: nil, address: nil, topics: nil, blockhash: self.BLOCK_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([[String: Any]].self))
                })
            }
            // estimateGas
            it("should retrieve the estimate gas value for a transaction") {
                pocketEth.rinkeby?.eth.estimateGas(from: nil, to: self.CONTRACT_ADDRESS, gas: nil, gasPrice: nil, value: nil, data: self.CALL_DATA, blockTag: nil, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should fail to retrieve the estimate gas value for a transaction using empty destination address") {
                pocketEth.rinkeby?.eth.estimateGas(from: nil, to: "", gas: nil, gasPrice: nil, value: nil, data: self.CALL_DATA, blockTag: nil, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
        }
        
        describe("PocketEth NET Namespace RPC Calls") {
            var pocketEth: PocketEth!

            beforeEach {
                do {
                    pocketEth = try PocketEth.init(devID: self.DEVID, netIds: [PocketEth.Networks.Rinkeby.netID], defaultNetID: PocketEth.Networks.Rinkeby.netID, maxNodes: 5, requestTimeOut: 10000)
                } catch {
                    XCTFail()
                }
                
            }

            it("should retrieve the current network id") {
                pocketEth.rinkeby?.net.version(callback: { (error, response) in
                    expect(error).to(beNil())
                    expect(response).notTo(beNil())
                })
            }

            it("should retrieve the listening status of the node") {
                pocketEth.rinkeby?.net.listening(callback: { (error, response) in
                    expect(error).to(beNil())
                    expect(response).notTo(beNil())
                })
            }

            it("should retrieve the number of peers currently connected") {
                pocketEth.rinkeby?.net.peerCount(callback: { (error, response) in
                    expect(error).to(beNil())
                    expect(response).notTo(beNil())
                })
            }
        }
        
        describe("EthContract class tests") {
            
            var pocketTestContract: EthContract!
            var pocketEth: PocketEth!
            beforeEach {
                do {
                    pocketEth = try PocketEth.init(devID: self.DEVID, netIds: [PocketEth.Networks.Rinkeby.netID], defaultNetID: PocketEth.Networks.Rinkeby.netID, maxNodes: 5, requestTimeOut: 10000)
                    pocketTestContract = try pocketEth.rinkeby?.createEthContract(address: self.CONTRACT_ADDRESS, abiDefinition: self.CONTRACT_ABI)
                } catch {
                    XCTFail()
                }
            }
            
            
            it("should execute a constant functions") {
                do {
                    try pocketTestContract.executeConstantFunction(functionName: "multiply", functionParams: [BigInt("2"), BigInt("10")] as [AnyObject], fromAddress: nil, gas: nil, gasPrice: nil, value: nil, blockTag: nil, callback: { (error, results) in
                        expect(error).to(beNil())
                        expect(results).notTo(beNil())
                        expect(results?.count).to(equal(1))
                        expect("\(results?.first ?? 1)").to(equal("20"))
                    })
                } catch {
                    XCTFail()
                }
            }
            
            it("should execute a constant function with multiple returns") {
                do {
                    var params: [AnyObject] = []
                    params.append(BigInt("100") as AnyObject)
                    params.append(Bool.init(booleanLiteral: true) as AnyObject)
                    params.append(self.CONTRACT_ADDRESS as AnyObject)
                    params.append("Hello World!" as AnyObject)
                    params.append("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" as AnyObject)
                    
                    try pocketTestContract.executeConstantFunction(functionName: "echo", functionParams: params, fromAddress: nil, gas: nil, gasPrice: nil, value: nil, blockTag: nil, callback: { (error, results) in
                        expect(error).to(beNil())
                        expect(results).notTo(beNil())
                        expect(results?.count).to(equal(5))
                        expect("\(results?[4] ?? 0)").to(equal("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0f"))
                        expect(results?[1] as? Bool).to(equal(Bool.init(booleanLiteral: true)))
                        expect("\(results?[3] ?? 0)").to(equal("Hello World!"))
                        expect("\(results?[0] ?? 0)").to(equal("100"))
                        expect("\(results?[2] ?? 0)".uppercased()).to(equal(self.CONTRACT_ADDRESS.uppercased()))
                    })
                } catch {
                    XCTFail()
                }
            }
            
            it("should execute a function that alters the smart contract state") {
                do {
                    let params: [AnyObject] = [BigInt.init("1") as AnyObject]
                    guard let wallet = try pocketEth.rinkeby?.importWallet(privateKey: self.PRIVATE_KEY) else {
                        XCTFail()
                        return
                    }
                    
                    try pocketTestContract.executeFunction(functionName: "addToState", wallet: wallet, functionParams: params, nonce: nil, gas: BigUInt.init(100000), gasPrice: BigUInt.init(10000000000 as UInt64), value: BigUInt.init(0), callback: { (error, txHash) in
                        expect(error).to(beNil())
                        expect(txHash).toNot(beNil())
                    })
                } catch {
                    XCTFail()
                }
            }
            
        }
    }
    
}
