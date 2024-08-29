//
//  NotificationsVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 09/05/2024.
//

import UIKit

protocol NotificationsInboxVCProtocol: UIViewController {
    var didSendEventClosure: ((NotificationsInboxVC.Event) -> Void)? { get set }
}

extension NotificationsInboxVC {
    enum Event {
        case moveToHome
    }
}

class NotificationsInboxVC: BaseViewController {

    // MARK: - NotificationsInboxVCProtocol
    var didSendEventClosure: ((NotificationsInboxVC.Event) -> Void)?
    // MARK: - Vars & Lets
    var viewModel: NotificationsInboxViewModel?

    private let refreshControl = UIRefreshControl()
    var isLoadingMore = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

}

// MARK: - NotificationsInboxViewModelObserver
extension NotificationsInboxVC: NotificationsInboxViewModelObserver {
    func showLoader() {

    }
    
    func hideLoader() {

    }
    
    func showBannerWithMessage(bannerInfo: BannerInfoModel) {
        
    }
}
