//
//  DictionaryEncodable+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/05/2024.
//

import Foundation

protocol DictionaryEncodable: Codable {}

extension DictionaryEncodable {
    func dictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
                return nil
        }
        return dict
    }

    func dictionary() -> [String: String]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: String] else {
                return nil
        }
        return dict
    }
}

