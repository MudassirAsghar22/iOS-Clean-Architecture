//
//  TabBarControllerFactory.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import Foundation


// MARK: - TabBarController
protocol TabBarControllerFactory {
    func instantiateHomeViewController() -> HomeVC
    func instantiateNotificationsViewController() -> NotificationsInboxVC
    func instantiateMoreViewController() -> MoreVC
}
