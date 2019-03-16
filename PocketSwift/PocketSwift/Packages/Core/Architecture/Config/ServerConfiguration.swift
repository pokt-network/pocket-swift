//
//  Configuration.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/6/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

enum ServerConfiguration: String {
    case ServerURL = "Server URL"
    case ConnectionProtocol = "Protocol"
    case DispatchPath = "Dispatch Path"
    case ReportPath = "Report Path"
    case RelayPath = "Relay Path"
}

struct Environment {
    fileprivate var infoDict: [String: Any] {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Property List not found")
            }
        }
    }
    
    func get(configuration: ServerConfiguration) -> String {
        if configuration == ServerConfiguration.ServerURL {
            return (infoDict[ServerConfiguration.ConnectionProtocol.rawValue] as! String)
                .appending("://").appending(infoDict[configuration.rawValue] as! String)
        }
        return infoDict[configuration.rawValue] as! String
    }
}
