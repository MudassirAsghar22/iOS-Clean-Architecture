//
//  Coordinator.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
    func start(withNotification option: [AnyHashable : Any]?)
}

// MARK: - CoordinatorType
/// Using this structure we can define what type of flow we can use in-app.
enum CoordinatorType {
    case app, login, tab
}
