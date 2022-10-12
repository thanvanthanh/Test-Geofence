//
//  di.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import Foundation

protocol WifiListControllerFactory {
    func makeViewController() -> WifiListViewController?
    func makeWifiListViewModel() -> WifiListViewModel
    func makeWifiList() -> [HotSpot]
    func makeFenceDelegate() -> GeoFenceControllerDelegate
}

class WifiListDependencyContainer: WifiListControllerFactory {

    private var delegate: GeoFenceControllerDelegate
    private var hotspots: [HotSpot] = []

    internal init(delegate: GeoFenceControllerDelegate, hotspots: [HotSpot]) {
        self.delegate = delegate
        self.hotspots = hotspots
    }

    func makeViewController() -> WifiListViewController? {
        let viewController = WifiListViewController(factory: self)
        viewController.delegate = makeFenceDelegate()
        return viewController
    }

    func makeWifiListViewModel() -> WifiListViewModel {
        WifiListViewModel(makeWifiList())
    }

    func makeWifiList() -> [HotSpot] {
        hotspots
    }

    func makeFenceDelegate() -> GeoFenceControllerDelegate {
        delegate
    }
}
