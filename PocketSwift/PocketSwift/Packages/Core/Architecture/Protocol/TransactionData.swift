//
//  TransactionData.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/23/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public protocol TransactionData {
    func getStringFormatted(signTx: String, privateKey: String) -> String
}

