//
//  PhotoListViewController.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/4/30.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: ImagePickerViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let photoCellIdentifier = "PhotoCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    let itemsPerRow = 2
    let sectionInsets = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 30.0, right: 10.0)
    
    var photosStorageRef: StorageReference!
    var photosCollectionRef: CollectionReference!
    var photosListener: ListenerRegistration!
    
    var dataSnapshots = [DocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosStorageRef = Storage.storage().reference(withPath: "photos")
        photosCollectionRef = Firestore.firestore().collection("photos")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photosListener = photosCollectionRef
            .order(by: "created", descending: true).limit(to: 12)
            .addSnapshotListener({ (querySnapshot, error) in
            if let error = error {
                print("Error getting firestore photos. Error: \(error.localizedDescription)")
                return
            }
            if let snapshot = querySnapshot {
                self.dataSnapshots = snapshot.documents
                self.collectionView.reloadData()
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photosListener.remove()
    }
    
    func getCaption(_ documentRef: DocumentReference) {
        let ac = UIAlertController(title: "Set image caption", message: "", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Image caption"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let captionTextField = ac.textFields![0]
            documentRef.updateData(["caption" : captionTextField.text!])
        }))
        present(ac, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSnapshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.display(snapshot: dataSnapshots[indexPath.row])
        
        return cell
    }
    
    override func uploadImage(_ image: UIImage) {
        guard let data = ImageUtils.resize(image: image) else { return }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        let photoDocRef = photosCollectionRef.document()
        let photoStorageRef = photosStorageRef.child(photoDocRef.documentID)
        
        DispatchQueue.main.async {
            self.getCaption(photoDocRef)
        }
        
        photoStorageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                print("Error with upload \(error.localizedDescription)")
                return
            }
            
            photoStorageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Error getting the download url. Error: \(error.localizedDescription)")
                }
                if let url = url {
                    photoDocRef.setData(["url" : url.absoluteString,
                                         "caption" : "Best photo ever!",
                                         "created" : Date()])
                }
            })
        }
    }

}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
