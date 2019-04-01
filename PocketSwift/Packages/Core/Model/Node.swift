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
    public let netID: String
    public let ip: String
    public let port: Int
    public var ipPort: String
    
    private let nonSSLProtocol = "http://"
    private let SSLProtocol = "https://"
    private let SSLDefaultPort = 443
    
    init(network: String, netID: String, ip: String, port: Int, ipPort: String) {
        self.netID = netID
        self.network = network
        self.ip = ip
        self.port = port
        self.ipPort = ipPort
        
        if !self.ipPort.contains(nonSSLProtocol) || !self.ipPort.contains(SSLProtocol) {
            if self.port == SSLDefaultPort {
                self.ipPort = "\(SSLProtocol)\(ipPort)"
            } else {
                self.ipPort = "\(nonSSLProtocol)\(ipPort)"
            }
        }
    }
    
    init(network: String, netID: String, ipPort: String) {
        // Assign
        self.netID = netID
        self.network = network
        self.ipPort = ipPort

        // Parse ipPort
        var ipPortData = ipPort.components(separatedBy: ":")
        self.ip = ipPortData[0]
        self.port = Int(ipPortData[1]) ?? 0

        if !self.ipPort.contains(nonSSLProtocol) || !self.ipPort.contains(SSLProtocol) {
            if self.port == SSLDefaultPort {
                self.ipPort = "\(SSLProtocol)\(ipPort)"
            } else {
                self.ipPort = "\(nonSSLProtocol)\(ipPort)"
            }
        }
    }
    
    func isEqual(netID: String, network: String) -> Bool {
        if self.netID.elementsEqual(netID) && self.network.elementsEqual(network) {
            return true
        }
        return false
    }
}
