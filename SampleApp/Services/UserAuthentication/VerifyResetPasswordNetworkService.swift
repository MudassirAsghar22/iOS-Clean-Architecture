//
//  VerifyResetPasswordNetworkService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import Foundation

protocol VerifyResetPasswordNetworkServiceProtocol: AnyObject {
    func sendCode(params: ForgetPasswordModel, handler: @escaping (_ resp: PasswordResetResponseModel?, _ message: AlertMessage?) -> Void )
}

class VerifyResetPasswordNetworkService: ForgetPasswordNetworkService {
    // MARK: - Vars & Lets
    private let apiManager: APIManager

    // MARK: - Initialization
    override init(apiManager: APIManager) {
        self.apiManager = apiManager
        super.init(apiManager: apiManager)
    }

    // MARK: - Public methods
    func verifyCode(params: VerifyResetPasswordPostModel, handler: @escaping (_ resp: PasswordResetResponseModel?, _ message: AlertMessage?) -> Void ) {
        self.apiManager.call(type: RequestItemsType.verify_otp, params: params.dictionary()) {  (res: Swift.Result<PasswordResetResponseModel, AlertMessage>) in
            switch res {
            case .success(let response):
                handler(response, nil)
            case .failure(let message):
                handler(nil, message)
            }
        }
    }
}
