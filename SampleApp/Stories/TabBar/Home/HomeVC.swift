//
//  HomeVC.swift
//  Sample App
//
//  Created by Mudassir Asghar on 09/05/2024.
//

import UIKit
import SkeletonView
import CoreLocation

protocol HomeVCProtocol: UIViewController {
    var didSendEventClosure: ((HomeVC.Event) -> Void)? { get set }
}

class HomeVC: BaseViewController, HomeVCProtocol {
    // MARK: - IBOutlets

    // MARK: - HomeVCProtocol
    var didSendEventClosure: ((HomeVC.Event) -> Void)?
    // MARK: - Vars and Lets
    var viewModel: HomeViewModel?

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Functions

    // MARK: - IBActions
}

// MARK: - HomeViewModelObserver
extension HomeVC: HomeViewModelObserver {
    func showLoader() {

    }
    
    func hideLoader() {

    }
    
    func showBannerWithMessage(bannerInfo: BannerInfoModel) {

    }
    

}

// MARK: - Events
extension HomeVC {
    enum Event {
    }
}
