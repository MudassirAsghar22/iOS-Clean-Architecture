//
//  NotificationsInboxModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 05/06/2024.
//

import Foundation

struct NotificationsInboxModel {
    var datasource: [NotificationData]?
    var page_no: Int = -1
    var is_last_page: Int?

    func getIsLastPage() -> Bool {
        return is_last_page == 1
    }
}

struct MarkNotificationModel: DictionaryEncodable {
    var user_id: String
    var notification_id: String?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case notification_id = "notification_id"
        case type = "type"
    }

    init(user_id: String, notification_id: String?, type: String?) {
        self.user_id = user_id
        self.notification_id = notification_id
        self.type = type
    }
}

struct FetchNotificationModel: UserIdPostModel {
    var user_id: String
    var page_no: Int

    enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case page_no = "page_no"
    }

    init(user_id: String, page_no: Int) {
        self.user_id = user_id
        self.page_no = page_no
    }
}

struct NotificationInboxResponse: Codable {
    let status: Bool?
    let notifications: [NotificationData]?
    let success_message: String?
    let error_message: String?
    let is_last_page: Int?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case notifications = "data"
        case success_message = "success_message"
        case error_message = "error_message"
        case is_last_page = "is_last_page"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        notifications = try values.decodeIfPresent([NotificationData].self, forKey: .notifications)
        success_message = try values.decodeIfPresent(String.self, forKey: .success_message)
        error_message = try values.decodeIfPresent(String.self, forKey: .error_message)
        is_last_page = try values.decodeIfPresent(Int.self, forKey: .is_last_page)
    }

}

struct NotificationData: Codable {
    let id : String?
    let title : String?
    let message : String?
    let type : String?
    let user_id : String?
    let is_read : String?
    let key_id : String?
    let sender_id : String?
    let created_at : String?
    let is_delete : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case message = "message"
        case type = "type"
        case user_id = "user_id"
        case is_read = "is_read"
        case key_id = "key_id"
        case sender_id = "sender_id"
        case created_at = "created_at"
        case is_delete = "is_delete"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        is_read = try values.decodeIfPresent(String.self, forKey: .is_read)
        key_id = try values.decodeIfPresent(String.self, forKey: .key_id)
        sender_id = try values.decodeIfPresent(String.self, forKey: .sender_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        is_delete = try values.decodeIfPresent(String.self, forKey: .is_delete)
    }

    func getIsRead() -> Bool {
        return is_read == "1"
    }

}
