//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/6/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

enum ServerConfiguration: String {
    case ServerURL = "dispatch.staging.pokt.network"
    case ConnectionProtocol = "http"
    case DispatchPath = "/v1/dispatch"
    case ReportPath = "/v1/report"
    case RelayPath = "/v1/relay"
}

struct Environment {
    func get(configuration: ServerConfiguration) -> String {
        if configuration == ServerConfiguration.ServerURL {
            return ServerConfiguration.ConnectionProtocol.rawValue.appending("://").appending(configuration.rawValue)

        }
        return configuration.rawValue
    }
}
