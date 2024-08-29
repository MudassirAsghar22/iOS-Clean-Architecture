//
//  VerifyResetPasswordOtpViewControllerFactoryImp.swift
//  Sample App
//
//  Created by Mudassir Asghar on 17/05/2024.
//

import Foundation

extension DependencyContainer: VerifyResetPasswordOtpViewControllerFactory {
    func instantiateResetPasswordViewController(email: String) -> ResetPasswordVC {
        let controller = ViewControllerUtils.getViewController(viewController: .resetPassword,
                                                               fromStoryBoard: .userAuthentication) as? ResetPasswordVC
        controller?.viewModel = ResetPasswordViewModel(networkService: self.resetPasswordNetworkService, delegate:
                                                        controller!, model: ForgetPasswordModel(email: email))

        return controller!
    }
}
