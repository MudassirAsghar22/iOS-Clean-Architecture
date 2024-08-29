//
//  NotificationsInboxNetworkService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 05/06/2024.
//

import Foundation

protocol NotificationsInboxNetworkServiceProtocol: AnyObject {

}

class NotificationsInboxNetworkService: NotificationsInboxNetworkServiceProtocol {
    // MARK: - Vars & Lets

    private let apiManager: APIManager
    // MARK: - Initialization

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
}

