//
//  UICollectionView+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 24/05/2024.
//

import UIKit

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "System-Bold", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }

    // MARK: - UICollectionView scrolling/datasource

       /// Last Section of the CollectionView
       var lastSection: Int {
           return numberOfSections - 1
       }

       /// IndexPath of the last item in last section.
       var lastIndexPath: IndexPath? {
           guard lastSection >= 0 else {
               return nil
           }

           let lastItem = numberOfItems(inSection: lastSection) - 1
           guard lastItem >= 0 else {
               return nil
           }

           return IndexPath(item: lastItem, section: lastSection)
       }

       /// Islands: Scroll to bottom of the CollectionView
       /// by scrolling to the last item in CollectionView
       func scrollToBottom(animated: Bool) {
           guard let lastIndexPath = lastIndexPath else {
               return
           }
           scrollToItem(at: lastIndexPath, at: .bottom, animated: animated)
       }
}
