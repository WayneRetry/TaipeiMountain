//
//  ViewController.swift
//  TaipeiMountain
//
//  Created by wayne on 11/11/2019.
//  Copyright (c) 2019 wayne. All rights reserved.
//

import UIKit
import Photos
import TaipeiMountain
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var imageData = [(image: UIImage, asset: PHAsset?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clearPress() {
        imageData.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func albumPress() {
        let config = TMConfig()
        config.mainColor = .red
        let vc = TMPhotoViewController.create(delegate: self, preSelectAsset: imageData.compactMap{$0.asset}, config: config)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func singlePress() {
        let vc = TMPhotoViewController.createSingle(delegate: self)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cameraPress() {
        presentCameraCapture(delegate: self)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        let image = imageData[indexPath.row]
        cell.fullImageView.image = image.image
        return cell
    }
    
}

extension ViewController: TMPhotoPickerDelegate {

    func didReceiveAccessDenied() {
        print("AccessDenied!")
    }
    
    func photoPickerViewController(picker: TMPhotoViewController?, images: [(image: UIImage, asset: PHAsset)]) {
        for data in images {
            imageData.append(data)
        }
        tableView.reloadData()
    }
    
    func photoDownloadProgress(picker: TMPhotoViewController?, progress: Double, error: Error?) {
        if(progress == 1.0){
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }

        } else {
            DispatchQueue.main.async {
                SVProgressHUD.showProgress(Float(progress), status: "從iCloud下載相片中")
            }
        }
        if error != nil {
            SVProgressHUD.show(withStatus: "讀取相片錯誤")
            SVProgressHUD.dismiss(withDelay: 0.3)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        TMCameraHelper.saveImageToPhotoLibrary(info: info) { (image, asset) in
            DispatchQueue.main.async {
                self.imageData.append((image, asset))
                self.tableView.reloadData()
            }
        }
    }
}
