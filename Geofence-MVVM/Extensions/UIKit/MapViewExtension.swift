//
//  MapViewExtension.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import Foundation
import MapKit
import CoreLocation

extension MKMapView {
  func zoomToUserLocation() {
    guard let coordinate = userLocation.location?.coordinate else { return }
    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
    setRegion(region, animated: true)
  }
}
