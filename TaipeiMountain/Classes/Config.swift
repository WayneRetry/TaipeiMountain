//
//  ColorStyle.swift
//  Pods-TaipeiMountain_Example
//
//  Created by Wayne Lin on 2019/11/12.
//

import UIKit

public struct Config {
    
    public struct Style {
        public struct BarItem {
            public static var barItemColor: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            public static var barItemColorDark: UIColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
            
            public static func getBarItemColor() -> UIColor {
                if #available(iOS 13.0, *) {
                    return UIColor { (traitcollection) -> UIColor in
                        if traitcollection.userInterfaceStyle == .dark {
                            return self.barItemColorDark
                        }
                        return self.barItemColor
                    }
                } else {
                    return barItemColor
                }
            }
        }
        
        public struct ImageCell {
            public static var selectedColor: UIColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
            public static var countColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            public static var defaultBorderColor: UIColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.4)
        }
        
        public struct AlbumCell {
            public static var nameColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            public static var countColor: UIColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        }
    }
    
    public struct Setting {
        public static var imageLimit: Int = 10
    }
}
