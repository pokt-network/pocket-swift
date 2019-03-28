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
            
            it("should create ,sign and send a Transaction") {
                do{
                    let receiverAccount = try pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil)
                    let account = try pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil)
                    let txParams: [AnyHashable: Any] = ["nonce": "1", "to": receiverAccount.address , "data": "", "value": "0x989680", "nrgPrice": "0x989680", "nrg": "0x989680"]
                    
                    let signedTx = try pocketAion.createTransaction(wallet: account, params: txParams)
                    
                    expect(signedTx).notTo(beNil())
                    expect(signedTx.serializedTransaction).notTo(beNil())
                    
                    pocketAion.network(subnet.mastery.rawValue).eth.send(transaction: signedTx, onSuccess: { response in
                        print(response)
                    }, onError: { error in
                        XCTFail()
                    })
                    
                } catch {
                  XCTFail()
                }
            }
            
            it("should fail to create a Transaction instance due to the nonce parameter is nil") {
                do{
                    let receiverAccount = try pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil)
                    let account = try pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil)
                    let txParams: [AnyHashable: Any] = ["to": receiverAccount.address , "data": "", "value": "0x989680", "nrgPrice": "0x989680", "nrg": "0x989680"]
                    
                    let _ = try pocketAion.createTransaction(wallet: account, params: txParams)
                    XCTFail()
                    
                } catch let error{
                    expect(error).to(matchError(PocketError.transactionCreation(message: "Failed to retrieve the nonce")))
                }
            }
            
            it("should get the balance") {
                guard let account = try? pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil) else {
                    XCTFail()
                    return
                }
                
                pocketAion.network(subnet.mastery.rawValue).eth.getBalance(address: account.address, blockTag: .latest, onSuccess: {response in
                    expect(response).to(beGreaterThanOrEqualTo(0))
                }, onError: { error in
                    XCTFail()
                })
            }
            
            it("should get storage") {
                guard let account = try? pocketAion.createWallet(networkID: subnet.mastery.rawValue, data: nil) else {
                    XCTFail()
                    return
                }
                
                pocketAion.network(subnet.mastery.rawValue).eth.getStorageAt(address: account.address, position: 0, blockTag: .latest, onSuccess: {response in
                    print(response)
                }, onError: {error in
                    print(error)
                    XCTFail()
                })
            }
        }
    }

}