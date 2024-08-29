//
//  ResetPasswordViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 17/05/2024.
//

import UIKit
import Alamofire
import NotificationBannerSwift

protocol ResetPasswordViewModelObserver: BaseViewModelDelegatesProtocol {
    func moveToLogin(msg: String)
    func showFieldsError(type: FieldsErrorType, message: String)
    func hideErrorFields(type: FieldsErrorType)
}
protocol ResetPasswordViewModelInput {
    func shouldEnableChangePwdBtn(text1: String, text2: String) -> Bool
    func resetPwd(params: ResetPasswordUploadModel)
}

class ResetPasswordViewModel: ResetPasswordViewModelInput {

    // MARK: - Vars & Lets
    weak private var delegate: ResetPasswordViewModelObserver?
    private var networkService: ResetPasswordNetworkService?
    var model: ForgetPasswordModel?

    // MARK: - Init
    init(networkService: ResetPasswordNetworkService, delegate: ResetPasswordViewModelObserver?, model: ForgetPasswordModel) {
        self.networkService = networkService
        self.delegate = delegate
        self.model = model
    }

    // MARK: - Public functions
    func shouldEnableChangePwdBtn(text1: String, text2: String) -> Bool {
        if text1.count == 0 {
            self.delegate?.showFieldsError(type: .newPwd, message: "Enter_pwd".localized)
            return false
        }
        self.delegate?.hideErrorFields(type: .newPwd)
        //
        if text1 != text2 {
            self.delegate?.showFieldsError(type: .confirmPwd, message: "Confirm_password_not_match".localized)
            return false
        }
        //
        self.delegate?.hideErrorFields(type: .confirmPwd)
        return true
    }

    func resetPwd(params: ResetPasswordUploadModel) {
        if InternetConnectivity.isConnectedToInternet {
            self.delegate?.showLoader()
            self.networkService?.resetPasswordd(params: params, handler: { response, message in
                self.delegate?.hideLoader()
                if let response = response {
                    if response.status ?? false {
                        
                        self.delegate?.moveToLogin(msg: response.success_message ?? "Password_reset_successfully".localized)

                    } else {
                        self.delegate?.showAlertView(title: "Error", msg: response.error_message ?? "Something_went_wrong".localized)
                    }
                } else {
                    self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: message?.body ?? "Something_went_wrong".localized, apiType: .reset_password, statusCode: .limited_internet))
                }
            })
        } else {
            self.delegate?.showBannerWithMessage(bannerInfo: BannerInfoModel(message: "No_internet_connection_Tap_to_retry".localized, apiType: .reset_password, statusCode: .limited_internet))
        }
    }
}
