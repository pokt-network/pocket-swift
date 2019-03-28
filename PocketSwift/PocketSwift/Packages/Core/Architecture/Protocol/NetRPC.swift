//
//  NetRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

protocol NetRPC: RPC {
    func version(onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
    func listening(onSuccess: @escaping (Bool) -> (), onError: @escaping (Error) -> ())
    func peerCount(onSuccess: @escaping (BigInt) -> (), onError: @escaping (Error) -> ())
}
