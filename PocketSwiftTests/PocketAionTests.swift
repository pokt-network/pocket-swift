//
//  PocketAionTests.swift
//  PocketSwiftTests
//
//  Created by Wilson Garcia on 3/22/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import BigInt

@testable import PocketSwift

class PocketAionTests: QuickSpec {
    
    enum netID: String {
        case mastery = "32"
        case prod = "256"
    }
    // Change DEVID to a registered developer ID
    let DEVID = "DEVID1"
    // Test Variables
    let MASTERY_NETWORK = 32;
    let MAX_NODES = 10;
    let TIMEOUT = 10000;
    let STORAGE_ADDRESS = "0xa061d41a9de8b2f317073cc331e616276c7fc37a80b0e05a7d0774c9cf956107";
    let BLOCK_HASH = "0xa9316ee7207cf2ac1fd886673d5c14835a86cda97eae8f0d382b95678932c8d0";
    let BLOCK_NUMBER = 1329667;
    let CODE_ADDRESS = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89";
    let CALL_TO = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89";
    let CALL_DATA = "0xbbaa08200000000000000000000000000000014c00000000000000000000000000000154";
    let ESTIMATE_GAS_TO = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89";
    let ESTIMATE_GAS_DATA = "0xbbaa0820000000000000000000000000000000020000000000000000000000000000000a";
    let TX_HASH = "0x123075c535309a3b0dbbe5c97a7a5298ec7f1bd3ae1b684ec529df3ce16cab2e";
    let BLOCK_HASH_LOGS = "0xa9316ee7207cf2ac1fd886673d5c14835a86cda97eae8f0d382b95678932c8d0";
    let CONTRACT_ADDRESS = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89";
    let FUNCTION_NAME = "multiply";
    let FUNCTION_PARAMS = [2, 10];
    let PRIVATE_KEY = "0x2b5d6fd899ccc148b5f85b4ea20961678c04d70055b09dac7857ea430757e6badb4cfe129e670e2fef1b632ed0eab9572954feebbea9cb32134b284763acd34e";
    let ADDRESS = "0xa05b88ac239f20ba0a4d2f0edac8c44293e9b36fa937fb55bf7a1cd61a60f036";
    let ADDRESS_TO = "0xa07743f4170ded07da3ccd2ad926f9e684a5f61e90d018a3c5d8ea60a8b3406a";
    let PRIVATE_KEY2 = "ab6f38ace08e94d29dd50eccdeedee39d468de42890564d63eb39b8e31450207257602da2f0d5318e811794500b144af16fb71d3978bdc05f16c94036da0ead2";
    let ADDRESS2 = "0xa002effbab4142413333c7e231a71b4fe20f0e730a1d9a8dd107a8c434087b46";
    let FUNCTION_PARAMS2 = [1];
    let FUNCTION_NAME2 = "addToState";
    
    public enum SmartContract: Int {
        case simple = 1
        case types = 2
        
        func jsonFileStr() throws -> String {
            switch self {
            case .simple:
                return try AionUtils.getFileForResource(name: "simpleContract", ext: "json")
            case .types:
                return try AionUtils.getFileForResource(name: "typeContract", ext: "json")
            }
        }
    }
    
    override func spec() {
        Nimble.AsyncDefaults.Timeout = 20
        
        describe("Pocket Aion Class tests") {
            // PocketAion Instance
            guard let pocketAion = try? PocketAion(devID: self.DEVID, netIds: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 10000) else {
                XCTFail()
                return
            }
            
            it("should instantiate a Pocket Aion instance") {
                expect(pocketAion).toNot(beNil())
            }
            
            it("should create a new Wallet instance") {
                let wallet = try? pocketAion.mastery?.createWallet()
                expect(wallet).notTo(beNil())
                expect(wallet?.address).notTo(beNil())
                expect(wallet?.netID).notTo(beNil())
                expect(wallet?.privateKey).notTo(beNil())
            }
            
            it("should import a Wallet instance") {
                let wallet = try? pocketAion.mastery?.importWallet(privateKey: self.PRIVATE_KEY)
                expect(wallet).notTo(beNil())
                expect(wallet?.address).notTo(beNil())
                expect(wallet?.netID).notTo(beNil())
                expect(wallet?.privateKey).notTo(beNil())
            }
            
            it("should fail to import a Wallet due to bad Private Key") {
                do {
                    let _ = try pocketAion.importWallet( privateKey: self.PRIVATE_KEY+"xx0x0x", netID: netID.mastery.rawValue)
                } catch {
                    expect(error).to(matchError(PocketError.walletImport(message: "Invalid Private key")))
                }
            }
        }
        
        describe("PocketAion ETH Namespace RPC Calls") {
            
            // PocketAion Instance
            guard let pocketAion = try? PocketAion(devID: self.DEVID, netIds: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 10000) else {
                XCTFail()
                return
            }
            
            it("should retrieve the protocol version") {
                waitUntil { done in
                    pocketAion.mastery?.eth.protocolVersion( callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(String.self))
                        done()
                    })
                }
            }
            
