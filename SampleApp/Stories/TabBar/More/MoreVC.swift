//
//  MoreVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 09/05/2024.
//

import UIKit

protocol MoreVCProtocol: UIViewController {
    var didSendEventClosure: ((MoreVC.Event) -> Void)? { get set }
}

extension MoreVC {
    enum Event {
        case moveToLogin
    }
}

class MoreVC: BaseViewController, MoreVCProtocol {
    
    // MARK: - MoreVCProtocol
    var didSendEventClosure: ((MoreVC.Event) -> Void)?

    // MARK: - Vars & Lets
    var viewModel: MoreViewModel?
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnBackPressed(_ sender: Any) {
        self.onBack?()
    }
}

extension MoreVC: MoreViewModelObserver {
    func showLoader() {
        self.isLoadingData = true

    }
    
    func hideLoader() {
        self.isLoadingData = false

    }
    
    func showBannerWithMessage(bannerInfo: BannerInfoModel) {
        setupBannerView(bannerInfo: bannerInfo)
        self.banner.onTap = {
            self.banner.dismiss()
            
        }
        banner.onSwipeUp = {
            self.banner.dismiss()
        }
    }
    
    func moveToLogin() {
        didSendEventClosure?(.moveToLogin)
    }
}
