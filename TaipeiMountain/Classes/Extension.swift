import UIKit
import Photos

extension UIImageView {
    
    func tm_loadImage(_ asset: PHAsset) {
        layoutIfNeeded()
        if tag == 0 {
          
        } else {
          PHImageManager.default().cancelImageRequest(PHImageRequestID(tag))
        }
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        let id = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: frame.size.width * UIScreen.main.scale, height: frame.size.height * UIScreen.main.scale), contentMode: .aspectFill, options: options) { [weak self] (image, _) in
            self?.image = image
        }
        tag = Int(id)
    }
}
