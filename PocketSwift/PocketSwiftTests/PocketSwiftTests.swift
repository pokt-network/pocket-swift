//
//  PocketSwiftTests.swift
//  PocketSwiftTests
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import PocketSwift

class PocketSwiftTests: QuickSpec {

    override func spec() {
        describe("Pocket Class tests") {
            var pocketCore: PocketCore!
            
            beforeEach {
                pocketCore = PocketCore(devID: "DEVID1", networkName: "ETH", netID: 4, version: "0")
            }
            
            it("should instantiate a Pocket instance") {
                expect(pocketCore).toNot(beNil())
            }
            
            it("should retrieve a list of nodes from the Node Dispatcher") {
                var nodes: [Node] 
            }
            
        }
    }

}
