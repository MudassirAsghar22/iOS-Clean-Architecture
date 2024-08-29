//
//  Constants.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import UIKit
import Foundation

let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate


struct Constants {
    // Privacy policy url
    struct PrivacyPolicy {
        static let url = URL(string: "https://dummyjson.com/privacy-policy/")
    }


    // MARK: NotificationNames
    struct NotificationNames {
        static let k_maintenance = Notification.Name("Maintenance")
        static let k_sessionExpired = Notification.Name("k_sessionExpired")
        static let k_showNotificationBanner = Notification.Name("showNotificationBanner")
        static let k_removeAppCycleObservers = Notification.Name("removeAppCycleObservers")
    }

    // MARK: Server error codes retreived through Alamofire
    struct ServerResponseCodes {
        static let unAuth = 401
        static let tooManyRequests = 429
        static let tokenExpire = 405
        static let success = 200
        static let internelServerError = 500
        static let underMaintenance = 503
        static let passwordInvalidated = 511

    }

    // MARK: API Response Codes
    enum APIResponseCodes {
        case codeZero
        case noData
        case success
        case failure
        case internetUnavailable
    }

    // MARK: Fields Error Type
    enum APIErrorType {
        case other
        case limited_internet
    }

    // MARK: KeyChainWrapperKeys
    struct KeychainWrapperKeys {
        static let k_access_token = "access_token"
        static let k_email = "email"
        static let k_password = "password"
    }
    // MARK: DateFormates in use
    enum DateFormate : String {
        case yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss"
        case yyyy_MM_dd_HH_mm = "yyyy-MM-dd HH:mm"
        case yyyy_MM_dd_HH = "yyyy-MM-dd HH"
        case MM_dd_yyyy_HH_mm_wioutSlash = "MM-dd-yyyy HH:mm"
        case MM_dd_yyyy_HH_mm = "MM/dd/yyyy HH:mm"
        case MM_dd_yyyy_HH_mm_ss = "MM/dd/yyyy HH:mm:ss"
        case MM_dd_yyyy_h_mm_a = "MM/dd/yyyy h:mm a"
        case HH_mm = "HH:mm"
        case yyyy_MM_dd = "yyyy-MM-dd"
        case MM_dd_yyyy = "MM/dd/yyyy"
        case MM_dd_yyy_HH = "MM/dd/yyyy HH"
        case HH_mm_ss = "HH:mm:ss"
        case h_mm_a = "h:mm a"
        case hh_mm_a = "hh:mm a"
        case k_mm = "k:mm"
        case MMM_dd_yy_hh_mm_a = "MMM dd yy, hh:mm a"
    }
}

extension Constants {
    struct ServerFlags {

        enum PushNotificationTypes: String {
            case notification_home = "notification_home"
        }
    }
}
