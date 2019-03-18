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
    
    private var observers: [String: Observer<ObservedType>]
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
        self.observers = [:]
    }
    
    func observe(in owner: NSObject, with observer: @escaping Observer<ObservedType>, error: ((Error?) -> ())? = nil) {
        self.observers[owner.description] = observer
        if let _errorCallback = error {
            self.errorCallback = _errorCallback
        }
    }
    
    private func notify(_ value: ObservedType){
        self.observers.forEach({ $0.value(value)})
    }
    
    override func clean(){
        self.observers.removeAll()
    }
    
    deinit {
        self.clean()
    }
}
