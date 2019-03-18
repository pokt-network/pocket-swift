//
//  Report.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

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
