//
//  LocationService.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 09/10/2022.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didEnterIntoRegion(region: CLRegion)
    func didExitIntoRegion(region: CLRegion)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

class LocationService: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager
    var lastLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?

    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setDelegate(_ delegate: LocationServiceDelegate) {
        self.delegate = delegate
    }

    func startUpdatingLocation() {
        print("Starting Location")
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        print("Stop Location")
        self.locationManager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined, .denied, .restricted:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManager(manager, didChangeAuthorization: status)
    }

    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location

        // use for real time update location
        updateLocation(currentLocation: location)
    }

    public func startMonitoringFor(region: CLRegion) {
        self.locationManager.startMonitoring(for: region)
    }

    public func stopMonitoringFor(region: CLRegion) {
        self.locationManager.stopMonitoring(for: region)
    }

    private func updateLocation(currentLocation: CLLocation) {
        // Implement to listen live location
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.didExitIntoRegion(region: region)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegate?.didEnterIntoRegion(region: region)
    }
}

extension CLLocationManager {
    // Check if location access granted
    func hasLocationPermission() -> Bool {
        if self.authorizationStatus != .authorizedWhenInUse && self.authorizationStatus != .authorizedAlways { return false }
        return true
    }
}
