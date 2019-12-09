//
//  ViewController2.swift
//  TaipeiMountain_Example
//
//  Created by Wayne Lin on 2019/12/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import TaipeiMountain

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func press() {
        let vc = TMPhotoViewController(delegate: self)
        let nv = UINavigationController(rootViewController: vc)
        nv.modalPresentationStyle = .fullScreen
        present(nv, animated: true, completion: nil)
    }
    
    @IBAction func camre() {
        presentCameraCapture(delegate: self)
    }
    
}

extension ViewController2: TMPhotoPickerDelegate {

    func didReceiveAccessDenied() {
        print("denied")
    }
    
    func photoPickerViewController(picker: TMPhotoViewController?, images: [(image: UIImage, asset: PHAsset)]) {
        print(images)
    }
    
    func photoDownloadProgress(picker: TMPhotoViewController?, progress: Double, error: Error?) {
        print(progress)
        print(error)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        TMCameraHelper.saveImageToPhotoLibrary(info: info) { (asset) in
            
        }
        
    }
}
