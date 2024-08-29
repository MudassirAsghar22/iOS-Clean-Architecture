//
//  UserDefaultsManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 07/05/2024.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class UserDefaultsManager: NSObject {

    static let shared = UserDefaultsManager()

    // MARK: UserDefaults keys
    let k_curr_user_data = "currUserData"
    let k_unread_notifications = "unread_notifications"
    let k_privacy_policy_url = "privacy_policy_url"

    let userDefaults: UserDefaults

    // MARK: - Lifecycle
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func saveUserDataToPreferences() {
        do {
            let encodedUserData: Data = try NSKeyedArchiver.archivedData(withRootObject: DataCacheManager.shared.currUser, requiringSecureCoding: true)
            UserDefaults.standard.set(encodedUserData, forKey:
                                        self.k_curr_user_data)
            UserDefaults.standard.synchronize()
        } catch {
            print("User data not saved")
        }
    }

    func getUserDataFromPreferences() {
        do {
        let decoded = UserDefaults.standard.object(forKey: self.k_curr_user_data) as! Data
            guard let decodedUser = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserProfile.self, from: decoded) else {
                DataCacheManager.shared.setCurrUser(usr: UserProfile())
                return
            }
            DataCacheManager.shared.setCurrUser(usr: decodedUser)
        } catch {
            print("User data not fetched")
        }
    }

    func setPrivacyPolicylink(policy_url: String) {
        UserDefaults.standard.set(policy_url, forKey: k_privacy_policy_url)
        UserDefaults.standard.synchronize()
    }

    func getPrivacyPolicylink() -> String? {
        return UserDefaults.standard.string(forKey: k_privacy_policy_url)
    }

    func disposeUserData() {
        UserDefaults.standard.removeObject(forKey: self.k_curr_user_data)
        UserDefaults.standard.removeObject(forKey: self.k_unread_notifications)
        UserDefaults.standard.synchronize()
    }

    func getCountOfUnreadNotifs() -> Int {
        if UserDefaults.standard.object(forKey: self.k_unread_notifications) != nil {
            let decoded = UserDefaults.standard.object(forKey: self.k_unread_notifications) as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Int
        } else {
            return 0
        }
    }

    func setCountOfUnreadNotifs(count: Int) {
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: count, requiringSecureCoding: false) else { return }
        UserDefaults.standard.set(encodedData, forKey: self.k_unread_notifications)
        UserDefaults.standard.synchronize()
        UIApplication.shared.applicationIconBadgeNumber = count
    }

    func decrementCountOfUnreadNotifs() {
        if self.getCountOfUnreadNotifs() > 0 {
            self.setCountOfUnreadNotifs(count: self.getCountOfUnreadNotifs() - 1)
        }
    }
}

//import SwiftData
//extension UserDefaultsManager {
////To drive the data persistent operations, there are two key objects of SwiftData that you should be familiar with: ModelContainer and ModelContext. The ModelContainer serves as the persistent backend for your model types. To create a ModelContainer, you simply need to instantiate an instance of it.
//
//    func getContainer() -> ModelContainer {
//        return try ModelContainer(for: Shift.self, ShiftsContainer.self)
//    }
//
//}
