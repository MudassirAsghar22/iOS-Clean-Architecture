//
//  UITextField+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 21/05/2024.
//

import UIKit

extension UITextField {

    func addRightView(named: String, marginX: CGFloat = -5) {
        let rightView = UIView()
        rightView.backgroundColor = UIColor.clear
        let checkmarkImageView = UIImageView(image: UIImage(named: named))
        checkmarkImageView.frame = checkmarkImageView.frame.offsetBy(dx: marginX, dy: 0)
        rightView.frame = checkmarkImageView.frame
        rightView.addSubview(checkmarkImageView)
        self.rightView = rightView
        self.rightViewMode = .always
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.becomeFirstResponder))
        rightView.addGestureRecognizer(tap)

    }

    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    func addZeroInStartAndDecimal() {
        // Get the current text
        var currentText = self.text ?? ""

        // If the text is empty, set it to "0.00"
        if currentText.isEmpty {
            self.text = "01.00"
            return
        }

        if let _ = currentText.range(of: "^[1-9]$", options: .regularExpression) {
            currentText = "0" + currentText
        }

        // Add zero at the start if the text starts with a decimal
        if currentText.hasPrefix(".") {
            currentText = "0" + currentText
        }

        // Add ".00" if the text is a whole number
        if let _ = currentText.range(of: "^\\d{1,2}$", options: .regularExpression) {
            currentText += ".00"
        }
        // Add "00" if the text ends with a decimal
        if let _ = currentText.range(of: "^\\d{1,2}\\.$", options: .regularExpression) {
            currentText += "00"
        }
        // Add "0" if the text ends with one decimal digit
        if let _ = currentText.range(of: "^\\d{1,2}\\.\\d$", options: .regularExpression) {
            currentText += "0"
        }

        // Add "0" in start if contains single digit before decimal
        if currentText.split(separator: ".").first?.count ?? 0 == 1 {
            currentText = "0" + currentText
        }

        self.text = currentText
    }
}
