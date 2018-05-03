//
//  ImagePickerViewController.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/5/3.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {

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
    
    func uploadImage(_ image: UIImage) {
        print("super class does nothing")
    }
    
}

extension ImagePickerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //            self.imageView.image = image
            uploadImage(image)
        }
        picker.dismiss(animated: true)
    }
}
