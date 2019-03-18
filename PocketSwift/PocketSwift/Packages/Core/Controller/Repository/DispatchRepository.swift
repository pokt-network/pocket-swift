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
    var configuration: Configuration
    
    init(with configuration: Configuration) {
        self.configuration = configuration
    }
    
    func retrieveServiceNodes(from dispatch: Dispatch, observer: LiveData<JSON>) {
        let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "RetrieveServiceNodes", method: .post, path: ServerConfiguration.DispatchPath.rawValue, parameters: dispatch.toParameters())
        request(with: nodeEndpoints, andNotify: observer)
    }
}
