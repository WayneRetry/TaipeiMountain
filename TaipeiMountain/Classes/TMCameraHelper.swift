
//
//  TMCameraHelper.swift
//  Pods-TaipeiMountain_Example
//
//  Created by Wayne Lin on 2019/12/4.
//
import UIKit
import AVFoundation
import Photos

public protocol TMPhotoPickerDelegate: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didReceiveAccessDenied()
    func photoPickerViewController(picker: TMPhotoViewController?, images: [(image: UIImage, asset: PHAsset)])
    func photoDownloadProgress(picker: TMPhotoViewController?, progress: Double, error: Error?)
    //
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
}

public extension TMPhotoPickerDelegate {
    func didReceiveAccessDenied() {}
    func photoPickerViewController(picker: TMPhotoViewController, assets: [PHAsset], images: [UIImage]) {}
    func photoDownloadProgress(picker: TMPhotoViewController, progress: Double, error: Error?) {}
}

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

public extension UIViewController {
    
    func presentCameraCapture(delegate: TMPhotoPickerDelegate?) {
        TMCameraHelper.checkCameraAuth { [weak self] (auth) in
            if auth {
                TMCameraHelper.checkPhotoAuth { [weak self] (auth) in
                    if auth {
                        self?.presentImagePickerController(delegate: delegate)
                    } else {
                        delegate?.didReceiveAccessDenied()
                    }
                }
            } else {
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
