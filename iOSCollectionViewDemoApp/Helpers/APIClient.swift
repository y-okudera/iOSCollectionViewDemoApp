//
//  APIClient.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation

enum APIError: Error {
    /// 接続エラー(オフライン or タイムアウト)
    case connectionError
    
    /// レスポンスのデコード失敗
    case decodeError
    
    /// 無効なリクエスト
    case invalidRequest
    
    /// 無効なレスポンス
    case invalidResponse
    
    /// その他
    case others(error: Error, statusCode: Int?)
}

enum APIResult {
    /// 成功
    case success(object: Decodable)
    
    /// 失敗
    case failure(apiError: APIError)
}

final class APIClient: NSObject {
    
    /// 端末の通信状態を取得
    ///
    /// - Returns: true: オンライン, false: オフライン
    static func isOnline() -> Bool {
        if let reachabilityManager = NetworkReachabilityManager() {
            reachabilityManager.startListening()
            return reachabilityManager.isReachable
        }
        return false
    }
    
    /// API Request
    static func request<T: APIRequest>(request: T, completionHandler: @escaping (APIResult) -> Void) {
        
        // 端末の通信状態をチェック
        if !isOnline() {
            completionHandler(.failure(apiError: .connectionError))
            return
        }
        
        guard let urlRequest = request.makeURLRequest(needURLEncoding: true) else {
            completionHandler(.failure(apiError: .invalidRequest))
            return
        }
        
        Alamofire.request(urlRequest).validate(statusCode: 200 ..< 300).responseData { dataResponse in
            
            // エラーチェック
            if let error = dataResponse.result.error {
                let apiError = errorToAPIError(error: error, statusCode: dataResponse.response?.statusCode)
                completionHandler(.failure(apiError: apiError))
                return
            }
            
            // レスポンスデータのnilチェック
            guard let responseData = dataResponse.result.value else {
                completionHandler(.failure(apiError: .invalidResponse))
                return
            }
            
            let result = self.decode(responseData: responseData, request: request)
            completionHandler(result)
        }
    }
    
    /// multipart/form-data
    static func multipart<T: MultipartRequest>(request: T, completionHandler: @escaping (APIResult) -> Void) {
        
        // 端末の通信状態をチェック
        if !isOnline() {
            completionHandler(.failure(apiError: .connectionError))
            return
        }
        
        guard let urlRequest = request.makeURLRequest() else {
            completionHandler(.failure(apiError: .invalidRequest))
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            let requestContents = request.makeMultipartRequestContents()
            requestContents.forEach {
                multipartFormData.append($0.data, withName: $0.name, mimeType: $0.mimeType)
            }
            dump(multipartFormData)
            
        }, with: urlRequest, encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(request: let uploadRequest, streamingFromDisk: _, streamFileURL: _):
                
                uploadRequest.validate(statusCode: 200 ..< 300).responseData { dataResponse in
                    
                    // エラーチェック
                    if let error = dataResponse.result.error {
                        let apiError = errorToAPIError(error: error, statusCode: dataResponse.response?.statusCode)
                        completionHandler(.failure(apiError: apiError))
                        return
                    }
                    
                    // レスポンスデータのnilチェック
                    guard let responseData = dataResponse.result.value else {
                        completionHandler(.failure(apiError: .invalidResponse))
                        return
                    }
                    
                    let result = self.decode(responseData: responseData, request: request)
                    completionHandler(result)
                }
                
            case .failure(let error):
                assertionFailure(error.localizedDescription)
                return
            }
        })
    }
}

extension APIClient {
    
    /// ErrorをAPIErrorに変換する
    private static func errorToAPIError(error: Error, statusCode: Int?) -> APIError {
        print("❌HTTP status code:\(String(describing: statusCode))")
        if let error = error as? URLError {
            if error.code == .timedOut {
                print("❌Timeout.")
                return .connectionError
            }
            if error.code == .notConnectedToInternet {
                print("❌Not connected to internet.")
                return .connectionError
            }
        }
        print("❌dataResponse.result.error:\(error)")
        return .others(error: error, statusCode: statusCode)
    }
    
    /// デコード
    private static func decode<T: APIRequest>(responseData: Data, request: T) -> APIResult {
        if let object = request.decode(data: responseData) {
            print("👍response:")
            dump(object)
            return .success(object: object)
            
            // デコード失敗
        } else {
            print("❌Decoding failed.")
            return .failure(apiError: .decodeError)
        }
    }
}
