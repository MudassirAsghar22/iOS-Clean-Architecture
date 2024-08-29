//
//  ForgetPasswordNetworkService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import Foundation

protocol ForgetPasswordNetworkServiceProtocol: AnyObject {
    func sendCode(params: ForgetPasswordModel, handler: @escaping (_ resp: PasswordResetResponseModel?, _ message: AlertMessage?) -> Void )
}

class ForgetPasswordNetworkService: ForgetPasswordNetworkServiceProtocol {
    // MARK: - Vars & Lets
    private let apiManager: APIManager

    // MARK: - Initialization
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Public methods
    func sendCode(params: ForgetPasswordModel, handler: @escaping (_ resp: PasswordResetResponseModel?, _ message: AlertMessage?) -> Void ) {
        self.apiManager.call(type: RequestItemsType.send_otp, params: params.dictionary()) {  (res: Swift.Result<PasswordResetResponseModel, AlertMessage>) in
            switch res {
            case .success(let response):
                handler(response, nil)
            case .failure(let message):
                handler(nil, message)
            }
        }
    }
}
