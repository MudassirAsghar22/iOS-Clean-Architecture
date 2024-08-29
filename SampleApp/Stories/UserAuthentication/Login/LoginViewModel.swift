//
//  LoginViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 13/05/2024.
//

import Foundation
import Alamofire
import NotificationBannerSwift
import SwiftKeychainWrapper

protocol LoginViewModelObserver: BaseViewModelDelegatesProtocol {
    func moveToHome()
}

protocol LoginViewModelInput {
    func attemptTologin(parameters: LoginPostParams)
}

class LoginViewModel: LoginViewModelInput {
    
    // MARK: - Vars
    var model: LoginModel = LoginModel()
    weak private var delegate: LoginViewModelObserver?
    private var networkService: LoginNetworkServicesProtocol?

    // MARK: - Inititalizer
    init(model: LoginModel, networkService: LoginNetworkServicesProtocol, delegate: LoginViewModelObserver) {
        self.model = model
        self.networkService = networkService
        self.delegate = delegate
    }

// MARK: - Public functions

    func saveCredentials(email: String, pwd: String) {
        KeychainWrapper.standard.set(email, forKey: Constants.KeychainWrapperKeys.k_email, withAccessibility: .whenUnlocked)
        KeychainWrapper.standard.set(pwd, forKey: Constants.KeychainWrapperKeys.k_password, withAccessibility: .whenUnlocked)
    }

    func attemptTologin(parameters: LoginPostParams) {
        if InternetConnectivity.isConnectedToInternet {
            self.delegate?.showLoader()
            self.networkService?.userSignInService(params: parameters.dictionary()!, handler: { response, message in

                self.delegate?.hideLoader()

                if let response = response {
                    if response.status ?? false {
                        guard let userProfile = response.userProfile, let accessToken = response.accessToken else {
                            self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: message?.body ?? "Something_went_wrong".localized, apiType: .login, statusCode: .other))
                            return
                        }

                        DataCacheManager.shared.setCurrUser(usr: userProfile)
                        UserDefaultsManager.shared.saveUserDataToPreferences()
                        DataCacheManager.shared.saveTokenToKeyChain(token: accessToken)
                        if self.model.isRememberMeEnabled {
                            self.saveCredentials(email: parameters.username!, pwd: parameters.password!)
                        } else {
                            self.saveCredentials(email: "", pwd: "")
                        }
                        self.delegate?.moveToHome()

                    } else {
                        self.delegate?.showAlertView(title: "", msg: response.error_message ?? "Something_went_wrong".localized)
                    }
                } else {
                    self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: message?.body ?? "Something_went_wrong".localized, apiType: .login, statusCode: .other))
                }
            })
        } else {
            self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: "No_internet_connection_Tap_to_retry".localized, apiType: .login, statusCode: .limited_internet))
        }
    }

}
