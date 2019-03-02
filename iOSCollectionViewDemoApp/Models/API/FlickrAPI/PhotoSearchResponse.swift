//
//  PhotoSearchResponse.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

struct PhotoSearchResponse: Decodable {
    var photos: Photos?
    var stat = ""
}

struct Photos: Decodable {
    var page = 0
    var pages = 0
    var perpage = 0
    var photo = [Photo]()
}

struct Photo: Decodable {
    var farm = 0
    
    // swiftlint:disable:next identifier_name
    var id = ""
    
    var secret = ""
    var server = ""
    
    func imageURL() -> String {
        return "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
    }
}
