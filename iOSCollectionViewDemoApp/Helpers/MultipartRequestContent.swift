//
//  MultipartRequestContent.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

/// multipart/form-dataで送信するパラメータの構造体
struct MultipartRequestContent {
    
    var data = Data()
    var name = ""
    var mimeType = ""
    
    init(data: Data, name: String, mimeType: String) {
        self.data = data
        self.name = name
        self.mimeType = mimeType
    }
}
