//
//  HomeViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 21/05/2024.
//

import Foundation
import Alamofire
import NotificationBannerSwift
import SwiftKeychainWrapper

protocol HomeViewModelObserver: BaseViewModelDelegatesProtocol {

}

protocol HomeViewModelInput {
    
}

class HomeViewModel: HomeViewModelInput {

    // MARK: - Vars
    var model: HomeModel = HomeModel()
    weak private var delegate: HomeViewModelObserver?
    private var networkService: HomeNetworkServiceProtocol?

    // MARK: - Inititalizer
    init(model: HomeModel, networkService: HomeNetworkServiceProtocol, delegate: HomeViewModelObserver) {
        self.model = model
        self.networkService = networkService
        self.delegate = delegate
    }
}
