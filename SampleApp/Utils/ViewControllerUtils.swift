//
//  ViewControllerUtils.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import NotificationBannerSwift
import UIKit

/**
 * Enum for every storyboard
 */
enum StoryBoard : String {
    case main
    case userAuthentication

    var name: String {
        return rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}
/**
* Enum for every viewcontroller to load from storyboard
*/
enum VController : String {

    // ViewControllers
    case splash
    case login
    case forgetPassword
    case verifyResetPasswordOtp
    case resetPassword

    // TabBarItems
    case home
    case notificationsInbox
    case more

    var name: String {
        return rawValue.prefix(1).uppercased() + rawValue.dropFirst() + "VC"
    }

}

/**
 * Class that contain some genaric functions for viewcontrollers and load
 * Controllers from different storyboards
 */
class ViewControllerUtils {
    public static func getViewController(viewController: VController, fromStoryBoard: StoryBoard) -> UIViewController {
        let storyboard = UIStoryboard.init(name: fromStoryBoard.name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewController.name)
    }
}

extension UIViewController {

    func shouldHideLoader(isHidden: Bool, views: [UIView], hideViews: [UIView]) {
        if isHidden {
            views.forEach { $0.stopSkelting() }
            hideViews.forEach {$0.isHidden = false}
        } else {
            views.forEach { $0.startSkelting() }
            hideViews.forEach {$0.isHidden = true}
        }
    }

    func showInputDialog(title: String? = nil,
                         subtitle: String? = nil,
                         actionTitle: String? = "Add",
                         cancelTitle: String? = "Cancel",
                         inputPlaceholder: String? = nil,
                         inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (_: UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        self.present(alert, animated: true, completion: nil)

    }

    public func showAlertView(title: String, msg: String,
                              sucTtl: String,
                              canTtl: String = "",
                              sucBlock: (() -> Void)! = nil,
                              canBlock: (() -> Void)! = nil) {
        showAlertView(title: title, message: msg, b1Ttl: sucTtl, b2Ttl: canTtl, b1CBack: sucBlock, b2CBack: canBlock)

    }

    public func showAlertView(title: String, msg: String,
                              sucTtl: String,
                              sucBlock: (() -> Void)! = nil) {
        showAlertView(title: title, message: msg, b1Ttl: sucTtl, b1CBack: sucBlock)
    }

    public func showAlertView(title: String, message: String,
                              b1Ttl: String = "",
                              b2Ttl: String = "",
                              b3Ttl: String = "",
                              b1CBack: (() -> Void)! = nil,
                              b2CBack: (() -> Void)! = nil,
                              b3CBack: (() -> Void)! = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        if b3Ttl.count > 0 {
            alert.addAction(UIAlertAction(title: b3Ttl, style: UIAlertAction.Style.default, handler: {_ in
                if b3CBack != nil {
                    b3CBack()
                }
            }))
        }

        if b2Ttl.count > 0 {
            alert.addAction(UIAlertAction(title: b2Ttl, style: UIAlertAction.Style.default, handler: {_ in
                if b2CBack != nil {
                    b2CBack()
                }
            }))
        }

        if b1Ttl.count > 0 {
            alert.addAction(UIAlertAction(title: b1Ttl, style: UIAlertAction.Style.default, handler: {_ in
                if b1CBack != nil {
                    b1CBack()
                }
            }))
        }

        present(alert, animated: true, completion: nil)

    }

    public func showAlertView(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in

        }))
        present(alert, animated: true, completion: nil)

    }

}