            it("should retrieve the sync status of the node") {
                waitUntil { done in
                    pocketAion.mastery?.eth.syncing( callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(ObjectOrBoolean.self))
                        done()
                    })
                }
            }
            
            it("should retrieve the actual gas price") {
                waitUntil { done in
                    pocketAion.mastery?.eth.gasPrice( callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
            
            it("should retrieve the actual block number") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.blockNumber( callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
            
            it("should retrieve an account balance") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBalance(address: self.ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beGreaterThanOrEqualTo(result))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve account balance") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBalance(address: "", blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            
            it("should retrieve a storage information") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getStorageAt(address: self.STORAGE_ADDRESS, position: BigInt(0), blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(String.self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve a storage information by passing empty address") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getStorageAt(address: "", position: BigInt(0), blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            
            it("should retrieve an address transaction count") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionCount(address: self.ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve an address transaction count by passing empty address") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionCount(address: "", blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            
            it("should retrieve a block transaction count") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBlockTransactionCountByHash(blockHash: self.BLOCK_HASH, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve a block transaction count by passing empty block hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBlockTransactionCountByHash(blockHash: "", callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            
            it("should retrieve a block transaction count by using the block number") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBlockTransactionCountByNumber(blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
            
            it("should retrieve the code at the given address") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getCode(address: self.CODE_ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(String.self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve the code at the given address by using empty address") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getCode(address: "", blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // call
            it("should execute a new message call") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.call(from: nil, to: self.CALL_TO, gas: BigUInt(50000), gasPrice: BigUInt(20000000000), value: BigUInt(20000000000), data: self.CALL_DATA, blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(String.self))
                        done()
                    })
                }
            }
            
            it("should fail to execute a new message call without destination address") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.call(from: nil, to: "", gas: BigUInt(50000), gasPrice: BigUInt(20000000000), value: BigUInt(20000000000), data: self.CALL_DATA, blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // getBlockByHash
            it("should retrieve the block information with the block hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBlockByHash(blockHash: self.BLOCK_HASH, fullTx: true, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([String: Any].self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve the block information with an empty block hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBlockByHash(blockHash: "", fullTx: true, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // getBlockByNumber
            it("should retrieve the block information with the block number") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getBlockByNumber(blockTag: BlockTag.number(BigInt(self.BLOCK_NUMBER)), fullTx: true, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([String: Any].self))
                        done()
                    })
                }
            }
            // getTransactionByHash
            it("should retrieve a transaction information with the transaction hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionByHash(txHash: self.TX_HASH, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([String: Any].self))
                        done()
                    })
                }
            }
            
            it("should fail retrieve a transaction information with an empty tx hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionByHash(txHash: "", callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // getTransactionByBlockHashAndIndex
            it("should retrieve a transaction information with the block hash and index") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionByBlockHashAndIndex(blockHash: self.BLOCK_HASH, index: BigInt(0), callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([String: Any].self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve a transaction information with an empty block hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // getTransactionByBlockNumberAndIndex
            it("should retrieve a transaction information with the block hash and index") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionByBlockNumberAndIndex(blockTag: BlockTag.number(BigInt(self.BLOCK_NUMBER)), index: BigInt(0), callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([String: Any].self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve a transaction information with an empty block hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // getTransactionReceipt
            it("should retrieve a transaction receipt using the transaction hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionReceipt(txHash: self.TX_HASH, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([String: Any].self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve a transaction receipt using an empty transaction hash") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.getTransactionReceipt(txHash: "", callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // TODO: Need a valid block hash with filter changes
            // getLogs
//            it("should retrieve the logs with the block hash") {
//                waitUntil { done in
//
//                    pocketAion.mastery?.eth.getLogs(fromBlock: nil, toBlock: nil, address: nil, topics: nil, blockhash: self.BLOCK_HASH_LOGS, callback: { (error, result) in
//                        expect(error).to(beNil())
//                        done()
//                    })
//                }
//            }
            // estimateGas
            it("should retrieve the estimate gas value for a transaction") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.estimateGas(from: nil, to: self.ESTIMATE_GAS_TO, gas: nil, gasPrice: nil, value: nil, data: self.ESTIMATE_GAS_DATA, blockTag: nil, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
            
            it("should fail to retrieve the estimate gas value for a transaction using empty destination address") {
                waitUntil { done in
                    
                    pocketAion.mastery?.eth.estimateGas(from: nil, to: "", gas: nil, gasPrice: nil, value: nil, data: self.ESTIMATE_GAS_DATA, blockTag: nil, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            // sendTransaction
            it("should send a transaction") {
                let wallet = try? pocketAion.mastery?.importWallet(privateKey: self.PRIVATE_KEY)
                
                waitUntil { done in
                    pocketAion.mastery?.eth.getTransactionCount(address: wallet!.address, blockTag: BlockTag.latest, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        guard let nonce = result?.magnitude else{
                            XCTFail()
                            done()
                            return
                        }
                        
                        pocketAion.mastery?.eth.sendTransaction(wallet: wallet!, nonce: nonce, to: self.ADDRESS_TO, nrg: BigUInt(50000), nrgPrice: BigUInt(20000000000), value: BigUInt(20000000000), data: nil, callback: { (error, result) in
                            expect(error).to(beNil())
                            expect(result).to(beAKindOf(String.self))
                            done()
                        })
                    })
                }
            }
            
            it("should fail to retrieve the estimate gas value for a transaction using empty destination address") {
                waitUntil { done in
                    pocketAion.mastery?.eth.estimateGas(from: nil, to: "", gas: nil, gasPrice: nil, value: nil, data: self.ESTIMATE_GAS_DATA, blockTag: nil, callback: { (error, result) in
                        expect(error).toNot(beNil())
                        expect(result).to(beNil())
                        done()
                    })
                }
            }
            
        }
        
        describe("PocketAion NET Namespace RPC Calls") {
            let pocketAion = try? PocketAion(devID: self.DEVID, netIds: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 10000)
            
            it("should retrieve the current network id") {
                waitUntil { done in
                    pocketAion?.mastery?.net.version(callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(String.self))
                        done()
                    })
                }
            }
            
            it("should retrieve the listening status of the node") {
                waitUntil { done in
                    pocketAion?.mastery?.net.listening(callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(Bool.self))
                        done()
                    })
                }
            }
            
            it("should retrieve the number of peers currently connected") {
                waitUntil { done in
                    pocketAion?.mastery?.net.peerCount(callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(BigInt.self))
                        done()
                    })
                }
            }
        }
        
        describe("AionContract Class tests") {
            let pocketAion = try? PocketAion(devID: self.DEVID, netIds: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 10000)
            let abi = try? SmartContract.simple.jsonFileStr()

            let aionContract = try? AionContract.init(aionNetwork: pocketAion!.mastery!, address: CONTRACT_ADDRESS, abiDefinition: abi!)

            it("should return the result of multiply 2 by 10") {
                waitUntil { done in
                    try? aionContract?.executeConstantFunction(functionName: self.FUNCTION_NAME, functionParams: self.FUNCTION_PARAMS, fromAddress: nil, gas: BigUInt(50000), gasPrice: BigUInt(20000000000), value: nil, blockTag: nil, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf([Any].self))
                        done()
                    })
                }
            }
            
            it("should add 1 value to the test smart contract state") {
                let wallet = try? pocketAion!.mastery?.importWallet(privateKey: self.PRIVATE_KEY2)

                waitUntil { done in
                    try? aionContract?.executeFunction(functionName: self.FUNCTION_NAME2, wallet: wallet!, nonce: nil, gas: BigUInt(50000), gasPrice: BigUInt(20000000000), value: nil, callback: { (error, result) in
                        expect(error).to(beNil())
                        expect(result).to(beAKindOf(String.self))
                        done()
                    })
                }
            }
        }
    }
}
