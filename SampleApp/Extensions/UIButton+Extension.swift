//
//  UIButton+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/05/2024.
//

import UIKit

extension UIButton {
    func applyCornerRadius() {
        self.layer.cornerRadius = 12
    }

    func disable() {
        self.alpha = 0.5
        self.isEnabled = false
    }

    func enable() {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
        self.isEnabled = true

    }
}
