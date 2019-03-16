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
    
    func send(relay: Relay, observer: LiveData<Relay>) {
        let relayEndpoint: Endpoint<Relay> = Endpoint(name: "Relay", method: .post, path: Environment().get(configuration: ServerConfiguration.RelayPath), parameters: relay.toParameters())
        request(with: relayEndpoint, andNotify: observer)
    }
}
