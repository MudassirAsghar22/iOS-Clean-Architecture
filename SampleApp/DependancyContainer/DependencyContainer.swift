//
//  DependencyContainer.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import UIKit

typealias ViewControllerFactory = LoginViewControllerFactory &
TabBarControllerFactory &
ForgetPasswordViewControllerFactory &
VerifyResetPasswordOtpViewControllerFactory

typealias Factory = CoordinatorFactoryProtocol &
ViewControllerFactory

class DependencyContainer {

    // MARK: - Vars & Lets
    private var rootController: UINavigationController

    // MARK: App Coordinator
    internal lazy var aplicationCoordinator = self.instantiateApplicationCoordinator()

    // MARK: APi Manager
//    internal lazy var sessionManager = Session()
//    internal lazy var retrier = APIManagerRetrier()
    internal lazy var apiManager = APIManager.shared()
    // MARK: Network services
    internal lazy var loginNetworkService = LoginNetworkServices(apiManager: self.apiManager)
    internal lazy var forgetPasswordNetworkService = ForgetPasswordNetworkService(apiManager: self.apiManager)
    internal lazy var moreVCNetworkService = MoreVCNetworkService(apiManager: self.apiManager)
    internal lazy var verifyResetPasswordNetworkService = VerifyResetPasswordNetworkService(apiManager: self.apiManager)
    internal lazy var resetPasswordNetworkService = ResetPasswordNetworkService(apiManager: self.apiManager)
    internal lazy var homeNetworkService = HomeNetworkService(apiManager: self.apiManager)
    internal lazy var notificationsInboxNetworkService = NotificationsInboxNetworkService(apiManager: self.apiManager)

    // MARK: Cache services
    // internal lazy var dataManager = PRNDataManager.shared
    // MARK: - Public func
    func start() {
        self.aplicationCoordinator.start()
    }

    func start(withNotification: [AnyHashable : Any]?) {
        self.aplicationCoordinator.start(withNotification: withNotification)
    }

    // MARK: - Initialization
    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
}

// MARK: - Extensions
// MARK: - CoordinatorFactoryProtocol

extension DependencyContainer: CoordinatorFactoryProtocol {

    func instantiateApplicationCoordinator() -> ApplicationCoordinator {
        return ApplicationCoordinator(router: Router(rootController: rootController), factory: self as Factory)
    }

    func instantiateAuthenticationModuleCoordinator(router: RouterProtocol) -> AuthenticationModuleCoordinator {
        return AuthenticationModuleCoordinator(router: router, factory: self)
    }

    func instantiateTabBarCoordinator(router: RouterProtocol) -> TabBarCoordinator {
        return TabBarCoordinator(router: router,
                                            factory: self)
    }
}
