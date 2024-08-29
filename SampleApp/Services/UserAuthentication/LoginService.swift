//
//  LoginService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 13/05/2024.
//

import Foundation

protocol LoginNetworkServicesProtocol: AnyObject {
    func userSignInService(params: [String: Any], handler: @escaping (_ resp: LoginResponse?, _ message: AlertMessage?) -> Void )
}

class LoginNetworkServices: LoginNetworkServicesProtocol {
    // MARK: - Vars & Lets

    private let apiManager: APIManager
    // MARK: - Initialization

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Public methods
    func userSignInService(params: [String: Any], handler: @escaping (_ resp: LoginResponse?, _ message: AlertMessage?) -> Void ) {
        self.apiManager.call(type: RequestItemsType.login, params: params) {  (res: Swift.Result<LoginResponse, AlertMessage>) in
            switch res {
            case .success(let response):
                handler(response, nil)
            case .failure(let message):
                handler(nil, message)
            }
        }
    }
}
