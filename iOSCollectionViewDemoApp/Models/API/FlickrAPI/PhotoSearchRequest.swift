//
//  PhotoSearchRequest.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

protocol PhotoSearchProtocol: class {
    /// 写真検索APIリクエスト成功
    func succeeded(response: PhotoSearchResponse)
    
    /// 写真検索APIリクエスト失敗
    func failed(text: String)
}

final class PhotoSearchRequest: APIRequest {

    /// レスポンスのDecodableの型をResponseエイリアスに設定
    typealias Response = PhotoSearchResponse
    
    /// 1リクエストのデータ件数
    static let perPage = 500
    
    weak var delegate: PhotoSearchProtocol?
    
    /// 何ページ目のリクエストをするか
    var page: Int
    
    /// 検索ワード
    var tags: String
    
    // MARK: - イニシャライザ
    
    init(page: Int, tags: String) {
        self.page = page
        self.tags = tags
    }
    
    var parameters: [String: Any] {
        return [
            "method": "flickr.photos.search",
            "api_key": "92f3fd8101d1d3a3613339d37c0452b9",
            "nojsoncallback": "1",
            "format": "json",
            "page": page,
            "per_page": PhotoSearchRequest.perPage,
            "tags": tags
        ]
    }
}

extension PhotoSearchRequest {
    
    /// 写真検索
    func load() {
        
        guard APIClient.isOnline() else {
            delegate?.failed(text: "オフラインです。")
            return
        }
        
        APIClient.request(request: self) { [weak self] result in
            switch result {
            case .success(object: let response):
                if let photoSearchResponse = response as? PhotoSearchResponse {
                    self?.delegate?.succeeded(response: photoSearchResponse)
                }
            case .failure(apiError: _):
                self?.delegate?.failed(text: "写真検索に失敗しました。")
            }
        }
    }
}
