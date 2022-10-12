//
//  MockDataSource.swift
//  Geofence-MVVMTests
//
//  Created by Thân Văn Thanh on 12/10/2022.
//  Copyright © 2022 Than Van Thanh. All rights reserved.
//

import Foundation

@testable import Geofence_MVVM

class MockRegionDataSource: RegionDataSourceProtocol {
    func loadAllRegions(_ completion: @escaping ((Result<[RegionObject], DefaultsError>) -> Void)) {
        completion(Result.success(mockRegionObjects))
    }

    func saveAllRegions(_ regions: [RegionObject], completion: @escaping ((Result<Bool, DefaultsError>) -> Void)) {
        completion(Result.success(true))
    }
}

class MockFailureRegionDataSource: RegionDataSourceProtocol {
    func loadAllRegions(_ completion: @escaping ((Result<[RegionObject], DefaultsError>) -> Void)) {
        completion(Result.failure(DefaultsError.noDataFound))
    }

    func saveAllRegions(_ regions: [RegionObject], completion: @escaping ((Result<Bool, DefaultsError>) -> Void)) {
        completion(Result.failure(.saveError))
    }
}
