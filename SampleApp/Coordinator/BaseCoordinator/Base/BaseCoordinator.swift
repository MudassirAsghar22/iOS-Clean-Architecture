//
//  BaseCoordinator.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Foundation

class BaseCoordinator: NSObject, Coordinator {

    // MARK: - Vars & Lets
    var childCoordinators = [Coordinator]()

    // MARK: - Public methods
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }

        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    // MARK: - Coordinator
    func start() {
        start(withNotification: nil)
    }

    func start(withNotification option: [AnyHashable : Any]?) {}
}

