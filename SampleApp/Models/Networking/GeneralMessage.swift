//
//  GeneralMessage.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import Foundation

struct GeneralMessage : Codable {
    // MARK: - Vars & Lets
    let status : Bool?
    let message : String?
    let success_message : String?
    let error_message : String?

    enum CodingKeys : String, CodingKey {
        case status = "status"
        case message = "message"
        case success_message = "success_message"
        case error_message = "error_message"
    }

    // MARK: - Initialization Decoder
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success_message = try values.decodeIfPresent(String.self, forKey: .success_message)
        error_message = try values.decodeIfPresent(String.self, forKey: .error_message)
    }
}

