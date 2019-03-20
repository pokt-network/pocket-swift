//
//  RelayController.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class RelayController: Controller {
    private let relayRepository: RelayRepository
    internal let relayObserver: LiveData<String>

    override init(with configuration: Configuration, and schedulerProvider: SchedulerProvider) {
        self.relayRepository = RelayRepository(with: configuration, and: schedulerProvider)
        self.relayObserver = LiveData()
        
        super.init(with: configuration, and: schedulerProvider)
        self.observables.append(self.relayObserver)
    }
    
    func send(relay: Relay, to baseURL: String) {
        self.relayRepository.send(relay: relay, to: baseURL, observer: self.relayObserver)
    }
}
