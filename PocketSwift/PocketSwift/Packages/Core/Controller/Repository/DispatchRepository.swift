//
//  DispatchRepository.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RxSwift

public class DispatchRepository: Repository {
    var disposeBag: DisposeBag = DisposeBag()
    
    func retrieveServiceNodes(from dispatch: Dispatch, observer: LiveData<[[String: [String]]]>) {
        let nodeEndpoints: Endpoint<[[String: [String]]]> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: Environment().get(configuration: ServerConfiguration.DispatchPath), parameters: dispatch.toParameters())
        request(with: nodeEndpoints, andNotify: observer)
    }
}
