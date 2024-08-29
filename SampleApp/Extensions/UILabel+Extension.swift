//
//  UILabel+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 27/05/2024.
//

import UIKit

extension UILabel {

    func addTrailing(image: UIImage, text:String) {
        let attachment = FlexibleTextAttachment(image: image, font: UIFont.systemFont(ofSize: 10), resize: .none, align: .centerByUppercase)

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: "  " + text, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
        self.baselineAdjustment = .alignCenters
    }

    func addLeading(image: UIImage, text:String) {

        let attachment = FlexibleTextAttachment(image: image, font: UIFont.systemFont(ofSize: 10), resize: .none, align: .centerByUppercase)

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)

        let string = NSMutableAttributedString(string:  "  " + text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
        self.baselineAdjustment = .alignBaselines
    }
}
