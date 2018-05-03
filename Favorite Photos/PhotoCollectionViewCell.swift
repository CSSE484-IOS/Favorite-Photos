//
//  PhotoCollectionViewCell.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/5/1.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit
import Firebase

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func display(snapshot: DocumentSnapshot) {
        if let url = snapshot.get("url") as? String {
            ImageUtils.load(imageView: imageView, from: url)
        }
        if let caption = snapshot.get("caption") as? String {
            captionLabel.text = caption
        }
    }
    
}
