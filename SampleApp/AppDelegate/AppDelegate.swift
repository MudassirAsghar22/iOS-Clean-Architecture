//
//  AppDelegate.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundSessionCompletionHandler: (() -> Void)?
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController
    }

    var deepLinkOption: DeepLinkOption?

    private lazy var dependencyConatiner = DependencyContainer(rootController: self.rootController)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Keyboard manager started
        IQKeyboardManager.shared.enable = true
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }

        // App wake up on remote notification
        let launchNotif = (launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]) as? [AnyHashable:Any]
        
        self.dependencyConatiner.start(withNotification: launchNotif)

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        // save unread PNs count
        let notifData = DataParserManager.shared.parsePushNotifDataIntoModel(payload: userInfo)
        if let unreadPNs = notifData?.badge {
            UserDefaultsManager.shared.setCountOfUnreadNotifs(count: unreadPNs)
        }

        // Proceed with notification type
        if application.applicationState == UIApplication.State.active {
            NotificationCenter.default.post(name: Constants.NotificationNames.k_showNotificationBanner, object: nil, userInfo: userInfo)
        } else if application.applicationState == UIApplication.State.inactive {
            self.dependencyConatiner.start(withNotification: userInfo)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession handleEventsForBackgroundURLSessionidentifier: String,
                     completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }

}
extension UIApplication {
    var statusBarUIView: UIView? {

        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {

            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999
            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }
        return nil
    }

}


