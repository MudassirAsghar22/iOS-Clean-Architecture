//
//  UserIdPostModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 24/06/2024.
//

import Foundation

protocol UserIdPostModel: DictionaryEncodable {
    var user_id: String { get set }
}
