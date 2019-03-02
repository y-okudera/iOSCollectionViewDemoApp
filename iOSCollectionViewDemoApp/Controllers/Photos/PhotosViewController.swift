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
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

// MARK: - Setup
extension PhotosViewController {
    
    /// 初期処理
    private func setup() {
        
        setupAPI()
        setupLayout()
    }
    
    /// UI関連の初期処理
    private func setupLayout() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    /// API関連の初期処理
    private func setupAPI() {
        
        #warning("サンプルコードのため、APIリクエストページと検索ワードは静的な値をセット")
        photoSearchRequest = PhotoSearchRequest(page: 1, tags: "dog")
        photoSearchRequest?.delegate = self
        
        startAnimating()
        photoSearchRequest?.load()
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
