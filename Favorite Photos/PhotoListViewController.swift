//
//  PhotoListViewController.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/4/30.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let photoCellIdentifier = "PhotoCell"

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSnapshots = [DocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedFab(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSnapshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        //configure the cell
//        cell.captionLabel.text = "Best photo ever!"
//        cell.imageView.image = #imageLiteral(resourceName: "fab")
        cell.display(snapshot: dataSnapshots[indexPath.row])
        
        return cell
    }

}
