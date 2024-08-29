//
//  LaunchInstructor.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Foundation

enum LaunchInstructor {

    case auth
    case main

    // MARK: - Public methods
    static func configure(isAuthorized: Bool = false, isThroughNotification: Bool = false) -> LaunchInstructor {

        let isAuthorized = isAuthorized
        let isThroughNotification = isThroughNotification

//        if AuthUserDefaultsServices.shared().getToken() != nil {
//            isAutorized = true
//            tutorialWasShown = true
//        }

        switch (isThroughNotification, isAuthorized) {
            case (true, false), (false, false): return .auth
        default: return .main
        }
    }
}
