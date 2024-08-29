//
//  ForgetPasswordVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import UIKit
import NotificationBannerSwift
import TweeTextField

protocol ForgotPwdVCProtocol: AnyObject {
    var onMoveToVerifyCode: ((_ email: String) -> Void)? { get set }
}

class ForgetPasswordVC: BaseViewController, ForgotPwdVCProtocol {

    // MARK: - IBOutlets
    @IBOutlet weak var viewEmailField: UIView!
    @IBOutlet weak var txtEmail: TweeAttributedTextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewContentContainer: UIView!
    // MARK: - ForgotPwdVCProtocol
    var onMoveToVerifyCode: ((_ email: String) -> Void)?

    // MARK: - Vars & Lets
    var viewModel: ForgetPasswordViewModel?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    func setupViews() {
        self.viewContentContainer.roundCorners(cornerRadius: 20.0, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        self.viewEmailField.layer.cornerRadius = 12
        self.btnSend.applyCornerRadius()
        self.btnSend.disable()
        self.txtEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @IBAction func btnSendTapped(_ sender: Any) {
        self.viewModel?.sendCodeTo(params: ForgetPasswordModel(email: self.txtEmail.text!))
    }

    // MARK: - override Delagates
    func showLoader() {
        self.isLoadingData = true
        self.btnSend.startSkelting()
    }

    func hideLoader() {
        self.isLoadingData = false
        self.btnSend.stopSkelting()
    }

    func showBannerWithMessage(bannerInfo: BannerInfoModel) {
        
        setupBannerView(bannerInfo: bannerInfo)

        self.banner.onTap = {
            self.banner.dismiss()
            self.viewModel?.sendCodeTo(params: ForgetPasswordModel(email: self.txtEmail.text!))
        }
        self.banner.onSwipeUp = {
            self.banner.dismiss()
        }
    }
}

extension ForgetPasswordVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {}

    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.txtEmail.text?.count == 0 {
            self.txtEmail.showInfo("Please_enter_valid_email_address".localized)
            self.btnSend.disable()
        } else if !(Helper.shared.isValidEmailAddress(email: self.txtEmail.text ?? "")) {
            self.txtEmail.showInfo("Please_enter_valid_email_address".localized)
            self.btnSend.disable()
        } else {
            self.txtEmail.hideInfo()
            self.btnSend.enable()
        }
    }
}

extension ForgetPasswordVC: ForgetPasswordViewModelObserver {

    func moveToVerifyCode(email: String) {
        self.onMoveToVerifyCode?(email)
    }
}
