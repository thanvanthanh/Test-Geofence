//
//  WifiListViewModelTests.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import XCTest
@testable import Geofence_MVVM

class WifiListViewModelTests: XCTestCase {

    func testLoadNetwork() {

        let mockDelegate = MockWifiListViewModelDelegate()
        let mockList = [mockNetwork,mockNetwork,mockNetwork]
        let viewModel = WifiListViewModel(mockList)
        viewModel.delegate = mockDelegate
        
        viewModel.getAllNetwork()

        let result = try? XCTUnwrap(mockDelegate.count)
        XCTAssertEqual(result!, mockList.count)
    }
}
