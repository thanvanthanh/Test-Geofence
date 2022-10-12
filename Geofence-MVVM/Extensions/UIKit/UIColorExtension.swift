//
//  UIColorExtension.swift
//  Geofence-MVVM
//
//  Created by Thân Văn Thanh on 10/10/2022.
//

import UIKit

extension UIColor {
    public convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func as1ptImage(height: CGFloat = 0.5) -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: height))
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func tabBarImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: 49))
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 49))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
    func navBarImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize.init(width: 1, height: 88))
        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }
        self.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 88))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    enum Basic {
        static let white = UIColor.white
        static let black = UIColor.black
        static let clear = UIColor.clear
        static let red = UIColor(hexString: "F25D4E")
        static let green = UIColor(hexString: "12C479")
        static let blue = UIColor(hexString: "4231C8")
        static let mainText = UIColor(hexString: "282828")
        static let grayText = UIColor(hexString: "B6B6B6")
        static let grayText6 = UIColor(hexString: "7B7B7B")
        static let grayText7 = UIColor(hexString: "424242")
        static let background = UIColor(hexString: "E5E5E5")
        static let lightbackground = UIColor(hexString: "FAFAFA")
        static let spacingBottom = UIColor(hexString: "E6E6E6")
        static let line = UIColor(hexString: "F2F2F2")
        static let red01 = UIColor(hexString: "F25D4E").withAlphaComponent(0.1)
        static let red02 = UIColor(hexString: "#FCE8EA")
        static let red03 = UIColor(hexString: "#EC5565")
        static let light30 = UIColor(hexString: "FAFAFA").withAlphaComponent(0.3)
        static let lightGray = UIColor(hexString: "FAFAFA")
    }
    
    static let dimmedLightBackground = UIColor(white: 100.0/255.0, alpha: 0.3)
    static let dimmedDarkBackground = UIColor(white: 50.0/255.0, alpha: 0.3)
    static let dimmedDarkestBackground = UIColor(white: 0, alpha: 0.5)
    static let musicBackgroundDark = UIColor(red: 36, green: 39, blue: 42, alpha: 1)
}

