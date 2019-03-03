//
//  UIImageView+Nuke.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/03/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Nuke
import UIKit

extension UIImageView {
    
    /// 非同期で画像を取得する
    ///
    /// - parameter urlString: 画像のURL
    /// - parameter placeholder: 画像ロード中に表示する画像
    /// - parameter failureImage: 画像ロード失敗時に表示する画像
    func setImageByNuke(urlString: String, placeholder: UIImage? = nil, failureImage: UIImage? = nil) {
        
        if urlString.isEmpty {
            print("画像のURLが空文字")
            self.image = nil
            return
        }
        
        guard let imageRequest = ImageRequest.makeHighPriorityImageRequest(urlString: urlString) else {
            print("ImageRequestがnil")
            self.image = nil
            return
        }
        
        // ロード中に表示する画像とリクエスト失敗時に表示する画像を設定
        let options = ImageLoadingOptions(placeholder: placeholder, failureImage: failureImage)
        Nuke.loadImage(with: imageRequest, options: options, into: self)
    }
}

extension Nuke.ImageRequest {
    
    /// イメージリクエストを生成する
    ///
    /// - parameter urlString: 画像のURL
    static func makeHighPriorityImageRequest(urlString: String) -> ImageRequest? {
        
        guard let url = URL(string: urlString) else {
            print("画像のURLがnil")
            return nil
        }
        var imageRequest = ImageRequest(url: url)
        
        // リクエストプライオリティを設定
        imageRequest.priority = .high
        
        return imageRequest
    }
}
