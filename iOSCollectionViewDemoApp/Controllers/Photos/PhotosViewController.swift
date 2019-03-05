//
//  PhotosViewController.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/28.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

/// 写真一覧画面
final class PhotosViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var photoSearchRequest: PhotoSearchRequest?
    var photos = [Photo]()
    var photosPrefetcher: PhotosPrefetcher?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Setup
extension PhotosViewController {
    
    /// 初期処理
    private func setup() {
        
        setupAPI()
        setupLayout()
    }
    
    /// API関連の初期処理
    private func setupAPI() {
        
        #warning("サンプルコードのため、APIリクエストページと検索ワードは静的な値をセット")
        photoSearchRequest = PhotoSearchRequest(page: 1, tags: "dog")
        photoSearchRequest?.delegate = self
        
        startAnimating()
        photoSearchRequest?.load()
    }
    
    /// UI関連の初期処理
    private func setupLayout() {
        
        // Self-Sizingの有効化
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = UIScreen.main.bounds.width * 0.4
            flowLayout.estimatedItemSize = .init(width: width, height: width)
        }
        
        collectionView.prefetchDataSource = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension PhotosViewController: UICollectionViewDataSourcePrefetching {
    
    /// 事前読み込み
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        let imageUrlStrings = indexPaths.map { photos[$0.row].imageURL() }
        photosPrefetcher = PhotosPrefetcher(urlStrings: imageUrlStrings)
        photosPrefetcher?.startPrefetching()
    }
    
    /// 事前読み込みをキャンセルする
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        photosPrefetcher?.stopPrefetching()
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        let imageURL = photos[indexPath.row].imageURL()
        cell.photoImageView.setImageByNuke(urlString: imageURL)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedPhoto = photos[indexPath.row]
        print("selectedPhoto", selectedPhoto)
    }
}

// MARK: - 写真検索APIのレスポンス
extension PhotosViewController: PhotoSearchProtocol {
    
    func succeeded(response: PhotoSearchResponse) {
        
        self.photos = response.photos?.photo ?? []
        stopAnimating()
        collectionView.reloadData()
    }
    
    func failed(text: String) {
        
        stopAnimating()
        showErrorAlert(text: text)
    }
    
    /// エラーダイアログを表示する
    private func showErrorAlert(text: String) {
        
        let alert = UIAlertController(title: "エラー", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
