//
//  DataParserManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 27/06/2024.
//

import Foundation

class DataParserManager: NSObject {

    static let shared = DataParserManager()

    func getIntegerFrom(dict:[String:Any], key: String) -> Int? {
        var returnValue : Int? = nil
        if let str = dict[key] as? String, let intValue = Int(str) {
            returnValue = intValue
        } else if let intValue = dict[key] as? Int {
            returnValue = intValue
        }
        return returnValue

    }

    func getDoubleFrom(dict: [String:Any], key: String) -> Double? {

        var returnValue : Double? = 0.0
        if let str = dict[key] as? String, let doubleValue = Double(str) {
            if (key.elementsEqual("lat")) || (key.elementsEqual("lang")) {
                returnValue = doubleValue
            } else {
                returnValue = doubleValue.rounded(toPlaces: 2)
            }
        } else if let doubleValue = dict[key] as? Double {
            if (key.elementsEqual("lat")) || (key.elementsEqual("lang")) {
                returnValue = doubleValue
            } else {
                returnValue = doubleValue.rounded(toPlaces: 2)
            }
        }
        return returnValue

    }

    func getStringFrom(dict: [String:Any], key: String) -> String? {
        var returnValue : String? = nil
        if let str = dict[key] as? String {
            returnValue = str
        } else if let intValue = dict[key] as? Int {
            returnValue = String(intValue)
        } else if let doubleValue = dict[key] as? Double {
            returnValue = String(doubleValue)
        }
        return returnValue

    }

    func getBooleanFrom(dict:[String:Any], key: String) -> Bool? {
        if let num = getIntegerFrom(dict: dict, key: key) {
            if num > 0 {
                return true
            } else {
                return false
            }
        } else if let num = self.getStringFrom(dict: dict, key: key) {
            if Int(num)! > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }

    }

    func parsePushNotifDataIntoModel(payload: [AnyHashable : Any]) -> PushNotificationPayload? {
        guard let data =  payload["data"] as? [String:Any],
              let aps = payload["aps"] as? [String:Any] else {
            return nil
        }

        let title = DataParserManager.shared.getStringFrom(dict: data, key: "title")
        let body =  DataParserManager.shared.getStringFrom(dict: data, key: "body")
        let key = self.getStringFrom(dict: data, key: "key_id")
        let type = self.getStringFrom(dict: data, key: "type")
        let badge = DataParserManager.shared.getIntegerFrom(dict: aps, key: "badge")

        return PushNotificationPayload(title: title, body: body, type: type, key_id: key, badge: badge)
    }
}
