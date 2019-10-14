//
//  PocketSwiftTests.swift
//  PocketSwiftTests
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//
@testable import PocketSwift
import Quick
import Nimble
import RxBlocking

class PocketCoreTests: QuickSpec {
    // Change DEVID to a registered developer ID
    let DEVID = ""
    
    override func spec() {
        describe("Pocket Core Class tests") {
            var pocketCore: Pocket!
            
            beforeEach {
                pocketCore = Pocket(devID: self.DEVID, network: "ETH", netIds: ["4", "1"], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
            }
            
            it("should instantiate a Pocket Core instance") {
                expect(pocketCore).toNot(beNil())
            }
            
            context("get"){
                it("should retrieve a list of nodes from the Node Dispatcher") {
                    pocketCore.retrieveNodes(onSuccess: { nodes in
                        expect(nodes).toEventuallyNot(beNil())
                        expect(nodes).toEventuallyNot(beEmpty())
                    }, onError: { error in
                        XCTFail()
                    })
                }

                it("should fail to retrieve a list of nodes from the Node Dispatcher") {
                    let pocket = Pocket(devID: self.DEVID, network: "ETH2", netIds: ["4", "1"], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
                    pocket.retrieveNodes(onSuccess: { nodes in
                        XCTFail()
                    }, onError: {error in
                        expect(error).to(matchError(PocketError.nodeNotFound))
                    })
                }
                
                it("should send a relay to a node in the network") {
                    let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9f"
                    let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                    let relay = Relay.init(network: "ETH", netID: "4", data: data, devID: self.DEVID, httpMethod: nil, path: nil, queryParams: nil, headers: nil)

                    expect(relay.isValid()).to(beTrue())

                    pocketCore.send(relay: relay, onSuccess: { response in
                        expect(response).notTo(beNil())
                        expect(response).notTo(beEmpty())
                    }, onError: {error in
                        XCTFail()
                    })
                }
                
                it("should fail to send a relay to a node in the network with bad relay properties \"netID\"") {
                    let pocket = Pocket(devID: self.DEVID, network: "ETH1", netIds: ["402", "110"], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
                    let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9f"
                    let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                    let relay = Relay.init(network: "ETH", netID: "10", data: data, devID: self.DEVID, httpMethod: nil, path: nil, queryParams: nil, headers: nil)

                    expect(relay.isValid()).to(beTrue())

                    pocket.send(relay: relay, onSuccess: { response in
                        XCTFail()
                    }, onError: {error in
                        expect(error).to(matchError(PocketError.nodeNotFound))
                    })
                }
                
                it("should send a relay to a node that supports REST API requests in the network") {
                    let pocket = Pocket(devID: self.DEVID, network: "TEZOS", netIds: ["MAINNET"], maxNodes: 5, requestTimeOut: 10000, schedulerProvider: .test)

                    let strArr = ["test":"enabled", "visitor":"false"]

                    let relay = Relay.init(network: "TEZOS", netID: "MAINNET", data: nil, devID: self.DEVID, httpMethod: .GET, path: "/network/version", queryParams: strArr, headers: nil)

                    expect(relay.isValid()).to(beTrue())

                    pocket.send(relay: relay, onSuccess: { response in
                        expect(response).notTo(beNil())
                        expect(response).notTo(beEmpty())
                    }, onError: {error in
                        XCTFail()
                    })
                }
                
                it("should send a relay to a node that supports REST API requests with HTTP headers") {
                    let pocket = Pocket(devID: self.DEVID, network: "TEZOS", netIds: ["MAINNET"], maxNodes: 5, requestTimeOut: 10000, schedulerProvider: .test)

                    let strArr = ["test":"enabled", "visitor":"false"]
                    let headers = ["Content-Type":"application/json"]

                    let relay = Relay.init(network: "TEZOS", netID: "MAINNET", data: nil, devID: self.DEVID, httpMethod: .GET, path: "/network/version", queryParams: strArr, headers: headers)

                    expect(relay.isValid()).to(beTrue())

                    pocket.send(relay: relay, onSuccess: { response in
                        expect(response).notTo(beNil())
                        expect(response).notTo(beEmpty())
                    }, onError: {error in
                        XCTFail()
                    })
                }
                
                it("should fail to send a relay to a node in the network with bad relay properties \"Data\"") {
                    let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9fssss"
                    let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                    let relay = Relay.init(network: "ETH", netID: "4", data: data, devID: self.DEVID, httpMethod: nil, path: nil, queryParams: nil, headers: nil)

                    expect(relay.isValid()).to(beTrue())

                    pocketCore.send(relay: relay, onSuccess: { response in
                        XCTFail()
                    }, onError: {error in
                        expect(error).notTo(beNil())
                    })
                }

                it("should send a report of a node to the Node Dispatcher") {
                    pocketCore.retrieveNodes(onSuccess: {nodes in
                        expect(nodes).toEventuallyNot(beNil())

                        let report = Report.init(ip: nodes[0].ip, message: "Test please ignore")
                        expect(report.isValid()).to(beTrue())

                        pocketCore.send(report: report, onSuccess: { response in
                            expect(response).notTo(beNil())
                            expect(response).notTo(beEmpty())
                            expect(response).toEventually(beginWith("Okay"))
                        }, onError: {error in
                            XCTFail()
                        })
                    }, onError: {error in
                        XCTFail()
                    })
                }

                it("should fail to send a report of a node to the Node Dispatcher with no Node IP") {
                    pocketCore.retrieveNodes(onSuccess: {nodes in
                        expect(nodes).toEventuallyNot(beNil())

                        let report = Report.init(ip: "", message: "Test please ignore")
                        expect(report.isValid()).to(beFalse())

                        /*pocketCore.send(report: report, onSuccess: { response in
                         expect(response).notTo(beNil())
                         expect(response).notTo(beEmpty())
                         expect(response).toEventually(beginWith("Okay"))
                         }, onError: {error in
                         fatalError()
                         })*/
                    }, onError: {error in
                        XCTFail()
                    })
                }
            }
        }
        
        // TODO: Fix KeychainWrapper issue
        // https://github.com/jrendel/SwiftKeychainWrapper/issues/78
        //        describe("Wallet Class Tests") {
        //            let passphrase = "testpassphrase"
        //
        //            func generateAndSaveWallet(address: String) -> Wallet {
        //                let wallet = Wallet.init(address: "address1", privateKey: "pk", network: "TEST", netID: "1")
        //                let isSaved = try? wallet.save(passphrase: passphrase)
        //                XCTAssertEqual(isSaved, true)
        //                return wallet
        //            }
        //
        //            it("Should persist the wallet") {
        //                _ = generateAndSaveWallet(address: "address1")
        //            }
        //
        //            it("Should retrieve a persisted wallet") {
        //                let wallet = generateAndSaveWallet(address: "address2")
        //                guard let retrievedWallet = try? Wallet.retrieveWallet(network: wallet.network, netID: wallet.netID, address: wallet.address, passphrase: passphrase) else {
        //                    XCTFail("Failed to retrieve wallet")
        //                    return
        //                }
        //                XCTAssertNotNil(retrievedWallet)
        //                XCTAssertEqual(wallet.equalsTo(wallet: retrievedWallet), true)
        //            }
        //
        //            it("Should list all the persisted wallets") {
        //                let wallet = generateAndSaveWallet(address: "address3")
        //                XCTAssertEqual(Wallet.getWalletsRecordKeys().contains(wallet.recordKey()), true)
        //            }
        //
        //            it("Should delete a persisted wallet") {
        //                let wallet = generateAndSaveWallet(address: "address4")
        //                let deleted = try? wallet.delete()
        //                XCTAssertEqual(deleted, true)
        //            }
        //        }
    }
}
