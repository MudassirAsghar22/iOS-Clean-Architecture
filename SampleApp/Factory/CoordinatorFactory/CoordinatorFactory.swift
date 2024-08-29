//
//  CoordinatorFactory.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    // MARK: - instantiateApplicationCoordinator
    func instantiateApplicationCoordinator() -> ApplicationCoordinator
    // MARK: - instantiateAuthenticationModuleCoordinator
    func instantiateAuthenticationModuleCoordinator(router: RouterProtocol) -> AuthenticationModuleCoordinator
    
    // MARK: - instantiateTabBarCoordinator
    func instantiateTabBarCoordinator(router: RouterProtocol) -> TabBarCoordinator

}
