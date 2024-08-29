//
//  HomeModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 21/05/2024.
//

import Foundation

struct HomeModel {
    
}

struct GetShiftCountsParam: UserIdPostModel {
    var user_id: String

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
    }

    init(user_id: String) {
        self.user_id = user_id
    }
}
