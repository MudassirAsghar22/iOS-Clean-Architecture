//
//  PermissionsManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 13/05/2024.
//

import UIKit
import Photos
import EventKit
import AVFoundation

enum Permission {
    case notifications
    case cameraUsage
    case photoLibraryUsage
    case location

}

class PermissionsManager {
    private init() {}
    public static let shared = PermissionsManager()

    fileprivate let NOTIFICATIONS: String = "Require_access_Push_Notifications_msg".localized
    fileprivate let PHOTO_LIBRARY_PERMISSION: String = "Require_access_to_Photo_library_msg".localized
    fileprivate let CAMERA_USAGE_PERMISSION: String = "Require_access_to_Camera_msg".localized
    fileprivate let LOCATION_PERMISSION: String = "Require_access_to_location_msg".localized

    func requestAccess(permission: Permission,
                       completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch permission {

        case .notifications:
            UNUserNotificationCenter.current().getNotificationSettings() { (settings) in
                switch settings.authorizationStatus {
                case .authorized:
                    completionHandler(true)
                    // we can show a custom view here to make sure permissions allowed.
                case .denied:
                    self.showSettingsAlert(msg: self.NOTIFICATIONS, completionHandler)
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if granted {
                            completionHandler(true)
                        } else {
                            self.showSettingsAlert(msg: self.NOTIFICATIONS, completionHandler)
                        }
                    }
                default:
                    self.showSettingsAlert(msg: self.NOTIFICATIONS, completionHandler)
                }
            }

        case .cameraUsage: // Camera
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                completionHandler(true)
            case .denied:
                self.showSettingsAlert(msg: self.CAMERA_USAGE_PERMISSION, completionHandler)
            case .restricted, .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        completionHandler(true)
                    } else {
                        self.showSettingsAlert(msg: self.CAMERA_USAGE_PERMISSION, completionHandler)
                    }
                }
            @unknown default: break
            }
        case .photoLibraryUsage: // Photo library
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                completionHandler(true)
            case .denied:
                self.showSettingsAlert(msg: self.PHOTO_LIBRARY_PERMISSION, completionHandler)
            case .restricted, .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        completionHandler(true)
                    } else {
                        self.showSettingsAlert(msg: self.PHOTO_LIBRARY_PERMISSION, completionHandler)
                    }
                }
            default:
                self.showSettingsAlert(msg: self.PHOTO_LIBRARY_PERMISSION, completionHandler)
            }
        case .location:
            if CLLocationManager.locationServicesEnabled() {
                let authorizationStatus: CLAuthorizationStatus
                
                authorizationStatus = LocationManager.shared.locationManager!.authorizationStatus

                switch authorizationStatus {
                case  .denied:
                    print("Location permission denied")
                    self.showSettingsAlert(msg: self.LOCATION_PERMISSION, completionHandler)
                case .notDetermined, .restricted:
                    print("Location permission restricted or not determined")
                    LocationManager.shared.locationManager?.requestWhenInUseAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Location permission allowed")
                    completionHandler(true)
                @unknown default:
                    self.showSettingsAlert(msg: self.LOCATION_PERMISSION, completionHandler)
                }
            } else {
                self.showSettingsAlert(msg: "Seems_location_services_turned_off_msg".localized, completionHandler)
            }
        }
    }

    private func showSettingsAlert(msg: String,
                                   _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open_Settings".localized, style: .default) { _ in
                completionHandler(false)
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel) { _ in
                completionHandler(false)
            })
            appDelegate?.window?.makeKeyAndVisible()
            appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)

        }

    }

}

