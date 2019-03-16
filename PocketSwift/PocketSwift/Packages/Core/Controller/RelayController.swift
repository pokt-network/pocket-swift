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
    
    override init() {
        self.relayRepository = RelayRepository()
        self.relayObserver = LiveData()
        
        super.init()
        self.observables.append(self.relayObserver)
    }
    
    func send(relay: Relay) {
        self.relayRepository.send(relay: relay, observer: self.relayObserver)
    }
}
