//
//  Node.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

/**
 A Model Class that represents a Node.
 
 - Parameters:
 - ipPort : Ip url for this Node.
 - network: The blockchain network name, ie: ETH, AION.
 - netID: The netid of the Blockchain.
 
 */

public struct Node: Model {
    public let network: String
    public let netID: String
    public let ip: String
    public let port: Int
    public var ipPort: String
    
    private let nonSSLProtocol = "http://"
    private let SSLProtocol = "https://"
    private let SSLDefaultPort = 443
    
    public init(network: String, netID: String, ip: String, port: Int, ipPort: String) {
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
    
    public init(network: String, netID: String, ipPort: String) {
        // Assign
        self.netID = netID
        self.network = network
        self.ipPort = ipPort

        // Parse ipPort
        let ipPortData = ipPort.components(separatedBy: ":")
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
    
    
    /**
     Compares if 2 nodes are equals
     
     - Parameters:
     - network: The blockchain network name, ie: ETH, AION.
     - netID: The netid of the Blockchain.
     
     */
    func isEqual(netID: String, network: String) -> Bool {
        if self.netID.elementsEqual(netID) && self.network.elementsEqual(network) {
            return true
        }
        return false
    }
}
