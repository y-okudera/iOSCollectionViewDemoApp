//
//  PhotosPrefetcher.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/03/03.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Nuke
import UIKit

final class PhotosPrefetcher {
    
    let preheater = ImagePreheater()
    var urlStrings: [String]
    var imageRequests = [ImageRequest]()
    
    init(urlStrings: [String]) {
        self.urlStrings = urlStrings
    }
    
    /// Prefetchを開始
    func startPrefetching() {
        
        imageRequests = []
        for urlString in urlStrings {
            if let request = UIImageView.makeImageRequest(urlString: urlString) {
                imageRequests.append(request)
            }
        }
        preheater.startPreheating(with: imageRequests)
    }
    
    /// Prefetchをキャンセル
    func stopPrefetching() {
        preheater.stopPreheating(with: imageRequests)
    }
    
    deinit {
        stopPrefetching()
    }
}
