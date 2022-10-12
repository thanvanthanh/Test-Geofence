//
//  MockGeofenceDetecterDelegate.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import Foundation
@testable import Geofence_MVVM

class MockGeoFenceDetectorDelegates: GeoFenceDetectorServiceDelegate {

    var isConnectedToWifi: Bool = false
    var isDisconnectedToWifi: Bool = false
    var isEnteredInRegion: Bool = false
    var isExitedRegion: Bool = false

    func didEnteredRegion(_ name: String) {
        isEnteredInRegion = true
    }

    func didExitRegion(_ name: String) {
        isExitedRegion = true
    }

    func connectedToWifi(_ networkName: String) {
        isConnectedToWifi = true
    }

    func wifiDisconnected() {
        isDisconnectedToWifi = true
    }
}
