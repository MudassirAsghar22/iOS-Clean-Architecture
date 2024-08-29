//
//  PushNotificationPayload.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Foundation

class PushNotificationPayload: NSObject {
    let title: String?
    let body: String?
    let badge: Int?
    let type: String?
    let key_id: String?
    var dfr_no: String? = nil
    var wo_no: String? = nil
    var project_id: String? = nil
    var proposal_number: String? = nil

    init(title: String?,
         body: String?,
         type: String?,
         key_id: String?,
         badge: Int?) {

        self.title = title
        self.body = body
        self.key_id = key_id
        self.type = type
        self.badge = badge
    }

    init(title: String?,
         body: String?,
         type: String?,
         key_id: String?,
         badge: Int?,
         dfr_no: String?,
         wo_no: String?,
         project_id: String?,
         proposal_number: String?) {

        self.title = title
        self.body = body
        self.key_id = key_id
        self.type = type
        self.badge = badge
        self.dfr_no = dfr_no
        self.wo_no = wo_no
        self.project_id = project_id
        self.proposal_number = proposal_number
    }

    init(type: String?) {
        self.type = type
        self.title = nil
        self.body = nil
        self.key_id = nil

        self.badge = nil
        self.dfr_no = nil
        self.wo_no = nil
        self.project_id = nil
        self.proposal_number = nil
    }
}

