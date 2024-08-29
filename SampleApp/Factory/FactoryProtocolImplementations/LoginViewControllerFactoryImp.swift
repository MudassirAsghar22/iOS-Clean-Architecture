//
//  LoginViewControllerFactoryImp.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import Foundation

extension DependencyContainer: LoginViewControllerFactory {

    func instantiateLoginViewController() -> LoginVC {
        let controller = ViewControllerUtils.getViewController(viewController: .login,
                                                                         fromStoryBoard: .userAuthentication) as? LoginVC
        controller?.viewModel = LoginViewModel(model: LoginModel(), networkService: self.loginNetworkService, delegate: controller!)
        return controller!
    }

    func instantiateForgetPasswordViewController() -> ForgetPasswordVC {
        let controller = ViewControllerUtils.getViewController(viewController: .forgetPassword,
                                                                         fromStoryBoard: .userAuthentication) as? ForgetPasswordVC
        controller?.viewModel = ForgetPasswordViewModel(networkService: self.forgetPasswordNetworkService, delegate: controller!)
        return controller!
    }
}
