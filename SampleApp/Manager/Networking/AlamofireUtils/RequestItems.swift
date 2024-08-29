//
//  RequestItems.swift
//  Sample App
//
//  Created by Mudassir Asghar on 06/05/2024.
//

import Alamofire
import SwiftKeychainWrapper

// MARK: - ServerFlags

enum NetworkEnvironment {
    case development
    case production
}

enum RequestItemsType: Equatable {

    // MARK: Authentication
    case login
    case logout
    case send_otp
    case verify_otp
    case reset_password

    // MARK: - Home Screen

    // MARK: Notifications
    case fetch_all_notifications
}

// MARK: - Extensions
// MARK: - EndPointType
extension RequestItemsType: EndPointType {
    // MARK: - Vars & Lets
    var baseURL: String {
        switch APIManager.networkEnviroment {
        case .development: return "https://dummyjson.com"
        case .production: return "https://dummyjson.com"
        }
    }
    //    var base_url: String = ""
    var version: String {
        return "/v0_1"
    }
    var path: String {
        switch self {
            // MARK: Authentication
        case .login:
            return "/auth/login"
        case .logout:
            return "/auth/logout"
        case .send_otp:
            return "/api/send_otp"
        case .verify_otp:
            return "/api/verify_otp"
        case .reset_password:
            return "/api/reset_password"

        // MARK: - Notifications
        case .fetch_all_notifications:
            return "/api/fetch_all_notifications"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {

            // MARK: Delete

            // MARK: Put

            // MARK: Get

            // MARK: Post
        default:
            return .post
        }
    }
    var headers: HTTPHeaders? {
        switch self {
        case .login:
            return ["Accept": "application/json"]
        default:
            return ["Accept": "application/json",
                    "x-api-key": "\(DataCacheManager.shared.getTokenFromKeychain() ?? "")"]
        }
    }
    public var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.prettyPrinted
        }
    }
}
