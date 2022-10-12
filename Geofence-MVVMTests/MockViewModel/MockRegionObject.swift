//
//  MockRegionObject.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Geofence_MVVM


let mockCoordinates = Coordinates(id: String().randomString(length: 3), latitude: 21.023966, longitude: 105.790223)
let mockNetwork = HotSpot(id: String().randomString(length: 3), name: "TestNetwork", radius: 100)
let mockRegion = RegionObject.init(id: String().randomString(length: 3), title: "Petronus TTDI", radius: 300, coordinates: mockCoordinates, network: mockNetwork)

let mockRegionObjects = [mockRegion, mockRegion, mockRegion]
