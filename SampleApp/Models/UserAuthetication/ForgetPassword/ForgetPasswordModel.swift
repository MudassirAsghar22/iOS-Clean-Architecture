//
//  ForgetPasswordModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import Foundation

struct ForgetPasswordModel: DictionaryEncodable {

    let email: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
    }

    init(email: String) {
        self.email = email
    }
}

struct PasswordResetResponseModel: Codable {
    let status: Bool?
    let success_message: String?
    let error_message: String?

    enum CodingKeys : String, CodingKey {
        case status = "status"
        case success_message = "success_message"
        case error_message = "error_message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        success_message = try values.decodeIfPresent(String.self, forKey: .success_message)
        error_message = try values.decodeIfPresent(String.self, forKey: .error_message)
    }
}
