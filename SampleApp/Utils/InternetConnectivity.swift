//
//  InternetConnectivity.swift
//  Sample App
//
//  Created by Mudassir Asghar on 14/05/2024.
//

import Foundation
import Alamofire

class InternetConnectivity {

    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    class func connectedTo() -> String {
        var connectionType = "unknown"

        if (NetworkReachabilityManager()?.isReachable ?? false) {
            if ((NetworkReachabilityManager()?.isReachableOnCellular) != nil) {
                connectionType = "onCellular"
            } else if ((NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi) != nil) {
                connectionType = "OnEthernetOrWiFi"
            }
        }
        return connectionType

    }

    class  func isVpnActive() -> Bool {
        let vpnProtocolsKeysIdentifiers = [
            "tap", "tun", "ppp", "ipsec", "utun"
        ]
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
              let allKeys = keys.allKeys as? [String] else { return false }

        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
            where key.starts(with: protocolId) {
                // I use start(with:), so I can cover also `ipsec4`, `ppp0`, `utun0` etc...
                return true
            }
        }
        return false
    }

}

