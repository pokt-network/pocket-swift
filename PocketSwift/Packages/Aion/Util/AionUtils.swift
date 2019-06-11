//
//  AionUtils.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/22/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

class AionUtils {
    private init(){}
    
    /**
        Helps format the relay data by retrieving the resource file(s) by passing in the name and the extention. 

            - Parameters:
                - name: file name 
                - ext: file extention   
                
        Returns:
            A string representing the file.  
    */
    class func getFileForResource(name: String, ext: String) throws -> String {
        guard let aionBundleURL = Bundle.init(for: PocketAion.self).url(forResource: "resource", withExtension: "bundle") else {
            throw PocketError.custom(message: "Failed to retrieve aion bundle URL")
        }
        
        guard let aionBundle = Bundle.init(url: aionBundleURL) else {
            throw PocketError.custom(message: "Failed to retrieve aion bundle.")
        }
        
        let filePath = aionBundle.path(forResource: name, ofType: ext)
        let fileString = try String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
        
        return fileString
    }
}
