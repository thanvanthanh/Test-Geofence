//
//  MockWifiListViewModelDelegate.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import Foundation
@testable import Geofence_MVVM

class MockWifiListViewModelDelegate: WifiListViewModelDelegate {
    var count = 0
    func networkListLoaded(_ hotspots: [HotSpot]) {
        count = hotspots.count
    }
}
