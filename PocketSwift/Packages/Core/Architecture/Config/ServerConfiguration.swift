//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/6/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

enum ServerConfiguration: Int {
    case ServerURL = 0
    case ConnectionProtocol = 1
    case DispatchPath = 2
    case ReportPath = 3
    case RelayPath = 4
    
    func value() -> String {
        switch self.rawValue {
        case 0:
            #if RELEASE
            return "dispatch.pokt.network"
            #else
            return "dispatch.staging.pokt.network"
            #endif
        case 1:
            #if RELEASE
            return "https"
            #else
            return "https"
            #endif
        case 2:
            #if RELEASE
            return "/v1/dispatch"
            #else
            return "/v1/dispatch"
            #endif
        case 3:
            #if RELEASE
            return "/v1/report"
            #else
            return "/v1/report"
            #endif
        case 4:
            #if RELEASE
            return "/v1/relay"
            #else
            return "/v1/relay"
            #endif
        default:
            return "Unknown error occured."
        }
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
