//
//  PocketSwiftTests.swift
//  PocketSwiftTests
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Quick
import Nimble
import RxBlocking


@testable import PocketSwift

class PocketSwiftTests: QuickSpec {

    override func spec() {
        describe("Pocket Class tests") {
            var pocketCore: PocketCore!
            var pocketCoreFail: PocketCore!
            
            beforeEach {
                pocketCore = PocketCore(devID: "DEVID1", networkName: "ETH", netIDs: [4, 1], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
                pocketCoreFail = PocketCore(devID: "DEVID1", networkName: "ETH2", netIDs: [4, 1], maxNodes: 5, requestTimeOut: 1000, schedulerProvider: .test)
            }
            
            it("should instantiate a Pocket instance") {
                expect(pocketCore).toNot(beNil())
            }
            
            context("get"){
                it("should retrieve a list of nodes from the Node Dispatcher") {
                    
                    pocketCore.retrieveNodes(onSuccess: { nodes in
                        expect(nodes).toEventuallyNot(beNil())
                        expect(nodes).toEventuallyNot(beEmpty())
                    }, onError: { error in
                        fatalError()
                    })
                }
                
                it("should fail to retrieve a list of nodes from the Node Dispatcher") {
                    pocketCoreFail.retrieveNodes(onSuccess: { nodes in
                        fatalError()
                    }, onError: {error in
                        expect(error).to(matchError(PocketError.nodeNotFound))
                    })
                }
                
                it("should send a relay to a node in the network") {
                    let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9f"
                    let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                    let relay = pocketCore.createRelay(blockchain: "ETH", netID: 4, data: data, devID: "DEVID1")
                        
                    expect(relay.isValid()).to(beTrue())
                        
                    pocketCore.send(relay: relay, onSuccess: { response in
                        expect(response).notTo(beNil())
                        expect(response).notTo(beEmpty())
                    }, onError: {error in
                        fatalError()
                    })
                }
                
                it("should fail to send a relay to a node in the network with bad relay properties \"netID\"") {
                    let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9f"
                    let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                    let relay = pocketCore.createRelay(blockchain: "ETH", netID: 10, data: data, devID: "DEVID1")
                        
                    expect(relay.isValid()).to(beTrue())
                        
                    pocketCore.send(relay: relay, onSuccess: { response in
                        fatalError()
                    }, onError: {error in
                        expect(error).to(matchError(PocketError.nodeNotFound))
                    })
                }
                
                it("should fail to send a relay to a node in the network with bad relay properties \"Data\"") {
                    let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9fssss"
                    let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                    let relay = pocketCore.createRelay(blockchain: "ETH", netID: 4, data: data, devID: "DEVID1")
                        
                    expect(relay.isValid()).to(beTrue())
                        
                    pocketCore.send(relay: relay, onSuccess: { response in
                        fatalError()
                    }, onError: {error in
                        expect(error).to(matchError(PocketError.custom(message: "invalid argument 0: hex string has length 44, want 40 for common.Address")))
                    })
                }
                
                it("should send a report of a node to the Node Dispatcher") {
                    pocketCore.retrieveNodes(onSuccess: {nodes in
                        expect(nodes).toEventuallyNot(beNil())
                        
                        let report = pocketCore.createReport(ip: nodes[0].ip, message: "test please ignore")
                        expect(report.isValid()).to(beTrue())
                        
                        pocketCore.send(report: report, onSuccess: { response in
                            expect(response).notTo(beNil())
                            expect(response).notTo(beEmpty())
                            expect(response).toEventually(beginWith("Okay"))
                        }, onError: {error in
                            fatalError()
                        })
                    }, onError: {error in
                        fatalError()
                    })
                }
                
                it("should fail to send a report of a node to the Node Dispatcher with no Node IP") {
                    pocketCore.retrieveNodes(onSuccess: {nodes in
                        expect(nodes).toEventuallyNot(beNil())
                        
                        let report = pocketCore.createReport(ip: "", message: "test please ignore")
                        expect(report.isValid()).to(beFalse())
                        
                        /*pocketCore.send(report: report, onSuccess: { response in
                            expect(response).notTo(beNil())
                            expect(response).notTo(beEmpty())
                            expect(response).toEventually(beginWith("Okay"))
                        }, onError: {error in
                            fatalError()
                        })*/
                    }, onError: {error in
                        fatalError()
                    })
                }
            }
        }
    }
}
