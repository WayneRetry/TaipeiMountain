import UIKit
import AVFoundation
import Photos

public class TMCameraHelper {
    public class func checkCameraAuth(checked: @escaping (_ authorized: Bool) -> Void) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                checked(true)
                break
            case .denied:
                checked(false)
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (authStatus) in
                    checked(authStatus)
                }
                break
            default:
                checked(false)
                break
            }
        }
    }
    
    public class func checkPhotoAuth(checked: @escaping (_ authorized: Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            checked(true)
            break
        case .denied:
            checked(false)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized {
                    checked(true)
                } else {
                    checked(false)
                }
            }
            break
        default:
            checked(false)
            break
        }
    }
    
    public class func saveImageToPhotoLibrary(info: [UIImagePickerController.InfoKey : Any], completed: @escaping (_ image: UIImage, _ asset: PHAsset?) -> Void) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            var identifier = ""
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                identifier = request.placeholderForCreatedAsset?.localIdentifier ?? ""
            }, completionHandler: { (_, _) in
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: options)
                completed(image, assets.firstObject)
            })
        }
    }
    
    private class func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
         return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
     }

     private class func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
         return input.rawValue
     }
}
