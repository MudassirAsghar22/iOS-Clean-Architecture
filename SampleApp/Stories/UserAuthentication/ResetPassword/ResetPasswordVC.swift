//
//  ResetPasswordVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 17/05/2024.
//

import UIKit
import NotificationBannerSwift
import TweeTextField

enum FieldsErrorType {
    case newPwd
    case confirmPwd
}

protocol ResetPasswordVCVCProtocol: AnyObject {
    var onMoveToLoginVC: (() -> Void)? { get set }
}

class ResetPasswordVC: BaseViewController, ResetPasswordVCVCProtocol {

    // MARK: - IBOutlets
    @IBOutlet weak var viewPwd: UIView!
    @IBOutlet weak var viewConfirmPwd: UIView!
    @IBOutlet weak var txtNewPwd: TweeAttributedTextField!
    @IBOutlet weak var txtConfirmPwd: TweeAttributedTextField!
    @IBOutlet weak var btnNewPwdVisibility: UIButton!
    @IBOutlet weak var btnConfirmPwdVisibility: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewContent: UIView!

    // MARK: - ResetPwdVCProtocol
    var onMoveToLoginVC: (() -> Void)?

    // MARK: - Vars & Lets
    var viewModel: ResetPasswordViewModel?

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    func setupViews() {
        self.btnSubmit.applyCornerRadius()
        self.viewPwd.layer.cornerRadius = 12
        self.viewConfirmPwd.layer.cornerRadius = 12
        self.viewContent.roundCorners(cornerRadius: 20.0, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        self.txtNewPwd.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.txtConfirmPwd.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.btnSubmit.disable()
    }

    // MARK: - Button Actions

    @IBAction func btnSubmitPressed(_ sender: Any) {
        self.btnSubmit.isSelected = true
        self.viewModel?.resetPwd(params: ResetPasswordUploadModel(email: self.viewModel?.model?.email ?? "", password: self.txtNewPwd.text ?? "", confirm_password: self.txtConfirmPwd.text ?? "."))
    }

    @IBAction func btnNewPwdVisibilityPressed(_ sender: Any) {
        if txtNewPwd.isSecureTextEntry {
            self.txtNewPwd.isSecureTextEntry = false
            self.btnNewPwdVisibility.setImage(UIImage(named:"icon_cross_eye"), for: .normal)
        } else {
            self.txtNewPwd.isSecureTextEntry = true
            self.btnNewPwdVisibility.setImage(UIImage(named:"icon_open_eye"), for: .normal)
        }
    }

    @IBAction func btnConfirmPwdVisibilityPressed(_ sender: Any) {
        if txtConfirmPwd.isSecureTextEntry {
            self.txtConfirmPwd.isSecureTextEntry = false
            self.btnConfirmPwdVisibility.setImage(UIImage(named:"icon_cross_eye"), for: .normal)
        } else {
            self.txtConfirmPwd.isSecureTextEntry = true
            self.btnConfirmPwdVisibility.setImage(UIImage(named:"icon_open_eye"), for: .normal)
        }
    }

    // MARK: - Override Delegates
    func showLoader() {
        self.isLoadingData = true
        self.btnSubmit.startSkelting()
    }

    func hideLoader() {
        self.isLoadingData = false
        self.btnSubmit.stopSkelting()

    }

    func showBannerWithMessage(bannerInfo: BannerInfoModel) {
        self.setupBannerView(bannerInfo: BannerInfoModel(message: bannerInfo.message ?? "", statusCode: bannerInfo.statusCode ?? .other))
        self.banner.onTap = {
            self.banner.dismiss()
            self.viewModel?.resetPwd(params: ResetPasswordUploadModel(email: self.viewModel?.model?.email ?? "", password: self.txtNewPwd.text ?? "", confirm_password: self.txtConfirmPwd.text ?? "."))
        }
        self.banner.onSwipeUp = {
            self.banner.dismiss()
        }
    }
}

// MARK: - TextField Delegates
extension ResetPasswordVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.viewModel?.shouldEnableChangePwdBtn(text1: self.txtNewPwd.text ?? "", text2: self.txtConfirmPwd.text ?? "") ?? false {
            self.btnSubmit.enable()
        } else {
            self.btnSubmit.disable()
        }

    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.viewModel?.shouldEnableChangePwdBtn(text1: self.txtNewPwd.text ?? "", text2: self.txtConfirmPwd.text ?? "") ?? false {
            self.btnSubmit.enable()
        } else {
            self.btnSubmit.disable()
        }
    }
}

extension ResetPasswordVC: ResetPasswordViewModelObserver {
    func moveToLogin(msg: String) {
        self.showAlertView(title: "", msg: msg, sucTtl: "OK".localized, sucBlock: {
            self.onMoveToLoginVC?()
        })
    }

    func showFieldsError(type: FieldsErrorType, message: String) {
        switch type {
        case .newPwd:
            self.txtNewPwd.showInfo(message)
        default:
            self.txtConfirmPwd.showInfo(message)
        }
    }

    func hideErrorFields(type: FieldsErrorType) {
        switch type {
        case .newPwd:
            self.txtNewPwd.hideInfo()
        default:
            self.txtConfirmPwd.hideInfo()
        }
    }
}
