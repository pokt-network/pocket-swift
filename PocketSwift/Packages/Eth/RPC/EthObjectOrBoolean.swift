//
//  ObjectOrBoolean.swift
//  PocketSwift
//
//  Created by Luis De Leon on 4/1/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

public struct EthObjectOrBoolean {
    
    public var booleanValue: Bool?
    public var objectValue: [String: Any]?

    /**
        If the data is an object, return the object value
    */    
    public var isObject: Bool {
        get {
            return objectValue != nil
        }
    }
    
    /**
        If the data is a Boolean, return the Boolean value(True or False)
    */    
    public var isBoolean: Bool {
        get {
            return booleanValue != nil
        }
    }

    /**
        Checks the recieved data to see if it's an object or Boolean and then returns the value. 
    */    
    init(objectOrBoolean: Any) throws {
        if let objectParam = objectOrBoolean as? [String: Any] {
            self.objectValue = objectParam
        } else if let booleanParam = objectOrBoolean as? Bool {
            self.booleanValue = booleanParam
        } else {
            throw PocketError.custom(message: "Param is neither Object or Boolean \(objectOrBoolean)")
        }
    }
    
}
