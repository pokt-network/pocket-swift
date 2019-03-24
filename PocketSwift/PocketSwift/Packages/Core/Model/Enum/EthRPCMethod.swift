//
//  EthRPCMethod.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/24/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public enum EthRPCMethod: String {
    case getBalance = "eth_getBalance"
    case sendTransaction = "eth_sendTransaction"
}
