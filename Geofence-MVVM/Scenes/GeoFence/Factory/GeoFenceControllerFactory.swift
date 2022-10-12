//
//  GeoFenceFactory.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import Foundation

protocol GeoFenceControllerDelegate: AnyObject {
    func addRegion(_ region: RegionObject)
    func wifiConnected(_ hotspot: HotSpot)
    func disconnectWifi()
}

protocol GeoFenceControllerFactory {
    func makeViewController() -> GeoFenceViewController
    func makeGeoFenceViewModel() -> GeoFenceViewModel
    func makeGeoFenceDataSource() -> RegionDataSource
    func makeLocationService() -> LocationService
}

class GeoFenceDependencyContainer: GeoFenceControllerFactory {
    func makeViewController() -> GeoFenceViewController {
        GeoFenceViewController(factory: self)
    }

    func makeGeoFenceViewModel() -> GeoFenceViewModel {
        GeoFenceViewModel(makeGeoFenceDataSource(), makeFenceDetectorService())
    }

    func makeGeoFenceDataSource() -> RegionDataSource {
        RegionDataSource()
    }

    func makeFenceDetectorService() -> GeoFenceDetectorService {
        GeoFenceDetectorService()
    }

    func makeLocationService() -> LocationService {
        LocationService()
    }
}
