//
//  ImageUtils.swift
//  Favorite Photos
//
//  Created by FengYizhi on 2018/5/1.
//  Copyright © 2018年 FengYizhi. All rights reserved.
//

import UIKit
import Kingfisher

class ImageUtils: NSObject {
    
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            
            imageView.kf.setImage(with: imgUrl)
            
//            DispatchQueue.global().async {
//                do {
//                    let data = try Data(contentsOf: imgUrl)
//                    DispatchQueue.main.async {
//                        imageView.image = UIImage(data: data)
//                    }
//                } catch {
//                    print("Error downloading image: \(error.localizedDescription)")
//                }
//            }
        }
    }
    
}
