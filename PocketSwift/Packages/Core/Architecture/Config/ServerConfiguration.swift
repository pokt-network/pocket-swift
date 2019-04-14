//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/6/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

enum ServerConfiguration: String {
    case ServerURL = "dispatch.pokt.network"
    case ConnectionProtocol = "https"
    case DispatchPath = "/v1/dispatch"
    case ReportPath = "/v1/report"
    case RelayPath = "/v1/relay"
    
    func value() -> String {
        return self.rawValue
    }
}

struct Environment {
    func get(configuration: ServerConfiguration) -> String {
        if configuration == ServerConfiguration.ServerURL {
            return ServerConfiguration.ConnectionProtocol.value().appending("://").appending(configuration.value())

        }
        return configuration.value()
    }
}
