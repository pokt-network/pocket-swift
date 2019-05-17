//
//  Report.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation


/**
 A Model Class that represents a Report.
 
 Used to report a fallen node.
 - Parameters:
 - ip : The ip of the Node that is currently unavailable.
 - message: The message to report this node.

 */
public struct Report: Model, Input {
    let ip: String
    let message: String
    
    init(ip: String, message: String) {
        self.ip = ip
        self.message = message
    }
    
    func toParameters() -> Parameters {
        var data: Parameters = [:]
        data.fill("IP", self.ip, "Message", self.message)
        return data
    }
    
    func isValid() -> Bool {
        do {
            return try Utils.areDirty(self.ip, self.message)
        } catch {
            fatalError("There was a problem validating your report")
        }
    }
}
