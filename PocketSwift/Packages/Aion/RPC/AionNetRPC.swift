////
////  AionNetRPC.swift
////  PocketSwift
////
////  Created by Wilson Garcia on 3/25/19.
////  Copyright © 2019 Wilson Garcia. All rights reserved.
////
//
//import Foundation
//import BigInt
//
//public struct AionNetRPC: NetRPC {
//    
//    public var pocket: Pocket
//    public var netID: String
//    public var network: String
//    
//    private let pocketAion: PocketAion
//
//    init(pocketAion: PocketAion, netID: String) {
//        self.pocket = pocketAion
//        self.network = pocketAion.NETWORK
//        self.netID = netID
//        self.pocketAion = pocketAion
//    }
//    
//    public func version(onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ()) {
//        do {
//            guard let relay = try createNetRelay(netMethod: NetRPCMethod.version) else {
//                onError(PocketError.invalidRelay)
//                return
//            }
//            
//            self.pocket.send(relay: relay, onSuccess: { response in
//                guard let result = try? self.getString(dic: response.toDict()) else {
//                    onError(PocketError.custom(message: "Error parsing version response"))
//                    return
//                }
//                onSuccess(result)
//                
//            }, onError: {error in
//                onError(error)
//            })
//        }catch let error {
//            onError(error)
//        }
//    }
//    
//    public func listening(onSuccess: @escaping (Bool) -> (), onError: @escaping (Error) -> ()) {
//        do {
//            guard let relay = try createNetRelay(netMethod: NetRPCMethod.listening) else {
//                onError(PocketError.invalidRelay)
//                return
//            }
//            
//            self.pocket.send(relay: relay, onSuccess: { response in
//                guard let result = try? self.getBool(dic: response.toDict()) else {
//                    onError(PocketError.custom(message: "Error parsing listening response"))
//                    return
//                }
//                onSuccess(result)
//                
//            }, onError: {error in
//                onError(error)
//            })
//        }catch let error {
//            onError(error)
//        }
//    }
//    
//    public func peerCount(onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ()) {
//        do {
//            guard let relay = try createNetRelay(netMethod: NetRPCMethod.peerCount) else {
//                onError(PocketError.invalidRelay)
//                return
//            }
//            
//            self.pocket.send(relay: relay, onSuccess: { response in
//                guard let result = try? self.getBigInt(dic: response.toDict()) else {
//                    onError(PocketError.custom(message: "Error parsing peerCount response"))
//                    return
//                }
//                onSuccess(result)
//                
//            }, onError: {error in
//                onError(error)
//            })
//        }catch let error {
//            onError(error)
//        }
//    }
//}
