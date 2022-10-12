//
//  WifiListTableViewCell.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import UIKit

class WifiListTableViewCell: UITableViewCell {

    @IBOutlet weak var wifiNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func setupCell(wifi: String) {
        self.wifiNameLabel.text = wifi
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
