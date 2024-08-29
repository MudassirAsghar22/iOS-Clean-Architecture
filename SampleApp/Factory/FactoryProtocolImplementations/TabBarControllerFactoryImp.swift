//
//  TabBarControllerFactoryImp.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import Foundation

extension DependencyContainer: TabBarControllerFactory {
    func instantiateHomeViewController() -> HomeVC {
        let controller = ViewControllerUtils.getViewController(viewController: .home,
                                                                         fromStoryBoard: .main) as? HomeVC
        controller?.viewModel = HomeViewModel(model: HomeModel(), networkService: self.homeNetworkService, delegate: controller!)
        return controller!
    }
    
    func instantiateNotificationsViewController() -> NotificationsInboxVC {
        let controller = ViewControllerUtils.getViewController(viewController: .notificationsInbox,
                                                                         fromStoryBoard: .main) as? NotificationsInboxVC
        controller?.viewModel = NotificationsInboxViewModel(networkService: self.notificationsInboxNetworkService, delegate: controller!)
        return controller!
    }
    
    func instantiateMoreViewController() -> MoreVC {
        let controller = ViewControllerUtils.getViewController(viewController: .more,
                                                                         fromStoryBoard: .main) as? MoreVC
        controller?.viewModel = MoreViewModel(delegate: controller!, networkService: self.moreVCNetworkService)
        return controller!
    }

}
