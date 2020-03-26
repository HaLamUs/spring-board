//
//  DownloadImage.swift
//  springboard
//
//  Created by lamha on 3/26/20.
//  Copyright © 2020 lam.pte. All rights reserved.
//

import UIKit

protocol DownloadImageDelegate: class {
    func downloadPhotoDidFinish(_ operation: DownloadImage, image: UIImage)
    func downloadPhotoDidFail(_ operation: DownloadImage)
}

class DownloadImage: Operation {
    let key: String
    let photoURL: String
    let photoName: String
    let indexPath: IndexPath
    
    weak var delegate: DownloadImageDelegate?
    
    init(key: String, photoURL: String, photoName: String, indexPath: IndexPath,
         delegate: DownloadImageDelegate) {
        self.key = key
        self.photoURL = photoURL
        self.photoName = photoName
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        let imageData = try? Data(contentsOf: URL(string: photoURL)!)
        guard let _ = imageData else {
            return
        }
        if let downloadImage = UIImage(data:imageData!) {
            downloadImage.saveImage(name: photoName)
            DispatchQueue.main.async {
                self.delegate?.downloadPhotoDidFinish(self, image: downloadImage)
            }
        }
        else{
            DispatchQueue.main.async {
                self.delegate?.downloadPhotoDidFail(self)
            }
        }
    }
}

