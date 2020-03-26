//
//  UIImageViewExtension.swift
//  springboard
//
//  Created by lamha on 3/26/20.
//  Copyright © 2020 lam.pte. All rights reserved.
//

import UIKit

extension UIImage {
    
    func saveImage(name: String) {
        guard let dataImage = jpegData(compressionQuality: 0.8) else { return }
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let writePath = path.appendingPathComponent(name)
        try? dataImage.write(to: writePath)
        
    }
    
    static func loadImageFromPath(name: String) -> UIImage? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagePath = path.appendingPathComponent(name)
        guard let image = UIImage(contentsOfFile: imagePath.path) else {
            return nil}
        return image
    }
    
    static func clearAllImages() {
        let myDocument = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let imageNames = try? FileManager.default.contentsOfDirectory(atPath: myDocument.path) else { return }
        for imageName in imageNames {
            let imagePath = myDocument.appendingPathComponent(imageName)
            try? FileManager.default.removeItem(at: imagePath)
        }
    }
    
    static func loadImagesDocument() -> [String: UIImage] {
        var cacheImage: [String: UIImage] = [:]
        let myPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let myDocumentPath = myPath.path
        guard let imageNames = try? FileManager.default.contentsOfDirectory(atPath: myDocumentPath) else { return [:] }
        for imageName in imageNames {
            let imagePath = myPath.appendingPathComponent(imageName)
            if let image = UIImage(contentsOfFile: imagePath.path) {
                cacheImage[imageName] = image
            } else {
                cacheImage[imageName] = nil
            }
        }
        return cacheImage
    }
    
}
