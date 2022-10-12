//
//  MockGeoFenceViewModelDelegates.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import Foundation
@testable import Geofence_MVVM

class MockGeoFenceViewModelDelegates: GeoFenceViewModelDelegate {

    var regions: [RegionObject]? = [] // 1
    var hotspots: [HotSpot] = []
    var saveStatus: Bool = false

    func reloadData(_ regions: [RegionObject]) {
        self.regions = regions
    }

    func networkListLoaded(_ hotspots: [HotSpot]) {
        self.hotspots = hotspots
    }

    func stopMonitoringRegion(_ region: RegionObject) {

    }

    func showError(_ error: String) {

    }

    func savedResult(_ status: Bool) {
        self.saveStatus = status
    }
}

