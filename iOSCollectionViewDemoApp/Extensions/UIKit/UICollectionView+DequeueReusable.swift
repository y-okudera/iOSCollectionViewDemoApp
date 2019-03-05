//
//  UICollectionView+DequeueReusable.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/03/02.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// セルのインスタンスを取得する
    ///
    /// 自作のセルクラスの型を指定してインスタンスを生成する
    ///
    /// ```
    /// let cell: CustomCell = collectionView.dequeueReusableCell(for: indexPath)
    /// ```
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            assertionFailure("Failed to dequeue Reusable Cell.")
            return T()
        }
        return cell
    }
}
