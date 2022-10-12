//
//  RegionManager.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 09/10/2022.
//

import Foundation

public enum RegionManagerKey: String {
    case savedRegions
}

public struct RegionManager {
    fileprivate let regionDefaults = UserDefaults.standard
    fileprivate init() { }
    
    static var shared: RegionManager {
        return RegionManager()
    }
    
    func saveObject<T>(_ object: T?, key: RegionManagerKey) {
        guard object != nil else { return }
        
        regionDefaults.set(object, forKey: key.rawValue)
        regionDefaults.synchronize()
    }
    
    func loadObject(forKey key: RegionManagerKey) -> AnyObject? {
        if let value = regionDefaults.object(forKey: key.rawValue) {
            return value as AnyObject?
        } else {
            return nil
        }
    }
}
