//
//  EthRPC.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

protocol EthRPC {
    var pocket: PocketCore {get set}
    func send(transaction: Transaction, onSuccess: @escaping (String) -> (), onError: @escaping (Error) -> ())
}
