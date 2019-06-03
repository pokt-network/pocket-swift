//
//  Eth.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class PocketEth: Pocket {
    
    public static let NETWORK = "ETH"
    public enum Networks {
        case Mainnet
        case Ropsten
        case Rinkeby
        case Goerli
        case Kovan
        
        public var netID: String {
            get {
                switch self {
                    case .Mainnet : return "1"
                    case .Ropsten : return "3"
                    case .Rinkeby : return "4"
                    case .Goerli : return "5"
                    case .Kovan : return "42"
                }
            }
        }
    }
    
    // Attributes
    public var defaultNetwork: EthNetwork?
    public var mainnet: EthNetwork?
    public var ropsten: EthNetwork?
    public var rinkeby: EthNetwork?
    public var goerli: EthNetwork?
    public var kovan: EthNetwork?
    public var networks: [String: EthNetwork] = [String: EthNetwork]()
    
    /**
     Create new instance of Pocket.
     - Parameters:
        - devID : Developer Identifier
        - defaultNetID: Network name.
        - netIds: Arrays of Network ID
        - maxNodes: Maximum amount of nodes
        - requestTimeOut: Amount of time in miliseconds that the server is going to wait before returning a TimeOutException
     
     ### Usage Example: ###
     ````
        Pocket(devID: "DEVID1", network: "ETH", netID: "4", maxNodes: 5, requestTimeOut: 1000)
     ````
     */
    public init(devID: String, netIds: [String], defaultNetID: String? = PocketEth.Networks.Rinkeby.netID, maxNodes: Int? = 5, requestTimeOut: Int? = 10000) throws {
        super.init(devID: devID, network: PocketEth.NETWORK, netIds: netIds, maxNodes: maxNodes!, requestTimeOut: requestTimeOut!, schedulerProvider: .main)
        if (netIds.isEmpty) {
            throw PocketError.custom(message: "netIds cannot be empty")
        }
        var defaultNetwork: EthNetwork?
        netIds.forEach { (netID) in
            let network = self.network(netID: netID)
            if (netID.elementsEqual(defaultNetID!)) {
                defaultNetwork = network
            }
        }
        self.defaultNetwork = defaultNetwork
    }

    /**
        Checks the network identifier list and returns the subnetwork.
            - Parameters:
                - netId: Network Identifier

        ### Usage Example: ###
        ````
            network(netID: "4") // returns rinkeby
        ````
     */
    public func network(netID: String) -> EthNetwork {
        let result: EthNetwork
        if let networkValue = self.networks[netID] {
            result = networkValue
        } else {
            result = EthNetwork.init(netID: netID, pocketEth: self)
            self.networks[netID] = result
            self.addBlockchain(network: PocketEth.NETWORK, netID: netID)
        }
        
        if (netID.elementsEqual(PocketEth.Networks.Mainnet.netID)) {
            self.mainnet = result
        } else if (netID.elementsEqual(PocketEth.Networks.Ropsten.netID)) {
            self.ropsten = result
        } else if (netID.elementsEqual(PocketEth.Networks.Rinkeby.netID)) {
            self.rinkeby = result
        } else if (netID.elementsEqual(PocketEth.Networks.Goerli.netID)) {
            self.goerli = result
        } else if (netID.elementsEqual(PocketEth.Networks.Kovan.netID)) {
            self.kovan = result
        }
        
        return result
    }
}
