//
//  ReportController.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class ReportController: Controller {
    private let reportRepository: ReportRepository
    internal let reportObserver: LiveData<String>
    
    override init(with configuration: Configuration) {
        self.reportRepository = ReportRepository(with: configuration)
        self.reportObserver = LiveData()
        
        super.init(with: configuration)
        self.observables.append(self.reportObserver)
    }
    
    func send(report: Report) {
        self.reportRepository.send(report: report, observer: self.reportObserver)
    }
}
