//
//  RelayRepository.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RxSwift

public class RelayRepository: Repository {
    var disposeBag: DisposeBag = DisposeBag()
    var configuration: Configuration
    
    init(with configuration: Configuration) {
        self.configuration = configuration
    }
    
    func send(relay: Relay, to baseURL: String, observer: LiveData<String>) {
        let relayEndpoint: Endpoint<String> = Endpoint(baseURL: baseURL, name: "Relay", method: .post, path: ServerConfiguration.RelayPath.rawValue, parameters: relay.toParameters())
        request(with: relayEndpoint, andNotify: observer)
    }
}
