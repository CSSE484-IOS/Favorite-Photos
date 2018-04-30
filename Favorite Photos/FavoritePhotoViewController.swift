//
//  FavoritePhotoViewController.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/4/30.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit

class FavoritePhotoViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedFab(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
}

// MARK: UIImagePicker controller delegate methods

extension FavoritePhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        picker.dismiss(animated: true)
    }
}
