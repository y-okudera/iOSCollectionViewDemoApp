//
//  PhotoSearchResponse.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

struct PhotoSearchResponse: Decodable {
    var stat = ""
    var photos: Photos?
}

struct Photos: Decodable {
    var page = 0
    var pages = 0
    var perpage = 0
    var photo = [Photo]()
}

struct Photo: Decodable {
    var farm = 0
    var server = ""
    var id = ""
    var secret = ""
}
