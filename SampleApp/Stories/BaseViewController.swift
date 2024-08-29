//
//  ParentViewController.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import UIKit
import NotificationBannerSwift

protocol BaseViewControllerProtocol {
    var isLoadingData: Bool {get set}
    var leftView: UIImageView? { get set }
    var banner: StatusBarNotificationBanner { get set }
    var backgroundTime: Date? { get set }
    var background_forground_timelaps: Int? { get set }
    func setupBannerView(bannerInfo: BannerInfoModel)
    var onBack: (() -> Void)? { get set }
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    // Implement protocol requirements
    // MARK: - Vars & Lets
    var isLoadingData: Bool = false
    var onBack: (() -> Void)?
    var leftView: UIImageView? = UIImageView.init(image: UIImage.init(named: "error"))
    var banner = StatusBarNotificationBanner.init(title: "Something_went_wrong_please_try_again".localized, style: .warning, colors: nil)

    // Timer calculations helper variables
    var backgroundTime: Date?
    var background_forground_timelaps: Int?
    
    // MARK: - Public Methods

    override func viewDidLoad() {
        UIApplication.shared.statusBarUIView?.backgroundColor = Colors.theme
        overrideUserInterfaceStyle = .light
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.banner.dismiss()
    }

    func setupBannerView(bannerInfo: BannerInfoModel) {
        self.banner.dismiss()
        if bannerInfo.statusCode == Constants.APIErrorType.limited_internet {
            leftView = UIImageView.init(image: UIImage.init(named: "no_internet"))
        } else {
            leftView = UIImageView.init(image: UIImage.init(named: "error"))
        }

        self.banner = StatusBarNotificationBanner(title: bannerInfo.message ?? "Something_went_wrong_please_try_again".localized, style: .warning, colors: nil)
        self.banner.autoDismiss = false
        self.banner.backgroundColor = Colors.darkGreen
        self.banner.removeExistingBanner()
        self.banner.show(queuePosition: .back, bannerPosition: .bottom)
        // Dismiss Banner after 3 seconds...
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.banner.dismiss(forced: true)
        }
    }

    @IBAction func btnBackTapped(_ sender: Any) {
        self.onBack?()
    }
}

extension BaseViewController {

        func addAppCycleObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.removeAppCycleObservers), name: Constants.NotificationNames.k_removeAppCycleObservers, object: nil)

        }

        @objc func removeAppCycleObservers() {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)

        }

        @objc fileprivate func didEnterBackgroundNotification() {
            self.background_forground_timelaps = nil
            self.backgroundTime = Date()

        }

        @objc fileprivate func willEnterForegroundNotification() {
            // refresh the label here
            self.background_forground_timelaps = Date().interval(ofComponent: .second, fromDate: self.backgroundTime ?? Date())
            self.backgroundTime = nil

        }
}
