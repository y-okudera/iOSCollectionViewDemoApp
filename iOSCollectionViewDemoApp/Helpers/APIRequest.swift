//
//  APIRequest.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire

// MARK: - Protocol
protocol APIRequest {
    
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var httpHeaderFields: [String: String] { get }
    
    func decode(data: Data) -> Response?
    
    /// URLRequestを生成する
    func makeURLRequest(needURLEncoding: Bool) -> URLRequest?
}

// MARK: - Default implementation
extension APIRequest {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.flickr.com/services/rest") else {
            fatalError("baseURL is nil.")
        }
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var httpHeaderFields: [String: String] {
        return [:]
    }
    
    func decode(data: Data) -> Response? {
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            print("❌Response decode error:\(error)")
            return nil
        }
    }
    
    func makeURLRequest(needURLEncoding: Bool = false) -> URLRequest? {
        
        let endPoint = baseURL.absoluteString + path
        
        // String to URL
        guard let url = URL(string: endPoint) else {
            assertionFailure("Endpoint is invalid. endPoint:\(endPoint)")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        urlRequest.timeoutInterval = 30
        
        if !needURLEncoding {
            return urlRequest
        }
        
        // パラメータをエンコードする
        do {
            urlRequest = try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            return urlRequest
        } catch {
            assertionFailure("An error occurred in encoding. URLRequest:\(urlRequest)")
            return nil
        }
    }
}
