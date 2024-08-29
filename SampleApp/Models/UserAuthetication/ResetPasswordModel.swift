//
//  ResetPasswordModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 17/05/2024.
//

import Foundation

struct ResetPasswordUploadModel: DictionaryEncodable {

    let email: String
    let password: String
    let confirm_password: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case confirm_password = "confirm_password"
    }

    init(email: String, password: String, confirm_password: String) {
        self.email = email
        self.password = password
        self.confirm_password = confirm_password
    }
}

struct ResetPasswordModel {
    var code = ""
    var email = ""
}
