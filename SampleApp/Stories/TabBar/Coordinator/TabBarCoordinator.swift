//
//  TabBarCoordinator.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import UIKit

enum TabBarPage {
    case home
    case notifications
    case more

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .notifications
        default:
            self = .more
        }
    }

    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "home".localized
        case .notifications:
            return "notifications".localized
        default:
            return "more".localized
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .notifications:
            return 1
        default:
            return 2
        }
    }

    // Add tab icon value
    func pageIcon() -> UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house")!
        case .notifications:
            return UIImage(systemName: "bell.badge")!
        default:
            return  UIImage(systemName: "ellipsis.circle.fill")!
        }
    }

    // Add tab icon selected / deselected color

    // etc
}


protocol TabCoordinatorProtocol: BaseCoordinator {
    var tabBarController: UITabBarController { get set }

    func selectPage(_ page: TabBarPage)

    func setSelectedIndex(_ index: Int)

    func currentPage() -> TabBarPage?
}

final class TabBarCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    //    var childCoordinators = [Coordinator]()
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }

    // MARK: - CoordinatorFinishOutput
    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets
    private let router: Router
    private let factory: Factory

    // MARK: - Init
    init(router: RouterProtocol, factory: Factory) {
        self.router = router as! Router
        self.factory = factory
        self.tabBarController = .init()
    }

    // MARK: - Coordinator
    override func start(withNotification option: [AnyHashable : Any]?) {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .notifications, .more]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })

        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })

        prepareTabBarController(withTabControllers: controllers)
        if let payload = option {
            self.runNotificationFlow(payload: payload)
        }
    }

    func runNotificationFlow(payload: [AnyHashable : Any]) {
        guard let payloadData: PushNotificationPayload = DataParserManager.shared.parsePushNotifDataIntoModel(payload: payload) else { return }

        switch payloadData.type {
        case Constants.ServerFlags.PushNotificationTypes.notification_home.rawValue:
            self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        default:
            print("invalid type")
        }

    }

    // MARK: - Private methods
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self

        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        /// Styling
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.barTintColor = Colors.theme  // Change this to your desired color
        tabBarController.tabBar.tintColor = .theme    // Optional: change the item selected color
        tabBarController.tabBar.unselectedItemTintColor = .gray
        self.router.setRootModule(tabBarController, hideBar: true)
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {

        /// In this step, we attach tabBarController to navigation controller associated with this coordanator
        ///
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)

        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.pageIcon(),
                                                     tag: page.pageOrderNumber())

        switch page {
        case .home:
            let homeVC = self.factory.instantiateHomeViewController()
            homeVC.didSendEventClosure = { [weak self] (event: HomeVC.Event) in

            }
            navController.pushViewController(homeVC, animated: false)

        case .notifications:
            let notificationsVC = self.factory.instantiateNotificationsViewController()
            notificationsVC.didSendEventClosure = { [weak self] (event: NotificationsInboxVC.Event) in
                switch event {
                case .moveToHome:
                    self?.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
                }
            }
            navController.pushViewController(notificationsVC, animated: false)

        default:
            let moreVC = self.factory.instantiateMoreViewController()
            moreVC.didSendEventClosure = { [ self] (event: MoreVC.Event) in
                switch event {
                case .moveToLogin:
                    self.showLoginFlow(remoteNotification: nil)
                }
            }
            navController.pushViewController(moreVC, animated: false)

        }
        return navController
    }

    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }

        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    // MARK: - showLoginFlow
    func showLoginFlow(remoteNotification: [AnyHashable : Any]?) {
        self.tabBarController.tabBar.isUserInteractionEnabled = false
        self.finishFlow?()
    }

}

extension TabBarCoordinator: UITabBarControllerDelegate {

}
