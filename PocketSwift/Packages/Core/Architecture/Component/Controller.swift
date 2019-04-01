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
    var schedulerProvider: SchedulerProvider
    
    init(with configuration: Configuration, and schedulerProvider: SchedulerProvider) {
        self.observables = []
        self.configuration = configuration
        self.schedulerProvider = schedulerProvider
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
