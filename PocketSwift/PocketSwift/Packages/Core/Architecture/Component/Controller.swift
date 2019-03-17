//
//  Controller.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class Controller {
    var observables: [Dynamic]
    var configuration: Configuration
    
    init(with configuration: Configuration) {
        self.observables = []
        self.configuration = configuration
    }
    
    func onCleared() {
        self.observables.forEach({
            $0.clean()
        })
        
        self.observables.removeAll()
    }
    
    deinit {
        onCleared()
    }
}
