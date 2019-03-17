//
//  WebServiceImpl.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation
import RxSwift

final class WebServiceImpl: WebService {
    
    func load<Response>(endpoint: Endpoint<Response>) -> Observable<Response> {
        let baseURL = URL(string: endpoint.baseURL)!
    
        return Observable<Response>.create { observer in
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: endpoint.request(with: baseURL)) { (data: Data?, response: URLResponse?, error: Error?) in
                do {
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(try endpoint.decode(data ?? Data(), self.getCode(response: response, data: data)))
                    observer.onCompleted()
                } catch let error {
                    observer.onError(error)
                }
            }
            
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func getCode(response: URLResponse?, data: Data?) -> Int {
        if let httpResponse = response as? HTTPURLResponse {
            if let json = data, json.count != 0 {
                print("Response: \(String(decoding: json, as: UTF8.self))")
            }
            
            return httpResponse.statusCode
        }
        return 500
    }
    
    
}
