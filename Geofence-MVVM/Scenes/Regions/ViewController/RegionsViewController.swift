//
//  RegionsViewController.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import UIKit
import MapKit
import CoreLocation

final class RegionsViewController: BaseViewController {

    @IBOutlet private weak var radiusTextField: UITextField!
    @IBOutlet private weak var regionsTextField: UITextField!
    @IBOutlet private weak var wifiTextField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    
    typealias Factory = RegionsControllerFactory
    private let factory: Factory
    lazy var viewModel = factory.makeRegionsViewModel()
    weak var delegate: GeoFenceControllerDelegate?
    var addButton: UIBarButtonItem!
    
    
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
        viewModel.delegate = self
        setupNavigationButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mapView.zoomToUserLocation()
        }
    }
    
    func setupNavigationButtons() {
        addLeftBarItem(imageName: "xmark", selectedImage: "xmark", title: "")
        
        addButton = UIBarButtonItem(title: "Add",
                                    style: .plain,
                                    target: self,
                                    action: #selector(onAddRegion))
        addButton.isEnabled = false
        let location = UIBarButtonItem(image: UIImage.init(systemName: "location"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.locationTapped))
        navigationItem.rightBarButtonItems = [addButton, location]
    }
    
    override func tappedLeftBarButton(sender: UIButton) {
        self.closeTapped()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.validator(self.regionsTextField.text,
                            self.radiusTextField.text,
                            self.wifiTextField.text)
    }
    @objc
    func locationTapped() {
        mapView.zoomToUserLocation()
    }

    @objc
    func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func onAddRegion(sender: AnyObject) {
        let regionName = self.regionsTextField.text ?? ""
        let networkName = self.wifiTextField.text ?? ""
        guard let radiusText = self.radiusTextField.text,
              let radius = Float(radiusText) else { return }
        viewModel.createRegion(regionName, radius, mapView.centerCoordinate, networkName)
    }

    func newRegionAdded(_ region: RegionObject) {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.addRegion(region)
        }
    }
}

// MARK: - RegionsViewModelDelegate
extension RegionsViewController: RegionsViewModelDelegate {
    func isFieldsValidated(_ status: Bool) {
        addButton.isEnabled = status
    }

    func getNewRegion(_ region: RegionObject) {
        newRegionAdded(region)
    }
}
