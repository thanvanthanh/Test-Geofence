//
//  GeoFenceViewController.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 09/10/2022.
//

import UIKit
import MapKit

final class GeoFenceViewController: BaseViewController {
    typealias Factory = GeoFenceControllerFactory

    lazy var viewModel = factory.makeGeoFenceViewModel()
    lazy var locationService = factory.makeLocationService()
    private let factory: Factory
    
    private var wifiButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var regionStatusLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
     
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        addLeftBarItem(imageName: "location", selectedImage: "location", title: "")
        addRightBarItem(imageName: "plus", imageTouch: "plus", title: "Add")
        mapView.delegate = self
        locationService.delegate = self
        viewModel.delegate = self
        viewModel.setDetectorDelegate(delegate: self)
        viewModel.loadRegions()
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        addRegionTapped()
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        self.locationTapped()
    }
    // Function to update title with connect wifi network
    func updateStatusTitle(isConnected: Bool, name: String? = nil) {
        let titleText = "Wifi connected: \(String(describing: name ?? ""))"
        self.title = isConnected ? titleText : "Wifi Disconnected"
    }

    // Setup toolbar items
    func addToolBarButton() {
        wifiButton = UIBarButtonItem(image: UIImage(systemName: "wifi"), style: .plain, target: self, action: #selector(connectWifiTapped))
        toolBar.items = [wifiButton]
        toolBar.items = []
        toolBar.items?.append(wifiButton)
    }

    func updateWifiButton(_ isEnabled: Bool) {
        self.wifiButton.isEnabled = isEnabled
    }

    @objc func locationTapped() {
        mapView.zoomToUserLocation()
    }

    @objc func addRegionTapped() {
        let container = RegionsDependencyContainer(delegate: self)
        if let viewController = container.makeViewController() {
            let navController = UINavigationController(rootViewController: viewController)
            self.present(navController, animated: true, completion: {
            })
        }
    }

    @objc func connectWifiTapped() {
        viewModel.loadNetworkList()
    }

    func navigateToWifiListVC(_ hotspots: [HotSpot]) {
        let container = WifiListDependencyContainer(delegate: self, hotspots: hotspots)
        if let viewController = container.makeViewController() {
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true, completion: {
            })
        }
    }

    // MARK: Load all regions from defaults and draw on maps
    func reloadRegions(_ regions: [RegionObject]) {
        regions.forEach { self.add($0) }

        if let firstRegion = regions.first {
            self.setVisibleRegion(firstRegion)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.mapView.zoomToUserLocation()
            }
        }
        self.addToolBarButton()
        self.updateWifiButton(regions.count > 0)
    }

    // Add new region
    func addNewRegion(_ region: RegionObject) {
        self.add(region)
        self.viewModel.saveRegionData(region)
        self.setVisibleRegion(region)
        self.wifiButton.isEnabled = true
        self.isShowRegionNotification(status: true, region.title)
    }

    // Functions that draw radius overlay and add annotation
    func add(_ region: RegionObject) {
        if let annotation = region.annotableRegion() {
            mapView.addAnnotation(annotation)
        }
        addRadiusOverlay(forRegion: region)
        self.startMonitoring(region)
    }

    // Delete region and annotation
    func remove(_ annotation: RegionAnnotation) {
        mapView.removeAnnotation(annotation)
        viewModel.deleteRegion(annotation)
        regionStatusLabel.text = "Geo fence detection"
        self.title = ""
    }

    // Center the mapView on the selected pin
    func setVisibleRegion(_ region: RegionObject) {
        let region = MKCoordinateRegion(center: region.getCoordinates()!, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }


    // Add radius overlay on map
    func addRadiusOverlay(forRegion region: RegionObject) {
        if let coordinates = region.getCoordinates() {
            mapView.addOverlay(MKCircle.init(center: coordinates, radius: CLLocationDistance(region.radius)))
        }
    }

    func region(with coordinate2D: CLLocationCoordinate2D, radius: Double) -> CLCircularRegion {
        let region = CLCircularRegion(center: coordinate2D, radius: radius, identifier: String().randomString(length: 10))
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }

    // Find exactly one overlay which has the same coordinates & radius to remove
    func removeRadiusOverlay(forRegion region: RegionObject) {
        let overlays = mapView.overlays
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if let regionCoordinates = region.getCoordinates() {
                if coord.latitude == regionCoordinates.latitude && coord.longitude == regionCoordinates.longitude && circleOverlay.radius == CLLocationDistance(region.radius) {
                    mapView.removeOverlay(circleOverlay)
                    break
                }
            }
        }
    }

    // Monitor location
    func startMonitoring(_ region: RegionObject) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showErrorNotSupport()
            return
        }

        if !locationService.locationManager.hasLocationPermission() {
            showPermissionAccessDeviceLocation()
        }

        if let fenceRegion = circularRegion(with: region) {
            locationService.startMonitoringFor(region: fenceRegion)
        }
    }

    // Stop monitoring region object
    func stopMonitoring(_ region: RegionObject) {
        let regions = locationService.locationManager.monitoredRegions
        regions.forEach({ (fenceRegion) in
            if fenceRegion.identifier == region.id {
                locationService.stopMonitoringFor(region: fenceRegion)
            }
        })
    }

    // Create circular region to monitor the exit and entry
    func circularRegion(with region: RegionObject) -> CLCircularRegion? {
        guard let coordinates = region.getCoordinates() else { return nil }
        let region = CLCircularRegion(center: coordinates, radius: CLLocationDistance(region.radius), identifier: region.id)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }

    // Show/hide notification based on entry/exit
    func isShowRegionNotification(status: Bool, _ regionName: String?) {
        let text = status ? "Entered into '\(regionName ?? "")' region" : "Exited from the region '\(regionName ?? "")'"
        regionStatusLabel.text = text
    }
}


