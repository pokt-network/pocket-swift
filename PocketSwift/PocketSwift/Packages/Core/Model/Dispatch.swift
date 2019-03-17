//
//  Dispatch.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

struct Dispatch: Input {
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    private func getBlockchains() -> Array<Parameters> {
        var blockchains: Array<Parameters> = []
        self.configuration.blockchains.forEach{ item in
            blockchains.append(item.toParameters())
        }
        return blockchains
    }
    
    func toParameters() -> Parameters {
        var parameter: Parameters = [:]
        parameter.fill("DevID", self.configuration.devID, "Blockchains", self.getBlockchains())
        return parameter
    }
}
