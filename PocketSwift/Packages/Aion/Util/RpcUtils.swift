//
//  RpcUtils.swift
//  PocketSwift
//
//  Created by Pabel Nunez Landestoy on 4/2/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import BigInt

public class RpcParamsUtil {
    
    public static func formatRpcParams(params: [Any]) -> [String]?{
        var results = [Any]()
        var resultStrArray = [String]()
        
        for objParam in params {
            var currStr: String?
            
            if let objParamArray = objParam as? [Any] {
                let objStrings = self.objectsAsRpcParams(objParams: objParamArray)
                let result = objStrings.joined(separator: ",")
                
                currStr = "[\(result)]"
            } else{
                currStr = self.objectAsRpcParam(objParam: objParam)
            }
            results.append(currStr ?? "")
        }
        
        for item in results {
            resultStrArray.append(item as? String ?? "")
        }
        
        return resultStrArray
    }
    
    private static func objectsAsRpcParams(objParams: [Any]) ->[String]{
        var result = [String]()
        
        for objParam in objParams {
            if let objParamStr = objectAsRpcParam(objParam: objParam) {
                result.append(objParamStr)
            }
        }
        return result
    }
    
    private static func objectAsRpcParam(objParam: Any) -> String? {
        if  objParam is Double ||
            objParam is Float ||
            objParam is Int ||
            objParam is Int64 ||// long
            objParam is UInt8 ||// byte
            objParam is Int16// short
        {
            let strValue = String(describing: objParam)
            
            return strValue
        } else if objParam is Bool {
            guard let boolValue = objParam as? Bool else {
                return nil
            }
            return boolValue.description.lowercased()
        } else if objParam is String {
            return "\"\(objParam)\""
        } else if objParam is BigUInt {
            return "bigInt(" + "\"" + (objParam as! BigUInt).toHexString() + "\"" + ",16).value"
        }
        return nil
    }
}
