//
//  LiveData.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

import Foundation

class LiveData<ObservedType>: Dynamic {
    
    //private var observers: [String: Observer<ObservedType>]
    //private var observers: [Observer<ObservedType>]
    private var observer: Observer<ObservedType>?
    var value: ObservedType? {
        didSet {
            if let _value = value {
                self.notify(_value)
            }
        }
    }
    var error: Error? {
        didSet {
            if let _errorCallback = errorCallback {
                _errorCallback(error ?? nil)
            }
        }
    }
    
    init(_ value: ObservedType? = nil) {
        self.value = value
    }
    
    func observe(in owner: NSObject, for initCallback: ()->(), with observer: @escaping Observer<ObservedType>, error: ((Error?) -> ())? = nil) {
        self.observer = observer
        if let _errorCallback = error {
            self.errorCallback = _errorCallback
        }
        initCallback()
    }
    
    private func notify(_ value: ObservedType){
        if let observer = self.observer {
            observer(value)
        }
    }
    
    override func clean(){
        self.observer = nil
    }
    
    deinit {
        self.clean()
    }
}
