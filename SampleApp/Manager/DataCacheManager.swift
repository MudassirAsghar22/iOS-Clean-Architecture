//
//  DataManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 07/05/2024.
//

import SwiftKeychainWrapper

final class DataCacheManager {

    var apnsToken = ""
    var build_number = 0
    var currUser = UserProfile()

    static let shared = DataCacheManager()

    private init() {
        apnsToken = ""
    }

    public func setBuildNumber(number: String) {
        build_number = Int(number) ?? 0
    }

    public func getBuildNumber() -> Int {
        return build_number
    }

    public func setAPNsToken(tok: String) {
        apnsToken = tok
    }

    public func getAPNsToken() -> String {
        return apnsToken
    }

    public func setCurrUser(usr: UserProfile) {
        currUser = usr
    }

    public func getCurrUser() -> UserProfile {
        return currUser
    }

    public func dispose() {
        DataCacheManager.shared.currUser.dispose()
        self.removeTokenFromKeyChain()
        UIApplication.shared.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }

    func isLogin() -> Bool {
        return DataCacheManager.shared.getTokenFromKeychain() != nil &&
        UserDefaults.standard.object(forKey: UserDefaultsManager.shared.k_curr_user_data) != nil
    }

    func saveTokenToKeyChain(token: String) {
        let keychain = KeychainWrapper(serviceName: "com.sampleApp")
        keychain.set(token, forKey: Constants.KeychainWrapperKeys.k_access_token, withAccessibility: .always)
    }

    func getTokenFromKeychain() -> String? {
        let keychain = KeychainWrapper(serviceName: "com.sampleApp")
        return keychain.string(forKey: Constants.KeychainWrapperKeys.k_access_token)
    }

    func removeTokenFromKeyChain() {
        let keychain = KeychainWrapper(serviceName: "com.sampleApp")
        keychain.remove(key: Constants.KeychainWrapperKeys.k_access_token)
    }
}
