//
//  Endpoint.swift
//  PocketSwift
//
//  Created by Wilson Garcia on 2/5/19.
//  Copyright © 2019 Wilson Garcia. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]
typealias Path = String

enum Method: String {
    case get, post, put, patch, delete
}

final class Endpoint<Response> {
    let method: Method
    let path: Path
    let parameters: Parameters
    let name: String
    let decode: (Data, Int) throws -> Response
    let baseURL: String
    
    init(baseURL: String = Environment().get(configuration: ServerConfiguration.ServerURL), name: String = "", method: Method = .get, path: Path, parameters: Parameters = [:], decode: @escaping (Data, Int) throws -> Response) {
        self.name = name
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = decode
        self.baseURL = baseURL
    }
    
    private func get(httpMethod: Method) -> String {
        return httpMethod.rawValue
    }
    
    func getURL() -> URL {
        return URL(string: "\(baseURL)\(path)")!
    }
    
    func request(with baseURL: URL) -> URLRequest {
        let URL = baseURL.appendingPathComponent(path)
        guard let components = NSURLComponents(url: URL, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        
        self.parameters.forEach{parameter in
            components.queryItems?.append(URLQueryItem(name: parameter.key, value: parameter.value as? String))
        }
        
        guard let finalURL = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = get(httpMethod: method)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if request.httpMethod == "POST" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
}

extension Endpoint where Response: Swift.Decodable {
    convenience init(baseURL: String = Environment().get(configuration: ServerConfiguration.ServerURL), name: String = "", method: Method = .get, path: Path, parameters: Parameters = [:]) {
        self.init(baseURL: baseURL, name: name, method: method, path: path, parameters: parameters) { data, _ in
            return try JSONDecoder().decode(Response.self, from: data)
        }
    }
}

/*extension Endpoint where Response: Model {
    convenience init(name: String = "", method: Method = .get, path: Path, parameters: Parameters = [:]) {
        self.init(name: name, method: method, path: path, parameters: parameters) { data, code in
            var model: Model = try JSONDecoder().decode(Response.self, from: data)
            model.code = code
            return model as! Response
        }
    }
}*/

extension Endpoint where Response == Void {
    convenience init(baseURL: String = Environment().get(configuration: ServerConfiguration.ServerURL), name: String = "", method: Method = .get, path: Path, parameters: Parameters = [:]) {
        self.init(baseURL: baseURL, name: name, method: method, path: path, parameters: parameters, decode: { _, _ in ()})
    }
}
