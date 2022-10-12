//
//  RegionsFactory.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import Foundation

protocol RegionsControllerFactory {
    func makeViewController() -> RegionsViewController?
    func makeRegionsViewModel() -> RegionsViewModel
    func makeRegionsDataSource() -> RegionDataSource
    func makeFenceDelegate() -> GeoFenceControllerDelegate
}

class RegionsDependencyContainer: RegionsControllerFactory {
    
    private var delegate: GeoFenceControllerDelegate
    
    internal init(delegate: GeoFenceControllerDelegate) {
        self.delegate = delegate
    }

    func makeViewController() -> RegionsViewController? {
        let viewController = RegionsViewController(factory: self)
        viewController.delegate = makeFenceDelegate()
        return viewController
    }

    func makeRegionsViewModel() -> RegionsViewModel {
        RegionsViewModel()
    }

    func makeRegionsDataSource() -> RegionDataSource {
        RegionDataSource()
    }

    func makeFenceDelegate() -> GeoFenceControllerDelegate {
        delegate
    }
}
