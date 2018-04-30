//
//  FavoritePhotoViewController.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/4/30.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit
import Firebase

class FavoritePhotoViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var photoStorageRef: StorageReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        photoStorageRef = Storage.storage().reference(withPath: "favorite")
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
    
    func uploadImage(_ data: Data?) {
        guard let data = data else { return }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        progressView.isHidden = false
        progressView.progress = 0
        
        let uploadTask = photoStorageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                print("Error with upload \(error.localizedDescription)")
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else { return }
            self.progressView.progress = Float(progress.fractionCompleted)
        }
        uploadTask.observe(.success) { (snapshot) in
            self.progressView.isHidden = true
            print("Your upload is finished")
        }
    }
}

// MARK: UIImagePicker controller delegate methods

extension FavoritePhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            self.imageView.image = image
            uploadImage(UIImageJPEGRepresentation(image, 0.5))
        }
        picker.dismiss(animated: true)
    }
}
