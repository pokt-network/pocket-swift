//
//  String+Extensions.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 3/18/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

extension String {
    
    func toDict() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toHex() -> Int64? {
        if self.hasZeroHexPrefix() {
            let newVal = self.dropFirst(2)
            return Int64(newVal, radix: 16)
        }
        
        return Int64(self, radix: 16)
    }
    
    private func hasZeroHexPrefix() -> Bool{
        if self.hasPrefix("0x") {
            return true
        }
        return false
    }
}
