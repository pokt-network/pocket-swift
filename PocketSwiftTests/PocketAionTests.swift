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
    let DEVID = "DEVID1"
    // Test Variables
    let DEV_ID = "DEVID1";
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
//    let CONTRACT_ABI = [{"outputs":[{"name":"","type":"uint128"},{"name":"","type":"bool"},{"name":"","type":"address"},{"name":"","type":"string"},{"name":"","type":"bytes32"}],"letant":true,"payable":false,"inputs":[{"name":"a","type":"uint128"},{"name":"b","type":"bool"},{"name":"c","type":"address"},{"name":"d","type":"string"},{"name":"e","type":"bytes32"}],"name":"echo","type":"function"},{"outputs":[{"name":"","type":"uint128"}],"letant":true,"payable":false,"inputs":[],"name":"pocketTestState","type":"function"},{"outputs":[],"letant":false,"payable":false,"inputs":[{"name":"a","type":"uint128"}],"name":"addToState","type":"function"},{"outputs":[{"name":"","type":"uint128"}],"letant":true,"payable":false,"inputs":[{"name":"a","type":"uint128"},{"name":"b","type":"uint128"}],"name":"multiply","type":"function"}];
    let FUNCTION_NAME = "multiply";
    let FUNCTION_PARAMS = [2, 10];
    let PRIVATE_KEY = "0x2b5d6fd899ccc148b5f85b4ea20961678c04d70055b09dac7857ea430757e6badb4cfe129e670e2fef1b632ed0eab9572954feebbea9cb32134b284763acd34e";
    let ADDRESS = "0xa05b88ac239f20ba0a4d2f0edac8c44293e9b36fa937fb55bf7a1cd61a60f036";
    let ADDRESS_TO = "0xa07743f4170ded07da3ccd2ad926f9e684a5f61e90d018a3c5d8ea60a8b3406a";
    
    
    
    override func spec() {
        describe("Pocket Aion Class tests") {
            
            var pocketAion: PocketAion!
            
            beforeEach {
                do {
                    pocketAion = try PocketAion(devID: self.DEVID, netIds: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 10000)
                } catch {
                    XCTFail()
                }
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
            
            var pocketAion: PocketAion!
            
            beforeEach {
                do {
                    pocketAion = try PocketAion(devID: self.DEVID, netIds: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 10000)
                } catch {
                    XCTFail()
                }
            }
            
            it("should retrieve the protocol version") {
                pocketAion.mastery?.eth.protocolVersion( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should retrieve the sync status of the node") {
                pocketAion.mastery?.eth.syncing( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(Bool.self))
                })
            }
            
            it("should retrieve the actual gas price") {
                pocketAion.mastery?.eth.gasPrice( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should retrieve the actual block number") {
                pocketAion.mastery?.eth.blockNumber( callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should retrieve an account balance") {
                pocketAion.mastery?.eth.getBalance(address: self.ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beGreaterThanOrEqualTo(result))
                })
            }
            
            it("should fail to retrieve account balance") {
                pocketAion.mastery?.eth.getBalance(address: self.ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }

            it("should retrieve a storage information") {
                pocketAion.mastery?.eth.getStorageAt(address: self.STORAGE_ADDRESS, position: BigInt(0), blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should fail to retrieve a storage information by passing empty address") {
                pocketAion.mastery?.eth.getStorageAt(address: "", position: BigInt(0), blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }

            it("should retrieve an address transaction count") {
                pocketAion.mastery?.eth.getTransactionCount(address: self.ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should fail to retrieve an address transaction count by passing empty address") {
                pocketAion.mastery?.eth.getTransactionCount(address: "", blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }

            it("should retrieve a block transaction count") {
                pocketAion.mastery?.eth.getBlockTransactionCountByHash(blockHash: self.BLOCK_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should fail to retrieve a block transaction count by passing empty block hash") {
                pocketAion.mastery?.eth.getBlockTransactionCountByHash(blockHash: "", callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            
            it("should retrieve a block transaction count by using the block number") {
                pocketAion.mastery?.eth.getBlockTransactionCountByNumber(blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should retrieve the code at the given address") {
                pocketAion.mastery?.eth.getCode(address: self.CODE_ADDRESS, blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should fail to retrieve the code at the given address by using empty address") {
                pocketAion.mastery?.eth.getCode(address: "", blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // call
            it("should execute a new message call") {
                pocketAion.mastery?.eth.call(from: nil, to: self.CALL_TO, gas: BigInt(50000), gasPrice: BigInt(20000000000), value: BigInt(20000000000), data: self.CALL_DATA, blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(String.self))
                })
            }
            
            it("should fail to execute a new message call without destination address") {
                pocketAion.mastery?.eth.call(from: nil, to: "", gas: BigInt(50000), gasPrice: BigInt(20000000000), value: BigInt(20000000000), data: self.CALL_DATA, blockTag: BlockTag.latest, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getBlockByHash
            it("should retrieve the block information with the block hash") {
                pocketAion.mastery?.eth.getBlockByHash(blockHash: self.BLOCK_HASH, fullTx: true, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve the block information with an empty block hash") {
                pocketAion.mastery?.eth.getBlockByHash(blockHash: "", fullTx: true, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getBlockByNumber
            it("should retrieve the block information with the block number") {
                pocketAion.mastery?.eth.getBlockByNumber(blockTag: BlockTag.number(BigInt(self.BLOCK_NUMBER)), fullTx: true, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            // getTransactionByHash
            it("should retrieve a transaction information with the transaction hash") {
                pocketAion.mastery?.eth.getTransactionByHash(txHash: self.TX_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail retrieve a transaction information with an empty tx hash") {
                pocketAion.mastery?.eth.getTransactionByHash(txHash: "", callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getTransactionByBlockHashAndIndex
            it("should retrieve a transaction information with the block hash and index") {
                pocketAion.mastery?.eth.getTransactionByBlockHashAndIndex(blockHash: self.BLOCK_HASH, index: BigInt(0), callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve a transaction information with an empty block hash") {
                pocketAion.mastery?.eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getTransactionByBlockNumberAndIndex
            it("should retrieve a transaction information with the block hash and index") {
                pocketAion.mastery?.eth.getTransactionByBlockNumberAndIndex(blockTag: BlockTag.number(BigInt(self.BLOCK_NUMBER)), index: BigInt(0), callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve a transaction information with an empty block hash") {
                pocketAion.mastery?.eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getTransactionReceipt
            it("should retrieve a transaction receipt using the transaction hash") {
                pocketAion.mastery?.eth.getTransactionReceipt(txHash: self.TX_HASH, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([String: Any].self))
                })
            }
            
            it("should fail to retrieve a transaction receipt using an empty transaction hash") {
                pocketAion.mastery?.eth.getTransactionReceipt(txHash: "", callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            // getLogs
            it("should retrieve the logs with the block hash") {
                pocketAion.mastery?.eth.getLogs(fromBlock: nil, toBlock: nil, address: nil, topics: nil, blockhash: self.BLOCK_HASH_LOGS, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf([[String: Any]].self))
                })
            }
            // estimateGas
            it("should retrieve the estimate gas value for a transaction") {
                pocketAion.mastery?.eth.estimateGas(from: nil, to: self.ESTIMATE_GAS_TO, gas: nil, gasPrice: nil, value: nil, data: self.ESTIMATE_GAS_DATA, blockTag: nil, callback: { (error, result) in
                    expect(error).to(beNil())
                    expect(result).to(beAKindOf(BigInt.self))
                })
            }
            
            it("should fail to retrieve the estimate gas value for a transaction using empty destination address") {
                pocketAion.mastery?.eth.estimateGas(from: nil, to: "", gas: nil, gasPrice: nil, value: nil, data: self.ESTIMATE_GAS_DATA, blockTag: nil, callback: { (error, result) in
                    expect(error).toNot(beNil())
                    expect(result).to(beNil())
                })
            }
            
            
            //---
        }
        
//        describe("PocketAion NET Namespace RPC Calls") {
//            var pocketAion: PocketAion!
//            
//            beforeEach {
//                pocketAion = PocketAion(devID: DEVID, netIDs: [netID.mastery.rawValue], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
//            }
//            
//            it("should retrieve the current network id") {
//                pocketAion.network(netID.mastery.rawValue).net.version(onSuccess: {response in
//                    expect(response).notTo(beNil())
//                }, onError: { error in
//                    XCTFail()
//                })
//            }
//            
//            it("should retrieve the listening status of the node") {
//                pocketAion.network(netID.mastery.rawValue).net.listening(onSuccess: {response in
//                    expect(response).to(beTrue())
//                }, onError: { error in
//                    XCTFail()
//                })
//            }
//            
//            it("should retrieve the number of peers currently connected") {
//                pocketAion.network(netID.mastery.rawValue).net.peerCount(onSuccess: {response in
//                    expect(response).to(beGreaterThanOrEqualTo(0))
//                }, onError: { error in
//                    XCTFail()
//                })
//            }
//        }
    }

}
