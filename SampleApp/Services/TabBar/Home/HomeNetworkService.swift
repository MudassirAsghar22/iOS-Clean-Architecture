//
//  HomeService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 21/05/2024.
//

import Foundation

protocol HomeNetworkServiceProtocol: AnyObject {

}

class HomeNetworkService: HomeNetworkServiceProtocol {
    // MARK: - Vars & Lets

    private let apiManager: APIManager
    // MARK: - Initialization

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Public methods
}
