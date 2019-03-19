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
                pocketCore = PocketCore(devID: "DEVID1", networkName: "ETH", netID: 4, version: "0")
                pocketCoreFail = PocketCore(devID: "DEVID1", networkName: "ETH2", netID: 4, version: "0")
            }
            
            it("should instantiate a Pocket instance") {
                expect(pocketCore).toNot(beNil())
            }
            
            context("get"){
                it("should retrieve a list of nodes from the Node Dispatcher") {
                    let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: pocketCore.getDispatch().toParameters())
                    
                    do{
                        let webservice: WebServiceImpl = WebServiceImpl()
                        let response: JSON? = try webservice.load(endpoint: nodeEndpoints).toBlocking().first()
                        
                        expect(response).toEventuallyNot(beNil())
                        expect(response?.value()).toEventuallyNot(beNil())
                        
                        
                    } catch {
                        fatalError()
                    }
                }
                
                it("should fail to retrieve a list of nodes from the Node Dispatcher") {
                    let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: pocketCoreFail.getDispatch().toParameters())
                    
                    do{
                        let webservice: WebServiceImpl = WebServiceImpl()
                        let response: JSON? = try webservice.load(endpoint: nodeEndpoints).toBlocking().first()
                        
                        let responseObject: [String: JSON] = response?.value() as! [String : JSON]
                        let key = responseObject.keys.first!
                        let value: Array<String> = responseObject[key]!.value() as! Array<String>
                        
                        expect(value).toEventually(beEmpty())
                        
                        
                    } catch {
                        fatalError()
                    }
                }
                
                it("should send a relay to a node in the network") {
                    let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: pocketCore.getDispatch().toParameters())
                    
                    do{
                        let webservice: WebServiceImpl = WebServiceImpl()
                        let response: JSON? = try webservice.load(endpoint: nodeEndpoints).toBlocking().first()
                        let nodes: [Node] = pocketCore.getDispatch().parseDispatchResponse(response: response!)
                        
                        expect(nodes).toEventuallyNot(beNil())
                        
                        let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9f"
                        let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                        let relay = pocketCore.createRelay(blockchain: "ETH", netID: 4, version: "0", data: data, devID: "DEVID1")
                        
                        expect(relay.isValid()).to(beTrue())
                        
                        let relayEndpoint: Endpoint<String> = Endpoint(baseURL: nodes[0].ipPort, name: "Relay", method: .post, path: ServerConfiguration.RelayPath.rawValue, parameters: relay.toParameters())
                        let relayResponse: String? = try webservice.load(endpoint: relayEndpoint).toBlocking().first()
                        let relayResponseObject = relayResponse!.toDict()?.hasError()
                        
                        expect(relayResponseObject?.0).to(beFalse())
                        
                    } catch {
                        fatalError()
                    }
                }
                
                it("should fail to send a relay to a node in the network with bad relay properties \"netID\"") {
                    let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: pocketCore.getDispatch().toParameters())
                    
                    do{
                        let webservice: WebServiceImpl = WebServiceImpl()
                        let response: JSON? = try webservice.load(endpoint: nodeEndpoints).toBlocking().first()
                        let nodes: [Node] = pocketCore.getDispatch().parseDispatchResponse(response: response!)
                        
                        expect(nodes).toEventuallyNot(beNil())
                        
                        let address: String = "0xf892400Dc3C5a5eeBc96070ccd575D6A720F0F9f"
                        let data: String = "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"\(address)\",\"latest\"],\"id\":67}"
                        let relay = pocketCore.createRelay(blockchain: "ETH", netID: 10, version: "0", data: data, devID: "DEVID1")
                        
                        expect(relay.isValid()).to(beTrue())
                        
                        let relayEndpoint: Endpoint<JSON> = Endpoint(baseURL: nodes[0].ipPort, name: "Relay", method: .post, path: ServerConfiguration.RelayPath.rawValue, parameters: relay.toParameters())
                        let relayResponse: JSON? = try webservice.load(endpoint: relayEndpoint).toBlocking().first()
                        
                        expect(relayResponse?.hasError().0).toEventually(beTrue())
                    } catch {
                        fatalError()
                    }
                }
                
                it("should send a report of a node to the Node Dispatcher") {
                    let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: pocketCore.getDispatch().toParameters())
                    
                    do{
                        let webservice: WebServiceImpl = WebServiceImpl()
                        let response: JSON? = try webservice.load(endpoint: nodeEndpoints).toBlocking().first()
                        let nodes: [Node] = pocketCore.getDispatch().parseDispatchResponse(response: response!)
                        
                        expect(nodes).toEventuallyNot(beNil())
                        
                        let report = pocketCore.createReport(ip: nodes[0].ip, message: "test please ignore")
                        
                        expect(report.isValid()).to(beTrue())
                        
                        let reportEndpoints: Endpoint<String> = Endpoint(name: "SendReport", method: .post, path: ServerConfiguration.ReportPath.rawValue, parameters: report.toParameters())
                        let reportResponse: String? = try webservice.load(endpoint: reportEndpoints).toBlocking().first()
                        
                        expect(reportResponse).toEventually(beginWith("Okay"))
                    } catch {
                        fatalError()
                    }
                }
                
                it("should fail to send a report of a node to the Node Dispatcher with no Node IP") {
                    let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: pocketCore.getDispatch().toParameters())
                    
                    do{
                        let webservice: WebServiceImpl = WebServiceImpl()
                        let response: JSON? = try webservice.load(endpoint: nodeEndpoints).toBlocking().first()
                        let nodes: [Node] = pocketCore.getDispatch().parseDispatchResponse(response: response!)
                        
                        expect(nodes).toEventuallyNot(beNil())
                        
                        let report = pocketCore.createReport(ip: "", message: "test please ignore")
                        
                        expect(report.isValid()).to(beFalse())
                        
                        /*let reportEndpoints: Endpoint<String> = Endpoint(name: "SendReport", method: .post, path: ServerConfiguration.ReportPath.rawValue, parameters: report.toParameters())
                        let reportResponse: String? = try webservice.load(endpoint: reportEndpoints).toBlocking().first()
                        
                        expect(reportResponse).toEventually(beginWith("Okay"))*/
                    } catch {
                        fatalError()
                    }
                }
            }
            
        }
    }

}
