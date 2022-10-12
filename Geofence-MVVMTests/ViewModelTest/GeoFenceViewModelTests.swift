//
//  GeoFenceViewModelTests.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import XCTest
@testable import Geofence_MVVM

class GeoFenceViewModelTests: XCTestCase {

    func testLoadRegions() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let viewModel = GeoFenceViewModel(datasource, GeoFenceDetectorService())
        viewModel.delegate = mockDelegate
        viewModel.loadRegions()
        let result = try? XCTUnwrap(mockDelegate.regions)
        XCTAssertEqual(result?.count, 3)
    }

    func testSaveAllRegions() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let viewModel = GeoFenceViewModel(datasource, GeoFenceDetectorService())
        viewModel.delegate = mockDelegate
        viewModel.saveAllRegion()
        let result = try? XCTUnwrap(mockDelegate.saveStatus)
        XCTAssertEqual(result, true)
    }

    func testSaveRegion() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let viewModel = GeoFenceViewModel(datasource, GeoFenceDetectorService())
        viewModel.delegate = mockDelegate
        viewModel.saveRegionData(mockRegion)
        let result = try? XCTUnwrap(mockDelegate.saveStatus)
        XCTAssertEqual(result, true)
    }

    func testDeleteRegion() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let viewModel = GeoFenceViewModel(datasource, GeoFenceDetectorService())
        viewModel.delegate = mockDelegate
        viewModel.saveRegionData(mockRegion)
        viewModel.deleteRegion(mockRegion.annotableRegion()!)
        let result = try? XCTUnwrap(mockDelegate.saveStatus)
        XCTAssertEqual(result, true)
    }

    func testloadHotspots() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let viewModel = GeoFenceViewModel(datasource, GeoFenceDetectorService())
        viewModel.delegate = mockDelegate
        viewModel.loadRegions()
        viewModel.loadNetworkList()
        let result = try? XCTUnwrap(mockDelegate.hotspots)
        XCTAssertEqual(result?.count, 3)
    }

    func testConnectWifiAndRegion() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let fenceDetector = GeoFenceDetectorService()
        let viewModel = GeoFenceViewModel(datasource, fenceDetector)
        let mockDetectorDelegate = MockGeoFenceDetectorDelegates()
        
        viewModel.setDetectorDelegate(delegate: mockDetectorDelegate)
        viewModel.delegate = mockDelegate
        viewModel.loadRegions()
        viewModel.connectWifi(mockNetwork)
        
        let wifiConnected = try? XCTUnwrap(mockDetectorDelegate.isConnectedToWifi)
        let regionEntered = try? XCTUnwrap(mockDetectorDelegate.isEnteredInRegion)
        XCTAssert(wifiConnected!)
        XCTAssert(regionEntered!)
    }

    func testDisconnectWifi() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let fenceDetector = GeoFenceDetectorService()
        let viewModel = GeoFenceViewModel(datasource, fenceDetector)

        let mockDetectorDelegate = MockGeoFenceDetectorDelegates()
        viewModel.setDetectorDelegate(delegate: mockDetectorDelegate)
        viewModel.delegate = mockDelegate
        viewModel.loadRegions()
        viewModel.connectWifi(mockNetwork)
        viewModel.disconnectWifi()
        
        let isDisconnectedToWifi = try? XCTUnwrap(mockDetectorDelegate.isDisconnectedToWifi) // 3
        XCTAssert(isDisconnectedToWifi!)
    }

    func testEnterAndExitIntoFence() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let fenceDetector = GeoFenceDetectorService()
        let viewModel = GeoFenceViewModel(datasource, fenceDetector)

        let mockDetectorDelegate = MockGeoFenceDetectorDelegates()
        viewModel.setDetectorDelegate(delegate: mockDetectorDelegate)
        viewModel.delegate = mockDelegate
        viewModel.loadRegions()
        viewModel.didEnterRegion(mockRegion.id)
        viewModel.didExitRegion(mockRegion.id)

        let isEnteredRegion = try? XCTUnwrap(mockDetectorDelegate.isEnteredInRegion)
        let isExitedRegion = try? XCTUnwrap(mockDetectorDelegate.isExitedRegion)
        XCTAssert(isEnteredRegion!)
        XCTAssert(isExitedRegion!)
    }

    func testConnectWifiAndEnterExitFence() {
        let datasource = MockRegionDataSource()
        let mockDelegate = MockGeoFenceViewModelDelegates()
        let fenceDetector = GeoFenceDetectorService()
        let viewModel = GeoFenceViewModel(datasource, fenceDetector)

        let mockDetectorDelegate = MockGeoFenceDetectorDelegates()
        viewModel.setDetectorDelegate(delegate: mockDetectorDelegate)
        viewModel.delegate = mockDelegate
        viewModel.loadRegions()
        viewModel.connectWifi(mockNetwork)
        viewModel.didEnterRegion(mockRegion.id)
        viewModel.didExitRegion(mockRegion.id)

        let isEnteredRegion = try? XCTUnwrap(mockDetectorDelegate.isEnteredInRegion)
        let isExitedRegion = try? XCTUnwrap(mockDetectorDelegate.isExitedRegion)
        XCTAssert(isEnteredRegion!)
        XCTAssert(!isExitedRegion!)
    }
}
