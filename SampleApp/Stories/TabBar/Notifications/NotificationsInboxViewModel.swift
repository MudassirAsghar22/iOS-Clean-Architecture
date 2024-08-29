//
//  NotificationsInboxViewModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 05/06/2024.
//

import Foundation

protocol NotificationsInboxViewModelObserver: BaseViewModelDelegatesProtocol {}

protocol NotificationsInboxViewModelInput {}

class NotificationsInboxViewModel: NotificationsInboxViewModelInput {
    // MARK: - Vars
    var model: NotificationsInboxModel = NotificationsInboxModel(datasource: nil)
    weak private var delegate: NotificationsInboxViewModelObserver?
    private var networkService: NotificationsInboxNetworkServiceProtocol?

    // MARK: - Inititalizer
    init(networkService: NotificationsInboxNetworkServiceProtocol, delegate: NotificationsInboxViewModelObserver) {
        self.networkService = networkService
        self.delegate = delegate
    }

}
