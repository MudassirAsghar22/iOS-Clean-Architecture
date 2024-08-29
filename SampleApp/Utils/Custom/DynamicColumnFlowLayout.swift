//
//  DynamicColumnFlowLayout.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/06/2024.
//

import UIKit

class DynamicColumnFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let minimumItemWidth: CGFloat = 100 // Minimum width for each item
        let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
        let maxNumberOfItems = Int(availableWidth / minimumItemWidth)
        let itemsPerRow = max(2, maxNumberOfItems) // Ensure at least 2 items per row

        let totalSpacing = (minimumInteritemSpacing * CGFloat(itemsPerRow - 1)) + sectionInset.left + sectionInset.right
        let itemWidth = (collectionView.bounds.width - totalSpacing) / CGFloat(itemsPerRow)

        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
}
