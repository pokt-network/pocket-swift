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
    var schedulerProvider: SchedulerProvider
    
    init(with configuration: Configuration, and schedulerProvider: SchedulerProvider) {
        self.configuration = configuration
        self.schedulerProvider = schedulerProvider
    }
    
    func send(report: Report, observer: LiveData<String>) {
        let reportEndpoints: Endpoint<String> = Endpoint(name: "SendReport", method: .post, path: ServerConfiguration.ReportPath.value(), parameters: report.toParameters())
        request(with: reportEndpoints, andNotify: observer)
    }
}
