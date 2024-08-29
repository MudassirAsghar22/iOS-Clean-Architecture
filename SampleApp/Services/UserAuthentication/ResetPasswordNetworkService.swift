//
//  ResetPasswordNetworkService.swift
//  Sample App
//
//  Created by Mudassir Asghar on 17/05/2024.
//

import Foundation

class ResetPasswordNetworkService {
    // MARK: - Vars & Lets
    private let apiManager: APIManager

    // MARK: - Initialization
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Public methods
    func resetPasswordd(params: ResetPasswordUploadModel, handler: @escaping (_ resp: PasswordResetResponseModel?, _ message: AlertMessage?) -> Void ) {
        self.apiManager.call(type: RequestItemsType.reset_password, params: params.dictionary()) {  (res: Swift.Result<PasswordResetResponseModel, AlertMessage>) in
            switch res {
            case .success(let response):
                handler(response, nil)
            case .failure(let message):
                handler(nil, message)
            }
        }
    }
}

