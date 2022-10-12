//
//  GeoFenceViewModel.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 09/10/2022.
//

import Foundation
import CoreLocation

protocol GeoFenceViewModelDelegate: AnyObject {
    func reloadData(_ regions: [RegionObject])
    func networkListLoaded(_ hotspots: [HotSpot])
    func stopMonitoringRegion(_ region: RegionObject)
    func showError(_ error: String)
    func savedResult(_ status: Bool)
}

class GeoFenceViewModel {

    private var dataSource: RegionDataSourceProtocol
    private var fenceDetector: GeoFenceDetectorService
    private var regions: [RegionObject] = []
    weak var delegate: GeoFenceViewModelDelegate?

    // Injecting datasource and fence detector service
    internal init(_ dataSource: RegionDataSourceProtocol,
                  _ fenceDetector: GeoFenceDetectorService) {
        self.dataSource = dataSource
        self.fenceDetector = fenceDetector
    }

    // Setting delegate to fence detector service
    public func setDetectorDelegate(delegate: GeoFenceDetectorServiceDelegate?) {
        self.fenceDetector.setDelegate(delegate: delegate)
    }

    // Access network list
    public func loadNetworkList() {
        let hotspots = regions.map(\.network)
        self.delegate?.networkListLoaded(hotspots)
    }

    // Delete region based on annotation object
    public func deleteRegion(_ annotation: RegionAnnotation) {
        if let index = self.regions.firstIndex(where: { $0.id == annotation.regionId }) {
            delegate?.stopMonitoringRegion(self.regions[index])
            regions.remove(at: index)
            saveAllRegion()
        }
    }

    // Connect Wifi to fence detector service
    func connectWifi(_ hotspot: HotSpot) {
        if let regionObject = self.regions.first(where: { $0.network == hotspot }) {
            fenceDetector.setCurrentWifi(regionObject, hotspot)
        }
    }

    // Disconnect Wifi to fence detector service
    func disconnectWifi() {
        fenceDetector.disconnectWifi()
    }

    // About region entry for fence detector service
    func didEnterRegion(_ identifier: String) {
        if let regionObject = self.regions.first(where: { $0.id == identifier }) {
            fenceDetector.setCurrentRegion(regionObject)
        }
    }

    // About region exit for fence detector service
    func didExitRegion(_ identifier: String) {
        fenceDetector.exitedRegion()
    }

    //  Add new region object
    public func saveRegionData(_ region: RegionObject) {
        self.regions.append(region)
        dataSource.saveAllRegions(regions) { (results) in
            switch results {
            case .success(let status):
                self.delegate?.savedResult(status)
            case .failure(let error):
                self.delegate?.showError(error.message)
            }
        }
    }

    //  Save all the regions
    public func saveAllRegion() {
        dataSource.saveAllRegions(regions) { (results) in
            switch results {
            case .success(let status):
                self.delegate?.savedResult(status)
            case .failure(let error):
                self.delegate?.showError(error.message)
            }
        }
    }

    // Load all the regions and trigger respective delegate
    public func loadRegions() {
        dataSource.loadAllRegions { (result) in
            switch result {
            case .success(let results):
                self.regions = results
                self.delegate?.reloadData(self.regions)
            case .failure(let error):
                self.delegate?.showError(error.message)
            }
        }
    }
}
