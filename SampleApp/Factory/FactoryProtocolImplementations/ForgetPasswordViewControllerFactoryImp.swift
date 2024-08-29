//
//  ForgetPasswordViewControllerFactoryImp.swift
//  Sample App
//
//  Created by Mudassir Asghar on 17/05/2024.
//

import Foundation

extension DependencyContainer: ForgetPasswordViewControllerFactory {
    func instantiateVerifyResetPasswordOtpViewController(email: String) -> VerifyResetPasswordOtpVC {
        let controller = ViewControllerUtils.getViewController(viewController: .verifyResetPasswordOtp,
                                                               fromStoryBoard: .userAuthentication) as? VerifyResetPasswordOtpVC
        controller?.viewModel = VerifyResetPasswordOtpViewModel(model: VerifyResetPasswordPostModel(email: email, otp: ""), networkService: self.verifyResetPasswordNetworkService, delegate: controller!)
        return controller!
    }
}
