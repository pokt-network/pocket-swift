//
//  DispatchController.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/16/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public class DispatchController: Controller {
    private let dispatchRepository: DispatchRepository
    internal let dispatchObserver: LiveData<String>
    
    override init() {
        self.dispatchRepository = DispatchRepository()
        self.dispatchObserver = LiveData()
        
        super.init()
        self.observables.append(self.dispatchObserver)
    }
    
    func retrieveServiceNodes(from dispatch: Dispatch) {
        self.dispatchRepository.retrieveServiceNodes(from: dispatch, observer: self.dispatchObserver)
    }
}
