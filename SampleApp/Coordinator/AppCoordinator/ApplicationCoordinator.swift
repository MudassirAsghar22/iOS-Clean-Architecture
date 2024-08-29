//
//  ApplicationCoordinator.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import UIKit

/// Define what type of flows can be started from this Coordinator
protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow(remoteNotification: [AnyHashable : Any]?)
    func showMainFlow(remoteNotification: [AnyHashable : Any]?)
}

final class ApplicationCoordinator: BaseCoordinator, AppCoordinatorProtocol {

    // MARK: - Vars & Lets
    private let factory: Factory
    private let router: RouterProtocol
    private var banner = StatusBarNotificationBanner.init(title: "Something_went_wrong_please_try_again".localized, style: .warning, colors: nil)


//    (title: "", subtitle: "Something_went_wrong_please_try_again".localized,
//                                                         leftView: nil, rightView: nil, style: .info, colors: nil)
    var type: CoordinatorType { .app }

    // MARK: - Init
    init(router: RouterProtocol, factory: Factory) {
        self.router = router
        self.factory = factory
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.sessionExpired), name: Constants.NotificationNames.k_sessionExpired, object: nil)
        // Add PN flow observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePushWhenAppIsActive), name: Constants.NotificationNames.k_showNotificationBanner, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.NotificationNames.k_sessionExpired, object: nil)
    }

    // MARK: - Coordinator
    override func start(withNotification: [AnyHashable : Any]?) {
        self.showMainFlow(remoteNotification: withNotification)
//        if DataCacheManager.shared.isLogin() {
//            self.showMainFlow(remoteNotification: withNotification)
//        } else {
//            self.showLoginFlow(remoteNotification: withNotification)
//        }
    }
    // MARK: - Session Expired
    @objc func sessionExpired() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "login_session_expired".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok".localized, style: .default) { _ in
                self.showLoginFlow(remoteNotification: nil)
            })
            appDelegate?.window?.makeKeyAndVisible()
            appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Login Flow
    func showLoginFlow(remoteNotification: [AnyHashable : Any]?) {
        let coordinator = self.factory.instantiateAuthenticationModuleCoordinator(router: self.router)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    // MARK: - Main Flow
    func showMainFlow(remoteNotification: [AnyHashable : Any]?) {
        let coordinator = self.factory.instantiateTabBarCoordinator(router: self.router)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            NotificationCenter.default.removeObserver(self, name: Constants.NotificationNames.k_showNotificationBanner, object: nil)
            self.showLoginFlow(remoteNotification: nil)
        }
        self.addDependency(coordinator)
        coordinator.start(withNotification: remoteNotification)
    }
}

import NotificationBannerSwift
// MARK: - Notification Banner Flow
extension ApplicationCoordinator {

    func runNotificationFlow(payload: [AnyHashable : Any]) {
        guard let payloadData: PushNotificationPayload = DataParserManager.shared.parsePushNotifDataIntoModel(payload: payload) else { return }

        switch payloadData.type {
        case Constants.ServerFlags.PushNotificationTypes.notification_home.rawValue:
            self.showMainFlow(remoteNotification: payload)
        default:
            print("invalid type")
        }

    }

    @objc func handlePushWhenAppIsActive(notification: NSNotification?) {
        if DataCacheManager.shared.isLogin() {
            guard let payload = notification?.userInfo else { return}
            self.showBannerWithMessage(data: payload)
            print("banner shown")
        }
    }

    // MARK: - Banner functions
    func setupBannerView(msg: String) {
        self.banner = StatusBarNotificationBanner.init(title: msg, style: .success, colors: nil)
        self.banner.autoDismiss = false
        self.banner.backgroundColor = Colors.theme
        self.banner.autoDismiss = true
//        self.banner.subtitleLabel?.textAlignment = .left
//        self.banner.subtitleLabel?.center.y = self.banner.center.y
//        self.banner.subtitleLabel?.numberOfLines = 0
        Helper.shared.removeExistingBanner()
        self.banner.show(bannerPosition: .bottom)
        // Dismiss Banner after 3 seconds...
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.banner.dismiss(forced: true)
        }
    }

    func showBannerWithMessage(data: [AnyHashable : Any]) {
        let payload = DataParserManager.shared.parsePushNotifDataIntoModel(payload: data)
        if let body = payload?.body, let action = payload?.type {
            if DataCacheManager.shared.isLogin() {
                self.setupBannerView(msg: body)
            }
        }
        self.banner.onTap = {
            self.banner.dismiss()
            self.runNotificationFlow(payload: data)
        }
        banner.onSwipeUp = {
            self.banner.dismiss()
        }
    }
}
