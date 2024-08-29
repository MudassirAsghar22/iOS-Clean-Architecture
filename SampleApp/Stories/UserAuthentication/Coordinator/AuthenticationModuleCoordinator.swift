//
//  AuthenticationModuleCoordinator.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Foundation

final class AuthenticationModuleCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput
    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets
    private let router: RouterProtocol
    private let factory: Factory

    // MARK: - Init
    init(router: RouterProtocol, factory: Factory) {
        self.router = router
        self.factory = factory
    }

    // MARK: - Coordinator
    override func start() {
        runFlow()
    }

    // MARK: - Private methods
    // MARK: - Login
    private func runFlow() {
        let controller = self.factory.instantiateLoginViewController()

        controller.onMoveToHome = { [self] in
            self.setupBottomTabVeiwController()
        }

        controller.onMoveToForgotPwd = { () in
            self.moveToForgetPasswordVC()
        }

        self.router.setRootModule(controller, hideBar: true)
    }

    // MARK: - ForgetPassword
    private func moveToForgetPasswordVC() {
        let controller = self.factory.instantiateForgetPasswordViewController()

        controller.onBack = { [unowned self] in
            self.router.popModule(transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
        }

        controller.onMoveToVerifyCode = { (_ email: String) in
            self.moveToVerifyResetPasswordVC(email: email)
        }

        self.router.push(controller, transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
    }

    // MARK: - VerifyResetPasswordVC
    private func moveToVerifyResetPasswordVC(email: String) {
        let controller = self.factory.instantiateVerifyResetPasswordOtpViewController(email: email)

        controller.onBack = { [unowned self] in
            self.router.popModule(transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
        }

        controller.onMoveToResetPasswordVC = { (_ email: String) in
            self.moveToResetPasswordVC(email: email)
        }

        self.router.push(controller, transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
    }

    // MARK: - ResetPasswordVC
    private func moveToResetPasswordVC(email: String) {            
        let controller = self.factory.instantiateResetPasswordViewController(email: email)

        controller.onBack = { [unowned self] in
            self.router.popModule(transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
            self.router.popModule(transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
        }

        controller.onMoveToLoginVC = { [unowned self] in
            self.runFlow()
        }

        self.router.push(controller, transition: FadeAnimator(animationDuration: 0.5, isPresenting: true), animated: true)
    }

    // MARK: - SetupTabVC
    private func setupBottomTabVeiwController() {
        // Initiatlise Side Menu and show Dashboard
        let coordinator = self.factory.instantiateTabBarCoordinator(router: self.router)
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency((coordinator))
            self.runFlow()
        }
        self.addDependency(coordinator)
        coordinator.start(withNotification: nil)
    }
}
