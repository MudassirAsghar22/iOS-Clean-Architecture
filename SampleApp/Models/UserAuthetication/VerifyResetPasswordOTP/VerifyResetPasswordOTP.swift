//
//  VerifyResetPasswordPostModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 15/05/2024.
//

import Foundation

struct VerifyResetPasswordPostModel: DictionaryEncodable {

    let email: String
    let otp: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case otp = "otp"
    }

    init(email: String, otp: String) {
        self.email = email
        self.otp = otp
    }
}

struct VerifyResetPasswordResponseModel: Codable {
    let code_status: Int?
    let phone: String?
    let message: String?
    let verification_code: Int?
    let name: String?
    let error: String?

    enum CodingKeys : String, CodingKey {
        case code_status = "code_status"
        case phone = "phone"
        case message = "message"
        case verification_code = "verification_code"
        case name = "name"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code_status = try values.decodeIfPresent(Int.self, forKey: .code_status)
        do {
            phone = try values.decodeIfPresent(String.self, forKey: .phone)
        } catch DecodingError.typeMismatch {
            if let tempPhone = try values.decodeIfPresent(Int.self, forKey: .phone) {
                phone = String(tempPhone)
            } else {
                phone = nil
            }
        }
        message = try values.decodeIfPresent(String.self, forKey: .message)
        verification_code = try values.decodeIfPresent(Int.self, forKey: .verification_code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }
}
