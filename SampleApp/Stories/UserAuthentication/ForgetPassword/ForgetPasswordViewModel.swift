//
//  ForgetPasswordViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import Foundation
protocol ForgetPasswordViewModelObserver: BaseViewModelDelegatesProtocol {
    func moveToVerifyCode(email: String)
}

protocol ForgetPasswordViewModelInput {
    func sendCodeTo(params: ForgetPasswordModel)
}

class ForgetPasswordViewModel: ForgetPasswordViewModelInput {

    // MARK: - Vars & Lets
    weak private var delegate: ForgetPasswordViewModelObserver?
    var model: ForgetPasswordModel?
    private var networkService: ForgetPasswordNetworkService?

    // MARK: - Init
    init(networkService: ForgetPasswordNetworkService, delegate: ForgetPasswordViewModelObserver?) {
        self.networkService = networkService
        self.delegate = delegate
    }

    func sendCodeTo(params: ForgetPasswordModel) {
        if InternetConnectivity.isConnectedToInternet {
            self.delegate?.showLoader()
            self.networkService?.sendCode(params: params, handler: { response, message in
                self.delegate?.hideLoader()
                if let response = response {
                    if response.status ?? false {
                        self.delegate?.moveToVerifyCode(email: params.email)
                    } else {
                        self.delegate?.showAlertView(title: "Error".localized, msg: response.error_message ?? "Something_went_wrong".localized)
                    }
                } else {
                    self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: message?.body ?? "Something_went_wrong".localized, apiType: .send_otp, statusCode: .limited_internet))
                }
            })
        } else {
            self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: "No_internet_connection_Tap_to_retry".localized, apiType: .send_otp, statusCode: .limited_internet))
        }
    }
}
