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
    internal let relayObserver: LiveData<Relay>

    override init(with configuration: Configuration) {
        self.relayRepository = RelayRepository(with: configuration)
        self.relayObserver = LiveData()
        
        super.init(with: configuration)
        self.observables.append(self.relayObserver)
    }
    
    func send(relay: Relay, to baseURL: String) {
        self.relayRepository.send(relay: relay, to: baseURL, observer: self.relayObserver)
    }
}
