//
//  LoginModel.swift
//  Sample App
//
//  Created by Mudassir Asghar on 13/05/2024.
//

import Foundation

struct LoginModel {
    var data: LoginResponse?
    var isRememberMeEnabled = false

}

struct LoginPostParams: DictionaryEncodable {

    var username: String? = nil
    var password: String? = nil
    var remember_me: Bool? = nil
    var device_type: String? = "iOS"
    var device_id: String? = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case username = "user_name"
        case password = "password"
        case remember_me = "remember_me"
        case device_type = "device_type"
        case device_id = "device_id"
    }

    init() {

    }

    init(username: String, password: String, remember_me: Bool) {
        self.username = username
        self.password = password
        self.remember_me = remember_me
    }
}

struct LoginResponse: Codable {
    let status: Bool?
    let accessToken: String?
    let userProfile: UserProfile?
    let error_message: String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case accessToken = "access_token"
        case userProfile = "user_profile"
        case error_message = "error_message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        userProfile = try values.decodeIfPresent(UserProfile.self, forKey: .userProfile)
        error_message = try values.decodeIfPresent(String.self, forKey: .error_message)
    }

}

class UserProfile: NSObject, Codable, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
           return true
    }

    var user_id : String?
    var employee_no : String?
    var user_name : String?
    var initial : String?
    var title : String?
    var first_name : String?
    var last_name : String?
    var cell : String?
    var email : String?
    var department : String?
    var billing_code : String?
    var office : String?

    enum CodingKeys: String, CodingKey {

        case user_id = "user_id"
        case employee_no = "employee_no"
        case user_name = "user_name"
        case initial = "initial"
        case title = "title"
        case first_name = "first_name"
        case last_name = "last_name"
        case cell = "cell"
        case email = "email"
        case department = "department"
        case billing_code = "billing_code"
        case office = "office"
    }

    init(user_id: String? = nil,
         employee_no: String? = nil,
         user_name: String? = nil,
         initial: String? = nil,
         title : String? = nil,
         first_name: String? = nil,
         last_name: String? = nil,
         cell: String? = nil,
         email: String? = nil,
         department: String? = nil,
         billing_code: String? = nil,
         office: String? = nil) {

        self.user_id = user_id
        self.employee_no = employee_no
        self.user_name = user_name
        self.initial = initial
        self.title = title
        self.first_name = first_name
        self.last_name = last_name
        self.cell = cell
        self.email = email
        self.department = department
        self.billing_code = billing_code
        self.office = office

    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        employee_no = try values.decodeIfPresent(String.self, forKey: .employee_no)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        initial = try values.decodeIfPresent(String.self, forKey: .initial)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        cell = try values.decodeIfPresent(String.self, forKey: .cell)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        billing_code = try values.decodeIfPresent(String.self, forKey: .billing_code)
        office = try values.decodeIfPresent(String.self, forKey: .office)
    }

    required convenience init?(coder: NSCoder) {
        let user_id : String?  = coder.decodeObject(forKey: "user_id") as? String
        let employee_no : String? = coder.decodeObject(forKey: "employee_no") as? String
        let user_name : String? = coder.decodeObject(forKey: "user_name") as? String
        let initial : String? = coder.decodeObject(forKey: "initial") as? String
        let title : String? = coder.decodeObject(forKey: "title") as? String
        let first_name : String? = coder.decodeObject(forKey: "first_name") as? String
        let last_name : String? = coder.decodeObject(forKey: "last_name") as? String
        let cell : String? = coder.decodeObject(forKey: "cell") as? String
        let email : String? = coder.decodeObject(forKey: "email") as? String
        let department : String? = coder.decodeObject(forKey: "department") as? String
        let billing_code : String? = coder.decodeObject(forKey: "billing_code") as? String
        let office : String? = coder.decodeObject(forKey: "office") as? String



        self.init(user_id: user_id,
                  employee_no: employee_no,
                  user_name: user_name,
                  initial: initial,
                  title : title,
                  first_name: first_name,
                  last_name: last_name,
                  cell: cell,
                  email: email,
                  department: department,
                  billing_code: billing_code,
                  office: office)

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(employee_no, forKey: "employee_no")
        aCoder.encode(user_name, forKey: "user_name")
        aCoder.encode(initial, forKey: "initial")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(cell, forKey: "cell")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(department, forKey: "department")
        aCoder.encode(billing_code, forKey: "billing_code")
        aCoder.encode(office, forKey: "office")
    }

    func dispose() {
        user_id = nil
            employee_no = nil
            user_name = nil
            initial = nil
            title = nil
            first_name = nil
            last_name = nil
            cell = nil
            email = nil
            department = nil
            billing_code = nil
            office = nil
    }

}
