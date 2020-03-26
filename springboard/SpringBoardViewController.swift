//
//  SpringBoardViewController.swift
//  springboard
//
//  Created by lamha on 3/26/20.
//  Copyright © 2020 lam.pte. All rights reserved.
//

import UIKit

class SpringBoardViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var springBoardCollectionView: UICollectionView!
    
    //MARK: Properties
    
    var cacheImage: [String: UIImage] = [:]
    var downloadingTasks: [String: Operation] = [:]
    lazy var downLoadPhotoQueue: OperationQueue = {
        $0.name = "Download Photo"
        $0.maxConcurrentOperationCount = 1
        return $0
    }(OperationQueue())
    
    //MARK: Constant
    
    let cellId = "SpringBoardCollectionViewCell"
    let imageUrl = "https://loremflickr.com/200/200"
    let numberOfNewImages = 140
    var numberOfImages = 0
    let numberOfRows: CGFloat = 7
    let numberOfColumns: CGFloat = 10
    let imageSpacing: CGFloat = 2
    
    // MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let id = numberOfImages
        numberOfImages += 1
        let imageName = "image_" + "\(id)" + ".jpg"
        let index = IndexPath(item: id, section: 0)
        let photoDownloader = DownloadImage(key: "\(id)",
            photoURL: imageUrl,
            photoName: imageName,
            indexPath: index,
            delegate: self)
        startDownloadPhoto(photoDownloader)
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIBarButtonItem) {
        UIImage.clearAllImages()
        cacheImage = [:]
        numberOfImages = numberOfNewImages // load 140 new
        UIView.performWithoutAnimation {
            self.springBoardCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    //MARK: View Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get all images in local storage
        cacheImage = UIImage.loadImagesDocument()
        numberOfImages = cacheImage.count > numberOfNewImages ? cacheImage.count : numberOfNewImages
    }
}


extension SpringBoardViewController {
    
    func loadImageForCell(_ index: IndexPath) -> UIImage? {
        let id = String(index.row)
        let imageName = "image_" + id + ".jpg"
        if let imageInMem  = cacheImage[imageName] {
            return imageInMem
        }
        else if let imageInLocal = UIImage.loadImageFromPath(name: imageName) {
            cacheImage[imageName] = imageInLocal
            return cacheImage[imageName]
        }
        else {
            if !springBoardCollectionView.isDecelerating {
                let photoDownloader = DownloadImage(key: id,
                                                    photoURL: imageUrl,
                                                    photoName: imageName,
                                                    indexPath: index,
                                                    delegate: self)
                startDownloadPhoto(photoDownloader)
            }
        }
        return nil
    }
    
    func startDownloadPhoto(_ downloader: DownloadImage) {
        if (downloadingTasks[downloader.key] != nil) { return }
        downLoadPhotoQueue.addOperation(downloader)
        downloadingTasks[downloader.key] = downloader
    }
}

//MARK: UICollectionViewDelegate

extension SpringBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/numberOfColumns - imageSpacing, height: collectionView.bounds.size.height/numberOfRows - imageSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SpringBoardCollectionViewCell
        cell.stopLoading()
        if let imageForCell = loadImageForCell(indexPath) {
            DispatchQueue.main.async {
                cell.contentImageView.image = imageForCell
            }
        } else {
            cell.startLoading()
        }
        cell.roundCorners(radius: 7)
        
        return cell
    }
    
    //remove all downloading task when scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if downloadingTasks.count > 0 {
            downLoadPhotoQueue.cancelAllOperations()
            downloadingTasks.removeAll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if cacheImage.count < numberOfImages {
            UIView.performWithoutAnimation {
                self.springBoardCollectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
}

//MARK: DownloadImageDelegate

extension SpringBoardViewController: DownloadImageDelegate {
    
    func downloadPhotoDidFinish(_ operation: DownloadImage, image: UIImage) {
        cacheImage[operation.photoName] = image
        downloadingTasks.removeValue(forKey: operation.key)
        //        print(operation.indexPath)
        let index = operation.indexPath
        guard let cell = springBoardCollectionView.cellForItem(at: index) else {
            if index.row >= numberOfImages - 1 {
                springBoardCollectionView.insertItems(at: [index])
                springBoardCollectionView.scrollToItem(at: index, at: .right, animated: true)
            }
            return
        }
        let springCell = cell as! SpringBoardCollectionViewCell
        springCell.stopLoading()
        springBoardCollectionView.reloadItems(at: [index])
    }
    
    func downloadPhotoDidFail(_ operation: DownloadImage) {
        print("Error: downloadPhotoDidFail")
        downloadingTasks.removeValue(forKey: operation.key)
    }
}
