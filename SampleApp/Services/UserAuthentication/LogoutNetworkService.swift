//
//  LogoutNetworkService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 16/05/2024.
//

import Foundation


protocol MoreVCNetworkServiceProtocol: AnyObject {
    func logout(handler: @escaping (_ resp: LogoutModelResponse?, _ message: AlertMessage?) -> Void )
}

class MoreVCNetworkService: MoreVCNetworkServiceProtocol {
    // MARK: - Vars & Lets
    private let apiManager: APIManager

    // MARK: - Initialization
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Public methods
    func logout(handler: @escaping (_ resp: LogoutModelResponse?, _ message: AlertMessage?) -> Void ) {
        self.apiManager.call(type: RequestItemsType.logout, params: ["token": DataCacheManager.shared.getTokenFromKeychain() ?? ""]) {  (res: Swift.Result<LogoutModelResponse, AlertMessage>) in
            switch res {
            case .success(let response):
                handler(response, nil)
            case .failure(let message):
                handler(nil, message)
            }
        }
    }
}
