//
//  WifiListViewModel.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import Foundation

protocol WifiListViewModelDelegate: AnyObject {
    func networkListLoaded(_ hotspots: [HotSpot])
}

class WifiListViewModel {
    weak var delegate: WifiListViewModelDelegate?

    private var hotspots: [HotSpot] = []

    internal init(_ hotspots: [HotSpot]) {
        self.hotspots = hotspots
    }

    func getAllNetwork() {
        self.delegate?.networkListLoaded(self.hotspots)
    }
}
