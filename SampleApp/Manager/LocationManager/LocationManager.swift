//
//  LocationManager.swift
//  Sample App
//
//  Created by Mudassir Asghar on 13/05/2024.
//

import UIKit
import CoreLocation
import MapKit
import UserNotifications

protocol LocationManagerDelegate: AnyObject {
    //func updatedLocation(location : CLLocation) -> Void
//    func didEnterRegion() -> Void
//    func didExitRegion() -> Void
//    func updatedAddress(address: String) -> Void
    func showLocationPermissionDialog(status: Int) -> Void
    func didUpdateLocation(location: CLLocation) -> Void
}


// optinal functions
extension LocationManagerDelegate {
    func showLocationPermissionDialog(status: Int) -> Void { }

}

class LocationManager: NSObject , CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter?
    var currentLocation: CLLocation?
    static let shared = LocationManager()
    lazy var geocoder = CLGeocoder()
    weak var delegate: LocationManagerDelegate?

    func setup(del: LocationManagerDelegate?) {
        self.locationManager = CLLocationManager()
        PermissionsManager.shared.requestAccess(permission: .location) { isAllowed in
            if isAllowed {
                self.setupLocationManager()
                self.startLocationUpdate()
            } else {
                // Alert is shown through permission manager already.
            }
        }
        self.delegate = del
    }

    func startLocationUpdate() {
        if isLocationServiceEnabled() {
            if self.isLocationAuthorized() {
                locationManager?.startUpdatingLocation()
            }
        }
    }

    func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            return true
        } else {
            // Show alert letting the user know they have to turn this on.
             self.delegate?.showLocationPermissionDialog(status: 2)
            return false
        }
    }

    func isLocationAuthorized() -> Bool {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager!.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            return true
        case .denied:
            // I'm sorry - I can't show location. User has not authorized it
            self.delegate?.showLocationPermissionDialog(status: 0)
            return false
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            return true
        case .restricted:
            // Access to Location Services is Restricted", message: "Parental Controls or a system administrator may be limiting your access to location services. Ask them to.
            self.delegate?.showLocationPermissionDialog(status: 1)
            return false
        @unknown default:
            print("Unknown permission status")
            return false
        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
             locationManager?.startUpdatingLocation()
             locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            // The user denied authorization
        }

    }

    func setupLocationManager() {
        locationManager?.delegate = self
        // locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
       // CLLocationManager.significantLocationChangeMonitoringAvailable()

    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {

        print("The monitored regions are: \(manager.monitoredRegions)")

    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {

    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {

    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?,
                         withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location services failed with error:  \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            self.currentLocation = location
            self.delegate?.didUpdateLocation(location: location)
        }
    }

    func stopUpdateLocationAndDismissDelegates() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
        self.delegate = nil
    }

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
//            if let placemarks = placemarks, let placemark = placemarks.first {
//
//                if let del = delegate {
//                   // del.updatedAddress(address: placemark.compactAddress!)
//                }
//            } else {
//                print("No Matching Addresses Found")
//            }
        }

    }

    func stopLocationUpdates() {
        locationManager?.stopUpdatingLocation()
    }

    // Get the location Address when dragging the annotation
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }

    }

    func geocode(address: String, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().geocodeAddressString(address){ completion($0?.first, $1) }

//        { (placemarks, error) in
//                guard
//                    let placemarks = placemarks,
//                    let location = placemarks.first?.location
//                else {
//                    // handle no location found
//                    return
//                }
//
//                // Use your location
//            }
    }

}

extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

            //            if let street = thoroughfare {
            //                result += ", \(street)"
            //            }

            if let city = locality {
                result += ", \(city)"
            }

            //            if let country = country {
            //                result += ", \(country)"
            //            }

            return result
        }
        return nil
    }
}
