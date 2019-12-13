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
