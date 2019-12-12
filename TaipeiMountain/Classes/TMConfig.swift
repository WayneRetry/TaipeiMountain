import UIKit

public class TMConfig {
    
    public init() {
    }
    
    public var darkMode: Bool = false
    public var selectImageLimit: Int = 10
    
    public var mainColor: UIColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    public var backgroundColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var mainColor_dark: UIColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    public var backgroundColor_dark: UIColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    
    public var navBarTintColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var navBarItemColor: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    public var navTitleColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    public var navSubTitleColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    public var navBarTintColor_dark: UIColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    public var navBarItemColor_dark: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var navTitleColor_dark: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var navSubTitleColor_dark: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    public var imageCountColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var imageDefaultBorderColor: UIColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.4)
    public var imageCountColor_dark: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var imageDefaultBorderColor_dark: UIColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.4)
    
    public var albumNameColor: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    public var albumCountColor: UIColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
    public var albumBackgroundColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    public var albumSelectBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    public var albumNameColor_dark: UIColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    public var albumCountColor_dark: UIColor = UIColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
    public var albumBackgroundColor_dark: UIColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    public var albumSelectBackgroundColor_dark: UIColor = UIColor.white.withAlphaComponent(0.3)

    func getMainColor() -> UIColor {
        if darkMode {
            return mainColor_dark
        } else {
            return mainColor
        }
    }
    
    func getBackgroundColor() -> UIColor {
        if darkMode {
            return backgroundColor_dark
        } else {
            return backgroundColor
        }
    }
    
    func getNavigationBarTintColor() -> UIColor {
        if darkMode {
            return navBarTintColor_dark
        } else {
            return navBarTintColor
        }
    }
    
    func getNavigationBarItemColor() -> UIColor {
        if darkMode {
            return navBarItemColor_dark
        } else {
            return navBarItemColor
        }
    }
    
    func getNavigationTitleColor() -> UIColor {
        if darkMode {
            return navTitleColor_dark
        } else {
            return navTitleColor
        }
    }
    
    func getNavigationSubTitleColor() -> UIColor {
        if darkMode {
            return navSubTitleColor_dark
        } else {
            return navSubTitleColor
        }
    }
    
    func getImageCellSelectColor() -> UIColor {
        if darkMode {
            return mainColor_dark
        } else {
            return mainColor
        }
    }
    
    func getImageCellCountColor() -> UIColor {
        if darkMode {
            return imageCountColor_dark
        } else {
            return imageCountColor
        }
    }
    
    func getImageCellBorderColor() -> UIColor {
        if darkMode {
            return imageDefaultBorderColor_dark
        } else {
            return imageDefaultBorderColor
        }
    }
    
    func getAlbumCellNameColor() -> UIColor {
        if darkMode {
            return albumNameColor_dark
        } else {
            return albumNameColor
        }
    }
    
    func getAlbumCellCountColor() -> UIColor {
        if darkMode {
            return albumCountColor_dark
        } else {
            return albumCountColor
        }
    }
    
    func getAlbumCellBackgroundColor() -> UIColor {
        if darkMode {
            return albumBackgroundColor_dark
        } else {
            return albumBackgroundColor
        }
    }
    
    func getAlbumCellSelectBackgroundColor() -> UIColor {
        if darkMode {
            return albumSelectBackgroundColor_dark
        } else {
            return albumSelectBackgroundColor
        }
    }
}
