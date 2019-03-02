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
    
    func setImageByNuke(urlString: String, placeholder: UIImage? = nil, failureImage: UIImage? = nil) {
        
        if urlString.isEmpty {
            print("画像のURLが空文字")
            self.image = nil
            return
        }
        
        guard let imageRequest = makeImageRequest(urlString: urlString) else {
            print("ImageRequestがnil")
            self.image = nil
            return
        }
        
        // ロード中に表示する画像とリクエスト失敗時に表示する画像を設定
        let options = ImageLoadingOptions(placeholder: placeholder, failureImage: failureImage)
        
        Nuke.loadImage(with: imageRequest, options: options, into: self) { [weak self] imageResponse, error in
            if let error = error {
                print("load image error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self?.image = imageResponse?.image
            }
        }
    }
    
    /// イメージリクエストを生成する
    ///
    /// - parameter urlString: 画像のURL
    /// - parameter useCache: キャッシュを使用するかどうか (デフォルト: 使用する)
    private func makeImageRequest(urlString: String, useCache: Bool = true) -> ImageRequest? {
        
        print("画像のURL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("画像のURLがnil")
            return nil
        }
        var imageRequest = ImageRequest(url: url)
        
        // キャッシュポリシーを設定
        imageRequest.memoryCacheOptions.isReadAllowed = useCache
        
        // リクエストプライオリティを設定
        imageRequest.priority = .high
        
        return imageRequest
    }
}
