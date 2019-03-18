//
//  ReportRepository.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RxSwift

public class ReportRepository: Repository {
    var disposeBag: DisposeBag = DisposeBag()
    var configuration: Configuration
    
    init(with configuration: Configuration) {
        self.configuration = configuration
    }
    
    func send(report: Report, observer: LiveData<JSON>) {
        let nodeEndpoints: Endpoint<JSON> = Endpoint(name: "SendReport", method: .post, path: ServerConfiguration.ReportPath.rawValue, parameters: report.toParameters())
        request(with: nodeEndpoints, andNotify: observer)
    }
}
