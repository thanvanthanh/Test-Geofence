//
//  RegionsViewModelTests.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import XCTest
@testable import Geofence_MVVM

class RegionsViewModelTests: XCTestCase {

    func testFailAllFieldValidation() {
        let mockDelegate = MockRegionsViewModelDelegate()
        let viewModel = RegionsViewModel(delegate: mockDelegate)
        
        viewModel.delegate = mockDelegate
        viewModel.validator(nil, nil, nil)
        
        let result = try? XCTUnwrap(mockDelegate.validation)
        XCTAssertFalse(result!)
    }

    func testFailNetworkNameFieldValidation() {
        let mockDelegate = MockRegionsViewModelDelegate()
        let viewModel = RegionsViewModel(delegate: mockDelegate)
        viewModel.delegate = mockDelegate

        viewModel.validator("Sota", "200", nil)

        let result = try? XCTUnwrap(mockDelegate.validation)
        XCTAssertFalse(result!)
    }

    func testFailRadiusFieldValidation() {
        let mockDelegate = MockRegionsViewModelDelegate()
        let viewModel = RegionsViewModel(delegate: mockDelegate)
        viewModel.delegate = mockDelegate

        viewModel.validator("Sota", nil, "")

        let result = try? XCTUnwrap(mockDelegate.validation)
        XCTAssertFalse(result!)
    }

    func testSuccessValidation() {

        let mockDelegate = MockRegionsViewModelDelegate()
        let viewModel = RegionsViewModel(delegate: mockDelegate)
        viewModel.delegate = mockDelegate

        viewModel.validator("Sota", "200", "SotaWifi")

        let result = try? XCTUnwrap(mockDelegate.validation)
        XCTAssertTrue(result!)
    }

    func testNewRegion() {
        let mockDelegate = MockRegionsViewModelDelegate()
        let viewModel = RegionsViewModel(delegate: mockDelegate)
        viewModel.delegate = mockDelegate

        let title = mockRegion.title
        let radius = mockRegion.radius
        let coordinates = mockRegion.getCoordinates()!
        let network = mockRegion.network.name
        viewModel.createRegion(title, radius, coordinates, network)

        let result = try? XCTUnwrap(mockDelegate.regionObject)
        XCTAssertNotNil(result)
    }

}

class MockRegionsViewModelDelegate: RegionsViewModelDelegate {
    var validation: Bool!
    var regionObject: RegionObject!

    func getNewRegion(_ region: RegionObject) {
        self.regionObject = region
    }

    func isFieldsValidated(_ status: Bool) {
        validation = status
    }
}
