//
//  MoreViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 16/05/2024.
//

import Foundation

protocol MoreViewModelObserver: BaseViewModelDelegatesProtocol {
    func moveToLogin()
}

protocol MoreViewModelInput {
    var delegate: MoreViewModelObserver? { get set }
    var networkService: MoreVCNetworkServiceProtocol? { get set }
    func attemptTologout()
}

class MoreViewModel {
    // MARK: - Vars & Lets
    weak private var delegate: MoreViewModelObserver?
    private var networkService: MoreVCNetworkServiceProtocol?

    // MARK: - Initializer
    init(delegate: MoreViewModelObserver, networkService: MoreVCNetworkServiceProtocol) {
        self.delegate = delegate
        self.networkService = networkService
    }

    // MARK: - Methods

    func attemptTologout() {
        if InternetConnectivity.isConnectedToInternet {
            self.delegate?.showLoader()
            self.networkService?.logout(handler: { response, message in
                if let response = response {
                    if response.status ?? false {
                        DispatchQueue.main.async {
                            DataCacheManager.shared.dispose()
                            UserDefaultsManager.shared.disposeUserData()
                            DataCacheManager.shared.dispose()
                            self.delegate?.moveToLogin()
                        }
                    } else {
                        self.delegate?.showAlertView(title: "Error".localized, msg: response.error_message ?? "Something_went_wrong".localized)
                    }
                    self.delegate?.hideLoader()
                } else {
                    self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: message?.body ?? "Something_went_wrong".localized, apiType: .send_otp, statusCode: .limited_internet))
                }
            })
        } else {
            self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: "No_internet_connection_Tap_to_retry".localized, apiType: .send_otp, statusCode: .limited_internet))
        }
    }

}
