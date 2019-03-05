# iOSCollectionViewDemoApp
CollectionViewのPrefetchのサンプル

## UICollectionViewDataSourcePrefetching

UICollectionViewDataSourcePrefetchingに準拠し、以下のメソッドを実装する。

|メソッド|処理内容|
|:--:|:--:|
|func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])|事前読み込みをする|
|func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath])|事前読み込みを<br>キャンセルする|

```
final class PhotosViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var photos = [Photo]()
    var photosPrefetcher: PhotosPrefetcher?
    
    // 省略
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
```

### 非同期で画像を取得するライブラリNukeのPrefetch
ImagePreheaterを使用する。

```
import Nuke

final class PhotosPrefetcher {
    
    private let preheater = ImagePreheater()
    private var urlStrings: [String]
    private var imageRequests = [ImageRequest]()
    
    init(urlStrings: [String]) {
        self.urlStrings = urlStrings
    }
    
    /// Prefetchを開始
    func startPrefetching() {
        
        imageRequests = []
        for urlString in urlStrings {
            if let request = ImageRequest.makeHighPriorityImageRequest(urlString: urlString) {
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
```
