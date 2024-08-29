//
//  ViewControllerFactory.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import UIKit

// MARK: - Login
protocol LoginViewControllerFactory {
    func instantiateLoginViewController() -> LoginVC
    func instantiateForgetPasswordViewController() -> ForgetPasswordVC
}

// MARK: -  ForgetPasswordViewControllerFactory
protocol ForgetPasswordViewControllerFactory {
    func instantiateVerifyResetPasswordOtpViewController(email: String) -> VerifyResetPasswordOtpVC
}

// MARK: -  VerifyResetPasswordOtpViewControllerFactory
protocol VerifyResetPasswordOtpViewControllerFactory {
    func instantiateResetPasswordViewController(email: String) -> ResetPasswordVC
}
