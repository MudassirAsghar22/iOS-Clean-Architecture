//
//  LogoutModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 16/05/2024.
//

import Foundation

struct LogoutModelResponse: Codable {
    let status: Bool?
    let error_message: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case error_message = "error_message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        error_message = try values.decodeIfPresent(String.self, forKey: .error_message)
    }

}
