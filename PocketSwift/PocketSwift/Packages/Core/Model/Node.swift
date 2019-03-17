//
//  Node.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Node: Model {
    let network: String
    let netID: Int
    let version: String
    let ip: String
    let port: Int
    var ipPort: String
    
    private let nonSSLProtocol = "http://"
    private let SSLProtocol = "https://"
    
    init(network: String, netID: Int, version: String, ip: String, port: Int, ipPort: String) {
        self.netID = netID
        self.network = network
        self.version = version
        self.ip = ip
        self.port = port
        self.ipPort = ipPort
        
        if !self.ipPort.contains(nonSSLProtocol) || !self.ipPort.contains(SSLProtocol) {
            self.ipPort = "\(nonSSLProtocol)\(ipPort)"
        }
    }
    
    func isEqual(netID: Int, network: String, version: String) -> Bool {
        if self.netID == netID && self.network == network && self.version == version {
            return true
        }
        return false
    }
}
