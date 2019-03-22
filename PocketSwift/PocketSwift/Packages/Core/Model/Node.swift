//
//  Node.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct Node: Model {
    public let network: String
    public let netID: Int
    public let ip: String
    public let port: Int
    public var ipPort: String
    
    private let nonSSLProtocol = "http://"
    private let SSLProtocol = "https://"
    
    init(network: String, netID: Int, ip: String, port: Int, ipPort: String) {
        self.netID = netID
        self.network = network
        self.ip = ip
        self.port = port
        self.ipPort = ipPort
        
        if !self.ipPort.contains(nonSSLProtocol) || !self.ipPort.contains(SSLProtocol) {
            self.ipPort = "\(nonSSLProtocol)\(ipPort)"
        }
    }
    
    init(network: String, netID: Int, ipPort: String) {
        self.netID = netID
        self.network = network
        self.ipPort = ipPort
        
        var ipPortData = ipPort.components(separatedBy: ":")
        self.ip = ipPortData[0]
        self.port = Int(ipPortData[1]) ?? 0
        
        if !self.ipPort.contains(nonSSLProtocol) || !self.ipPort.contains(SSLProtocol) {
            self.ipPort = "\(nonSSLProtocol)\(ipPort)"
        }
        
        
    }
    
    func isEqual(netID: Int, network: String) -> Bool {
        if self.netID == netID && self.network == network {
            return true
        }
        return false
    }
}
