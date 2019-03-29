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
    
    public enum subnet: Int {
        case mastery = 32
        case prod = 256
    }
    
    override func spec() {
        describe("Pocket Aion Class tests") {
            
            var pocketAion: PocketAion!
            
            beforeEach {
                pocketAion = PocketAion(devID: "DEVID1", netIDs: [subnet.mastery.rawValue], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
            }
            
            it("should instantiate a Pocket Aion instance") {
                expect(pocketAion).toNot(beNil())
            }
            
            it("should create a new Wallet instance") {
                do {
                    let wallet: Wallet = try pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil)
                    expect(wallet).notTo(beNil())
                    expect(wallet.address).notTo(beNil())
                    expect(wallet.networkID).notTo(beNil())
                    expect(wallet.privateKey).notTo(beNil())
                } catch {
                    XCTFail()
                }
            }
            
            it("should import a Wallet instance") {
                do {
                    let address: String = "0xa0d72a5b09db7bd62ec9e53ba10eea7717e4a3f3618f614769dd035f11362061"
                    let privateKey: String = "0x86c646b212a03140427cd87a2c44c5803a0793dd7bf55992c3088ef8db4ccf54c9fe126cefbac96ea86da765cbf8539939f46cea1b0740d710bfce062e8624e0"
                    
                    let wallet: Wallet = try pocketAion.importWallet(address: address, privateKey: privateKey, networkID: subnet.mastery.rawValue, data: nil)
                    expect(wallet).notTo(beNil())
                    expect(wallet.address).notTo(beNil())
                    expect(wallet.networkID).notTo(beNil())
                    expect(wallet.privateKey).notTo(beNil())
                } catch {
                    XCTFail()
                }
            }
            
            it("should fail to import a Wallet due to a lack of address") {
                do {
                    let address: String? = nil
                    let privateKey: String = "0x86c646b212a03140427cd87a2c44c5803a0793dd7bf55992c3088ef8db4ccf54c9fe126cefbac96ea86da765cbf8539939f46cea1b0740d710bfce062e8624e0"
                    
                    let _: Wallet = try pocketAion.importWallet(address: address, privateKey: privateKey, networkID: subnet.mastery.rawValue, data: nil)
                    XCTFail()
                } catch {
                    expect(error).to(matchError(PocketError.walletImport(message: "Invalid public key")))
                }
            }
        }
        
        describe("PocketAion ETH Namespace RPC Calls") {
            
            var pocketAion: PocketAion!
            var ADDRESS: String!
            var STORAGE_ADDRESS: String!
            var BLOCK_HASH: String!
            var BLOCK_NUMBER: Int!
            var CODE_ADDRESS: String!
            var CALL_TO: String!
            var CALL_DATA: String!
            var TX_HASH: String!
            var BLOCK_HASH_LOGS: String!
            
            beforeEach {
                pocketAion = PocketAion(devID: "DEVID1", netIDs: [subnet.mastery.rawValue], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
                ADDRESS = "0xa0510dd236472e90f0ff4f6b7b4f70b1d8c5206cf303839f9a4e8fa6af0dd420"
                STORAGE_ADDRESS = "0xa061d41a9de8b2f317073cc331e616276c7fc37a80b0e05a7d0774c9cf956107"
                BLOCK_HASH = "0xa9316ee7207cf2ac1fd886673d5c14835a86cda97eae8f0d382b95678932c8d0"
                BLOCK_NUMBER = 1329667
                CODE_ADDRESS = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89"
                CALL_TO = "0xA0707404B9BE7a5F630fCed3763d28FA5C988964fDC25Aa621161657a7Bf4b89"
                CALL_DATA = "0xbbaa08200000000000000000000000000000014c00000000000000000000000000000154"
                TX_HASH = "0x123075c535309a3b0dbbe5c97a7a5298ec7f1bd3ae1b684ec529df3ce16cab2e"
                BLOCK_HASH_LOGS = "0xa9316ee7207cf2ac1fd886673d5c14835a86cda97eae8f0d382b95678932c8d0"
            }
            
            
            it("should retrieve an account balance") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBalance(address: ADDRESS, blockTag: .latest, onSuccess: {response in
                    expect(response).to(beGreaterThanOrEqualTo(0))
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve account balance") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBalance(address: "", blockTag: .latest, onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidAddress))
                })
            }
            
            it("should retrieve an account transaction count") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionCount(address: ADDRESS, blockTag: .latest, onSuccess: {response in
                    expect(response).to(beGreaterThanOrEqualTo(0))
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve an account transaction count") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionCount(address: "", blockTag: .latest, onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidAddress))
                })
            }
            
            it("should retrieve storage information") {
                pocketAion.network(subnet.mastery.rawValue).eth.getStorageAt(address: STORAGE_ADDRESS, position: BigInt(0), blockTag: .latest, onSuccess: {response in
                    expect(response).to(beGreaterThanOrEqualTo(0))
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve storage information") {
                pocketAion.network(subnet.mastery.rawValue).eth.getStorageAt(address: "", position: BigInt(0), blockTag: .latest, onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidAddress))
                })
            }
            
            it("should retrieve a Block transaction count using the block hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBlockTransactionCountByHash(blockHash: BLOCK_HASH, onSuccess: {response in
                    expect(response).to(beGreaterThanOrEqualTo(0))
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve a Block transaction count using the block hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBlockTransactionCountByHash(blockHash: "", onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidParameter(message: "Block hash param is missing")))
                })
            }
            
            it("should retrieve a Block transaction count using the block number") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBlockTransactionCountByNumber(blockTag: .number(BigInt(BLOCK_NUMBER)), onSuccess: {response in
                    expect(response).to(beGreaterThan(0))
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should retrieve code at the given address") {
                pocketAion.network(subnet.mastery.rawValue).eth.getCode(address: CODE_ADDRESS, blockTag: .latest, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve code at the given address") {
                pocketAion.network(subnet.mastery.rawValue).eth.getCode(address: "", blockTag: .latest, onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidAddress))
                })
            }
            
            it("should execute a new message call") {
                pocketAion.network(subnet.mastery.rawValue).eth.call(from: nil, to: CALL_TO, nrg: BigInt(50000), nrgPrice: BigInt(20000000000), value: BigInt(20000000000), data: CALL_DATA, blockTag: .latest, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to execute a new message call") {
                pocketAion.network(subnet.mastery.rawValue).eth.call(from: nil, to: "", nrg: BigInt(50000), nrgPrice: BigInt(20000000000), value: BigInt(20000000000), data: CALL_DATA, blockTag: .latest, onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidParameter(message: "Destination address (to) param is missing")))
                })
            }
            
            it("should retrieve the block information with the block hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBlockByHash(blockHash: BLOCK_HASH, fullTx: true, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve the block information with the block hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBlockByHash(blockHash: "", fullTx: true, onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidParameter(message: "Block Hash param is missing")))
                })
            }
            
            it("should retrieve the block information with the block number") {
                pocketAion.network(subnet.mastery.rawValue).eth.getBlockByNumber(blockTag: .number(BigInt(BLOCK_NUMBER)), fullTx: true, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should retrieve a transaction information with the transaction hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionByHash(txHash: TX_HASH, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve a transaction information with the transaction hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionByHash(txHash: "", onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidParameter(message: "Transaction hash param is missing")))
                })
            }
            
            it("should retrieve a transaction information with the block hash and index") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionByBlockHashAndIndex(blockHash: BLOCK_HASH, index: BigInt(0), onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve a transaction information with the block hash and index") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionByBlockHashAndIndex(blockHash: "", index: BigInt(0), onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidParameter(message: "One or more params are missing")))
                })
            }
            
            it("should retrieve a transaction information with the block number and index") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionByBlockNumberAndIndex(blockTag: .number(BigInt(BLOCK_NUMBER)), index: BigInt(0), onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should retrieve a transaction receipt using the transaction hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionReceipt(txHash: TX_HASH, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should fail to retrieve a transaction receipt using the transaction hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getTransactionReceipt(txHash: "", onSuccess: {response in
                    XCTFail()
                }, onError: { error in
                    expect(error).to(matchError(PocketError.invalidParameter(message: "Transaction hash param is missing")))
                })
            }
            
            it("should retrieve the logs with the block hash") {
                pocketAion.network(subnet.mastery.rawValue).eth.getLogs(fromBlock: .latest , toBlock: .latest, address: nil, topics: nil, blockhash: BLOCK_HASH_LOGS, onSuccess: {response in
                    expect(response).notTo(beNil())
                }, onError: { error in
                    XCTFail()
                })
            }

        }
    }

}
