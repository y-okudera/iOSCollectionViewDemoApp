//
//  MultipartRequest.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import UIKit

// MARK: - Protocol
protocol MultipartRequest: APIRequest {
    /// MIMEタイプがtext/plainのリクエストパラメータ
    var textParameters: [String: String] { get }
    /// MIMEタイプがimage/pngのリクエストパラメータ
    var pngParameters: [String: UIImage] { get }
    /// MIMEタイプがimage/jpegのリクエストパラメータ
    var jpegParameters: [String: UIImage] { get }
    
    func makeMultipartRequestContents() -> [MultipartRequestContent]
}

// MARK: - Default implementation
extension MultipartRequest {
    var textParameters: [String: String] {
        return [:]
    }
    
    var pngParameters: [String: UIImage] {
        return [:]
    }
    
    var jpegParameters: [String: UIImage] {
        return [:]
    }
    
    func makeMultipartRequestContents() -> [MultipartRequestContent] {
        
        var dataArray = [MultipartRequestContent]()
        for textParam in textParameters {
            if let data = textParam.value.data(using: .utf8) {
                dataArray.append(.init(data: data, name: textParam.key, mimeType: "text/plain"))
            }
        }
        for pngParam in pngParameters {
            if let data = pngParam.value.pngData() {
                dataArray.append(.init(data: data, name: pngParam.key, mimeType: "image/png"))
            }
        }
        
        for jpegParam in jpegParameters {
            if let data = jpegParam.value.jpegData(compressionQuality: 1.0) {
                dataArray.append(.init(data: data, name: jpegParam.key, mimeType: "image/jpeg"))
            }
        }
        return dataArray
    }
}
