//
//  PhotoCollectionViewCell.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/28.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    // swiftlint:disable:next private_outlet
    @IBOutlet weak var photoImageView: UIImageView!
    
    private var isHeightCalculated: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // セルの再利用時に画像をnilクリアする
        photoImageView.image = nil
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
}
