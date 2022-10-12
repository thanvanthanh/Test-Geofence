//
//  WifiListViewController.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import UIKit

final class WifiListViewController: BaseViewController {
    
    typealias Factory = WifiListControllerFactory
    private let factory: Factory

    lazy var viewModel = factory.makeWifiListViewModel()

    weak var delegate: GeoFenceControllerDelegate?
    private var wifiList: [HotSpot] = []

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var disconectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(factory: Factory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    override func setupUI() {
        tableView.tableFooterView = UIView()
        viewModel.delegate = self
        backgroundView.layer.cornerRadius = 4
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: WifiListTableViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadData() {
        viewModel.getAllNetwork()
    }
   
    @IBAction func disconectAction(_ sender: Any) {
        self.delegate?.disconnectWifi()
        self.dismiss(animated: true)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func didSelectWifi(_ hotspots: HotSpot) {
        self.delegate?.wifiConnected(hotspots)
        self.dismiss(animated: true)
    }

    private func reloadData(_ hotspots: [HotSpot]) {
        if hotspots.count > 0 {
            nodataView.isHidden = true
            disconectButton.isEnabled = true
            self.tableView.isHidden = false
            self.wifiList = hotspots
            self.tableView.reloadData()
        } else {
            self.tableView.isHidden = true
            nodataView.isHidden = false
            disconectButton.isEnabled = false
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WifiListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: WifiListTableViewCell.self, indexPath: indexPath)
        let wifi = self.wifiList[indexPath.row]
        cell.setupCell(wifi: wifi.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifiList.count
    }
}

extension WifiListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectWifi(self.wifiList[indexPath.row])
    }
}

// MARK: - WifiListViewModelDelegate
extension WifiListViewController: WifiListViewModelDelegate {
    func networkListLoaded(_ hotspots: [HotSpot]) {
        self.reloadData(hotspots)
    }
}
