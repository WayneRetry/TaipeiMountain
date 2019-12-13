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

public extension UIViewController {
    
    func presentCameraCapture(delegate: TMPhotoPickerDelegate?) {
        TMCameraHelper.checkCameraAuth { [weak self] (auth) in
            if auth {
                TMCameraHelper.checkPhotoAuth { [weak self] (auth) in
                    if auth {
                        self?.presentImagePickerController(delegate: delegate)
                    } else {
                        let alertView = UIAlertController(title: "此功能需要相片存取權", message: "在設定中允許取用照片", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "開啟設定", style: .default, handler: { (_) in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: nil)
                            }
                        }))
                        alertView.addAction(UIAlertAction(title: "稍後再說", style: .cancel, handler: nil))
                        self?.present(alertView, animated: true, completion: nil)
                        delegate?.didReceiveAccessDenied()
                    }
                }
            } else {
                let alertView = UIAlertController(title: "此功能需要相機存取權", message: "在設定中允許取用相機", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "開啟設定", style: .default, handler: { (_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: nil)
                    }
                }))
                alertView.addAction(UIAlertAction(title: "稍後再說", style: .cancel, handler: nil))
                self?.present(alertView, animated: true, completion: nil)
                delegate?.didReceiveAccessDenied()
            }
        }
    }
    
    private func presentImagePickerController(delegate: TMPhotoPickerDelegate?) {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegate
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
}
