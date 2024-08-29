//
//  VerifyResetPasswordOtpViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import UIKit
import Alamofire
import NotificationBannerSwift

protocol VerifyResetPasswordOtpViewModelObserver: BaseViewModelDelegatesProtocol {
    func moveToChangePwd()
    func codeResent()
}

protocol VerifyResetPasswordOtpViewModelInput {
    func verifyCode(params: VerifyResetPasswordPostModel)
    func resendCode(params: ForgetPasswordModel)
}

class VerifyResetPasswordOtpViewModel: VerifyResetPasswordOtpViewModelInput {

    // MARK: - Vars & Lets
    weak private var delegate: VerifyResetPasswordOtpViewModelObserver?
    private var networkService: VerifyResetPasswordNetworkService?
    var model: VerifyResetPasswordPostModel

    // MARK: - Init
    init(model: VerifyResetPasswordPostModel, networkService: VerifyResetPasswordNetworkService, delegate: VerifyResetPasswordOtpViewModelObserver?) {
        self.networkService = networkService
        self.delegate = delegate
        self.model = model
    }

    // MARK: - Public Functions
    func verifyCode(params: VerifyResetPasswordPostModel) {
        if InternetConnectivity.isConnectedToInternet {
            self.delegate?.showLoader()
            self.networkService?.verifyCode(params: params, handler: { response, message in
                self.delegate?.hideLoader()
                if let response = response {
                    if response.status ?? false {
                        self.delegate?.moveToChangePwd()
                    } else {
                        self.delegate?.showAlertView(title: "Error".localized, msg: response.error_message ?? "Something_went_wrong".localized)
                    }
                } else {
                    self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: message?.body ?? "Something_went_wrong".localized, apiType: .verify_otp, statusCode: .limited_internet))
                }
            })
        } else {
            self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: "No_internet_connection_Tap_to_retry".localized, apiType: .verify_otp, statusCode: .limited_internet))
        }
    }

    func resendCode(params: ForgetPasswordModel) {
        if InternetConnectivity.isConnectedToInternet {
            self.delegate?.showLoader()
            self.networkService?.sendCode(params: params, handler: { response, message in
                self.delegate?.hideLoader()
                if let response = response {
                    if response.status ?? false {
                        self.delegate?.codeResent()
                    } else {
                        DispatchQueue.main.async {
                            self.delegate?.showAlertView(title: "Error".localized, msg: response.error_message ?? "Something_went_wrong".localized)
                        }
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

