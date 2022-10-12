//
//  BaseViewController.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import UIKit

class BaseViewController: UIViewController {
   
    override func viewDidLoad() {
        setupUI()
        localizedString()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        didLayoutSubviews()
    }
        
    // Localized String in a View Controller
    func localizedString() {
    }
    
    // MARK: - Setup UI
    func setupUI() {
    }
    
    func didLayoutSubviews() {
    }
    
    func loadData() {
    }
    

    
    // MARK: - Navigation Bar
    func hideNavigationBar(isHide: Bool = true) {
        self.navigationController?.navigationBar.isHidden = isHide
    }
    
    func setupNavigationbarColor(title: String,
                                 subtitle: String? = nil,
                                 background: UIColor,
                                 titleLeftItem: String?,
                                 spacingBottomColor: UIColor = UIColor(hexString: "E6E6E6")) {
        guard let navigationBar = navigationController?.navigationBar else {return}
        
        self.title = title
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = background.navBarImage()
            appearance.shadowImage = spacingBottomColor.as1ptImage(height: 1)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.Basic.mainText]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Basic.mainText]
            navigationBar.setBackgroundImage(background.navBarImage(), for: .default)
            navigationBar.shadowImage = spacingBottomColor.as1ptImage(height: 1)
        }
        
        guard let titleleft = titleLeftItem else { return }
        addLeftBarItem(imageName: "ico_back", selectedImage: "ico_back", title: titleleft)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addLeftBarItem(imageName: String, selectedImage: String, title: String) {
        
        let leftButton = UIButton.init(type: UIButton.ButtonType.custom)
        leftButton.isExclusiveTouch = true
        leftButton.isSelected       = false
        leftButton.frame            = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        leftButton.addTarget(self, action: #selector(tappedLeftBarButton(sender:)), for: UIControl.Event.touchUpInside)
        if title.count > 0 {
            leftButton.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
            leftButton.setTitle(title, for: UIControl.State.normal)
            leftButton.setTitleColor(UIColor.Basic.blue, for: .normal)
            leftButton.titleLabel?.font = .systemFont(ofSize: 17)
        }
        if imageName.count > 0 {
            leftButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            leftButton.setImage(UIImage.init(systemName: imageName), for: UIControl.State.normal)
            leftButton.setImage(UIImage.init(systemName: selectedImage), for: UIControl.State.selected)
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
    }
    
    func addRightBarItem(imageName: String, imageTouch: String, title : String) {
        let rightButton = UIButton.init(type: UIButton.ButtonType.custom)
        rightButton.isExclusiveTouch = true
        rightButton.isSelected       = false
        rightButton.frame            = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        rightButton.addTarget(self, action: #selector(tappedRightBarButton(sender:)), for: UIControl.Event.touchUpInside)
        if title.count > 0 {
            rightButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            rightButton.setTitle(title, for: UIControl.State.normal)
            rightButton.titleLabel?.textAlignment = .right
            rightButton.setTitleColor(UIColor.Basic.blue, for: .normal)
        }
        if imageName.count > 0 {
            rightButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            rightButton.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        }
        if imageTouch.count > 0 {
            rightButton.setImage(UIImage.init(named: imageTouch), for: .selected)
        }
        rightButton.contentHorizontalAlignment = .right
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
    }
    
    func removeRightBarButton() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func addTitle(title : String) {
        self.title = title
    }
    
    func addLogoTitle(background: UIColor) {
        let titleView = UIButton.init(type: UIButton.ButtonType.custom)
        titleView.frame = CGRect.init(x: 0, y: 0, width: 22, height: 24)
        titleView.setImage(UIImage(named: "ico_logo_small"), for: .normal)
        navigationItem.titleView = titleView
        
        guard let navigationBar = navigationController?.navigationBar else {return}
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = background.navBarImage()
            appearance.shadowImage = UIColor.Basic.clear.as1ptImage(height: 1)
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            navigationBar.setBackgroundImage(background.navBarImage(), for: .default)
            navigationBar.shadowImage = UIColor.Basic.clear.as1ptImage(height: 1)
        }
        
    }
    
    // MARK: - NavigationBar Action
    @objc func tappedLeftBarButton(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedRightBarButton(sender : UIButton) {
    }
    
}