// MARK: GeoFenceViewModel Delegate
extension GeoFenceViewController: GeoFenceViewModelDelegate {
    func stopMonitoringRegion(_ region: RegionObject) {
        removeRadiusOverlay(forRegion: region)
        stopMonitoring(region)
    }

    func showError(_ error: String) {
        showAlert(withTitle: "Error", message: error)
    }

    func networkListLoaded(_ hotspots: [HotSpot]) {
        navigateToWifiListVC(hotspots)
    }

    func reloadData(_ regions: [RegionObject]) {
        self.reloadRegions(regions)
    }

    func savedResult(_ status: Bool) {
        print(status)
    }
}

// MARK: GeoFenceViewController Delegate
extension GeoFenceViewController: GeoFenceControllerDelegate {
    func disconnectWifi() {
        viewModel.disconnectWifi()
    }

    func wifiConnected(_ hotspot: HotSpot) {
        viewModel.connectWifi(hotspot)
    }

    func addRegion(_ region: RegionObject) {
        addNewRegion(region)
    }
}

// MARK: Location Service Delegate
extension GeoFenceViewController: LocationServiceDelegate {
    func didEnterIntoRegion(region: CLRegion) {
        viewModel.didEnterRegion(region.identifier)
    }

    func didExitIntoRegion(region: CLRegion) {
        viewModel.didExitRegion(region.identifier)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = status == .authorizedAlways
    }
    
}

// MARK: GeoFence Detector Delegate
extension GeoFenceViewController: GeoFenceDetectorServiceDelegate {
    func connectedToWifi(_ networkName: String) {
        updateStatusTitle(isConnected: true, name: networkName)
    }

    func wifiDisconnected() {
        updateStatusTitle(isConnected: false)
    }

    func didEnteredRegion(_ name: String) {
        isShowRegionNotification(status: true, name)
    }

    func didExitRegion(_ name: String) {
        isShowRegionNotification(status: false, name)
    }
}

// MARK: MKMapView  Delegate
extension GeoFenceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
        rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .red
            circleRenderer.alpha = 0.3
            circleRenderer.lineWidth = 2.0
            circleRenderer.strokeColor = .red
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeoFence"
        // Customize annotation
        if annotation is RegionAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage.init(systemName: "xmark.circle"), for: .normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? RegionAnnotation else  { return }
        remove(annotation)
    }
}

