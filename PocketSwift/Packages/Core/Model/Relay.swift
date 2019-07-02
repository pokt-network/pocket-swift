//
//  Relay.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

/**
 A Model Class that represents a Relay.
 
 - Parameters:
 - data : The json string with the information needed for create the Relay.
 - devId: The id used to interact with Pocket Api.
 - network: The blockchain network name, ie: ETH, AION.
 - netID: The netid of the Blockchain.
 - httpMethod: HTTP Method for rest api requests, GET, POST, DELETE, etc.
 - path: URL path for the rest api request.
 - queryParams: 
 */
public class Relay: Model, Input {
    let network: String
    let netID: String
    let data: String
    let devID: String
    let httpMethod: String;
    let path: String;
    
    public enum HttpMethod: String {
        case POST = "POST"
        case GET = "GET"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    public init(network: String, netID: String, data: String?, devID: String, httpMethod: HttpMethod?, path: String?, queryParams: [String: String]?) {
        self.network = network
        self.netID = netID
        self.data = data ?? ""
        self.devID = devID
        self.httpMethod = httpMethod?.rawValue ?? ""
        self.path = Relay.appendQueryParams(path: path ?? "", queryParams: queryParams ?? [String: String]())
    }
    
    /**
      Checks if this Relay has been configured correctly.
    */
    func isValid() -> Bool {
        do {
            return try Utils.areDirty(self.network, self.devID)
        } catch {
            fatalError("There was a problem validating your relay")
        }
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("Blockchain", self.network, "NetID", "\(self.netID)", "Data", self.data, "DevID", self.devID, "METHOD", self.httpMethod, "PATH", self.path)
        return data
    }
    
    private class func appendQueryParams(path: String, queryParams: [String: String]) -> String {
        var paramsStr = "";
        
        if queryParams.count > 0 {
            for param in queryParams {
                paramsStr += param.key + "=" + param.value + "&"
            }
            return path + "?" + paramsStr
        }else{
            return path
        }
    }
}
