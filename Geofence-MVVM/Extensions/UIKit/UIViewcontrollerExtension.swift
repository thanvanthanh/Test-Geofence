//
//  UIViewcontrollerExtension.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import UIKit

extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
    
    func showErrorNotSupport() {
        showAlert(withTitle: "Error", message: "Geofencing is not supported on this device!")
    }
    
    func showPermissionAccessDeviceLocation() {
        let message = """
    Your geo fence location is saved but will only be activated once you grant
    permission to access the device location.
    """
        showAlert(withTitle: "Warning", message: message)
    }
}
