//
//  VerifyResetPasswordOtpVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import UIKit
import NotificationBannerSwift
import IQKeyboardManagerSwift

protocol VerifyCodeVCProtocol: AnyObject {
    var onMoveToResetPasswordVC:((_ email: String) -> Void)? { get set }
}

class VerifyResetPasswordOtpVC: BaseViewController, VerifyCodeVCProtocol, UITextFieldDelegate {

    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var viewOTPTextFields: UIView!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblCounter: UILabel!
    // MARK: - VerifyCodeVCProtocol
    var onMoveToResetPasswordVC:((_ email: String) -> Void)?

    // MARK: - Vars & Lets
    var viewModel: VerifyResetPasswordOtpViewModel?
    var otpStackView = OTPStackView()
    var timerCount = 60
    var isResendPressed = false
    var timer: RepeatingTimer?

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setOTPfields()
        self.setupViewsAndSartTimer()
    }

    // MARK: - Functions
    private func setOTPfields() {
        self.setAttributedTitleToResendOTPbtn()
        self.viewContent.roundCorners(cornerRadius: 20.0, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        // View OTP Text Fields Setup
        self.otpStackView = OTPStackView.init(frame: self.viewOTPTextFields.frame)
        self.viewOTPTextFields.addSubview(otpStackView)

        self.otpStackView.delegate = self
    }

    private func setupViewsAndSartTimer() {

        self.timer = RepeatingTimer(timeInterval: 1)
        self.timer?.eventHandler = {
            DispatchQueue.main.sync {
                self.updateCounter()
            }
        }
        self.lblCounter.isHidden = false
        self.btnResend.isHidden = true
        self.addAppCycleObservers()
        self.timer?.resume()
        self.btnVerify.disable()
    }

    func updateCounter() {
        DispatchQueue.main.async {
            if self.timerCount > 1 {
                self.timerCount -= 1
                if self.background_forground_timelaps != nil && self.backgroundTime == nil {
                    self.timerCount -= (self.background_forground_timelaps)!
                    self.background_forground_timelaps = nil
                }
                self.btnResend.disable()
                DispatchQueue.main.async {
                    self.lblCounter.text = "\(self.timerCount)"
                }
            } else {
                self.suspendTimer()
            }
        }
    }

    func suspendTimer() {
        self.timer?.suspend()
        self.timerCount = 60
        self.lblCounter.text = "\(self.timerCount)"
        self.lblCounter.isHidden = true
        self.btnResend.isHidden = false
        self.btnVerify.disable()
        self.btnResend.enable()
        for index in 0...self.otpStackView.textFieldsCollection.count - 1 {
            self.otpStackView.textFieldsCollection[index].text?.removeAll()
        }
        self.loadViewIfNeeded()
    }

    func setAttributedTitleToResendOTPbtn() {
        let attributedString = NSAttributedString(string: "resend_otp".localized, attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.underlineStyle:1.0
        ])
        self.btnResend.setAttributedTitle(attributedString, for: .normal)
    }

    // MARK: - Button Actions
    @IBAction func btnVerifyPressed(_ sender: Any) {
        var strCodeEntered = String()
        for text in self.otpStackView.textFieldsCollection {
            strCodeEntered += text.text!
        }
        self.btnVerify.startSkelting()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.viewModel?.verifyCode(params: VerifyResetPasswordPostModel(email: self.viewModel?.model.email ?? "", otp: strCodeEntered))
        }
    }

    @IBAction func btnResendPressed(_ sender: Any) {
        self.isResendPressed = true
        self.btnResend.disable()
        self.btnResend.startSkelting()
        self.viewModel?.resendCode(params: ForgetPasswordModel(email: self.viewModel?.model.email ?? ""))
    }

    func showBannerWithMessage(bannerInfo: BannerInfoModel) {
        self.setupBannerView(bannerInfo: BannerInfoModel(message: bannerInfo.message ?? "", statusCode: bannerInfo.statusCode ?? .other))
        self.banner.onTap = {
            self.banner.dismiss()

            switch bannerInfo.apiType {
            case .send_otp:
                self.viewModel?.resendCode(params: ForgetPasswordModel(email: self.viewModel?.model.email ?? ""))
            default:
                self.viewModel?.verifyCode(params: VerifyResetPasswordPostModel(email: self.viewModel?.model.email ?? "", otp: bannerInfo.params!["otp"] as! String))
            }
        }
        self.banner.onSwipeUp = {
            self.banner.dismiss()
        }
    }

    // MARK: - Override Delegates
    func showLoader() {
        self.isLoadingData = true
    }

    func hideLoader() {
        self.isLoadingData = false
            if self.isResendPressed {
                self.btnResend.stopSkelting()
                self.isResendPressed = false
            } else {
                self.btnVerify.stopSkelting()
            }
    }
}

// MARK: - TextField Delegates
extension VerifyResetPasswordOtpVC {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        textField.resignFirstResponder()
        return false
    }

}

// MARK: - OTP Delegate
extension VerifyResetPasswordOtpVC: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        isValid ? self.btnVerify.enable() : self.btnVerify.disable()
    }
}

// MARK: - VerifyResetPasswordOtpViewModelObserver
extension VerifyResetPasswordOtpVC: VerifyResetPasswordOtpViewModelObserver {

    func codeResent() {
        self.showAlertView(title: "", msg: "Code_resent_successfully".localized, sucTtl: "ok".localized) {
            self.timerCount = 60
            self.setupViewsAndSartTimer()
        }
    }

    func moveToChangePwd() {
        self.onMoveToResetPasswordVC?(self.viewModel?.model.email ?? "")
    }
}
