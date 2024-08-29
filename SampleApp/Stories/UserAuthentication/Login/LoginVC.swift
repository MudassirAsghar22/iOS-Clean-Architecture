//
//  LoginVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import UIKit
import TweeTextField
import SwiftKeychainWrapper
import NotificationBannerSwift

protocol LoginViewControllerProtocol {
    var onMoveToHome: (() -> Void)? { get set }
    var onMoveToForgotPwd: (() -> Void)? { get set }
}

class LoginVC: BaseViewController, LoginViewControllerProtocol {

    // MARK: - IBOutlets
    @IBOutlet weak var viewPwd: UIView!
    @IBOutlet weak var viewUsername: UIView!
    @IBOutlet weak var txtEmail: TweeAttributedTextField!
    @IBOutlet weak var txtPwd: TweeAttributedTextField!
    @IBOutlet weak var btnRememberMe: UIButton!
    @IBOutlet weak var btnShowPwd: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewContentContainer: UIView!

    // MARK: - LoginVCProtocol
    var onMoveToHome: (() -> Void)?
    var onMoveToForgotPwd: (() -> Void)?

    // MARK: - Vars & Lets
    var viewModel: LoginViewModel?

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    func askPNpermission() {
        PermissionsManager.shared.requestAccess(permission: .notifications) { isAllowed in
            if isAllowed {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
               // Backup alert is shown through permissions manager
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        txtEmail.text =  nil
        txtPwd.text = nil
    }

    // MARK: - View Setup
    func setupViews() {
        self.viewContentContainer.roundCorners(cornerRadius: 20.0, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        self.txtPwd.clearsContextBeforeDrawing = false
        self.txtPwd.clearsOnBeginEditing = false

        self.viewPwd.layer.cornerRadius = 12
        self.viewUsername.layer.cornerRadius = 12

        if let email = KeychainWrapper.standard.string(forKey: Constants.KeychainWrapperKeys.k_email), email.count > 0,
           let pass = KeychainWrapper.standard.string(forKey: Constants.KeychainWrapperKeys.k_password), pass.count > 0 {
            self.txtEmail.text = email
            self.txtPwd.text = pass
            self.updateRememberMeView()
        }
        self.txtPwd.infoLabel.numberOfLines = 2
        self.btnLogin.applyCornerRadius()
    }

    // MARK: - methods

    func unAuthenticated() {
        self.showAlertView(title: "", msg: "session_expired".localized, sucTtl: "OK".localized) {
            DataCacheManager.shared.dispose()
        }
    }

    func updateRememberMeView() {
        if btnRememberMe.isSelected {
            btnRememberMe.isSelected = false
            self.viewModel?.model.isRememberMeEnabled = false
        } else {
            btnRememberMe.isSelected = true
            self.viewModel?.model.isRememberMeEnabled = true
        }
        let image = self.btnRememberMe.isSelected ? UIImage(named: "icon_checkbox_blue") : UIImage(named: "icon_checkbox_grey")
        btnRememberMe.setImage(image, for: .normal)
    }

    // MARK: - Button Actions
    @IBAction func btnRememberMePressed(_ sender: Any) {
        self.updateRememberMeView()
    }

    @IBAction func btnShowPwdPressed(_ sender: Any) {
        if txtPwd.isSecureTextEntry {
            self.txtPwd.isSecureTextEntry = false
            self.btnShowPwd.setImage(UIImage(named:"icon_cross_eye"), for: .normal)
        } else {
            self.txtPwd.isSecureTextEntry = true
            self.btnShowPwd.setImage(UIImage(named:"icon_open_eye"), for: .normal)
        }
    }

    // MARK: - Override Delegates
    func showLoader() {
        self.isLoadingData = true
        self.btnLogin.startSkelting()
    }

    func hideLoader() {
        self.isLoadingData = false
        self.btnLogin.stopSkelting()

    }

    // MARK: - Helper Methodes
    func showBannerWithMessage(bannerInfo: BannerInfoModel) {
        setupBannerView(bannerInfo: bannerInfo)
        self.banner.onTap = {
            self.banner.dismiss()
            self.viewModel?.attemptTologin(parameters: LoginPostParams(username: self.txtEmail.text ?? "", password: self.txtPwd.text ?? "", remember_me: self.btnRememberMe.isSelected))
        }
        banner.onSwipeUp = {
            self.banner.dismiss()
        }
    }

    // MARK: - IBActions
    @IBAction func btnForgotPwdPressed(_ sender: Any) {
        self.onMoveToForgotPwd?()
    }

    @IBAction func btnLoginPressed(_ sender: Any) {

        if self.getEmptyRequiredField() == nil {
            self.viewModel?.attemptTologin(parameters: LoginPostParams(username: self.txtEmail.text ?? "", password: self.txtPwd.text ?? "", remember_me: self.btnRememberMe.isSelected))
        } else {
            // Show validation error
            btnLogin.shake()
            self.textFieldDidEndEditing(self.txtPwd)
        }
    }
}

// MARK: - TextField delegates
extension LoginVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if textField == self.txtPwd {
            return text.count <= 50
        } else if textField == self.txtEmail {
            return !string.contains(" ")
        } else {
            return true
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {}

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateTextFields(textField: textField)

    }

    func validateTextFields(textField: UITextField) {
        guard let tempTextField = textField as? TweeAttributedTextField else { return }
        let requiredTextField = self.getEmptyRequiredField()
        if requiredTextField != nil {
            if requiredTextField!.tag  <= tempTextField.tag {
                switch requiredTextField {
                case self.txtEmail:
                    self.showErrorInfo(textField: self.txtEmail, error: "please_enter_the_valid_username".localized)
                case self.txtPwd:
                    self.showErrorInfo(textField: self.txtPwd, error: "Enter_pwd".localized)
                default:
                    print("")
                }
            } else {
                tempTextField.hideInfo(animated: true)
            }
        } else {
            tempTextField.hideInfo(animated: true)
        }
    }

    func showErrorInfo(textField: TweeAttributedTextField, error: String) {
        self.txtEmail.hideInfo(animated: true)
        self.txtPwd.hideInfo(animated: true)
        textField.showInfo(error)

    }

    func getEmptyRequiredField() -> UITextField? {
        if self.txtEmail.text?.count == 0 /*||
                                           !Helper.shared.isValidEmailAddress(email: self.txtEmail.text ?? "")*/ {
            return self.txtEmail
        } else if self.txtPwd.text?.count == 0 {
            return self.txtPwd
        } else {
            return nil
        }
    }

}

// MARK: - LoginViewModelObserver
extension LoginVC: LoginViewModelObserver {
    func moveToHome() {
        self.askPNpermission()
        self.onMoveToHome?()
    }
    
}
