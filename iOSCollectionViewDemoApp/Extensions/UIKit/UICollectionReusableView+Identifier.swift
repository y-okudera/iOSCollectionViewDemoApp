//
//  UICollectionReusableView+Identifier.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/03/02.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    
    /// クラス名を取得する
    static var identifier: String {
        return String(describing: self)
    }
}
