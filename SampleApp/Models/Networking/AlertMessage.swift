//
//  AlertMessage.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import Foundation

class AlertMessage : Error {
    // MARK: - Vars & Lets
    var title = ""
    var body = ""

    // MARK: - Intialization
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}
