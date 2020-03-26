//
//  SpringBoardCollectionViewCell.swift
//  springboard
//
//  Created by lamha on 3/26/20.
//  Copyright © 2020 lam.pte. All rights reserved.
//

import UIKit

class SpringBoardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Logic
    
    func stopLoading() {
        contentImageView.image = nil
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func startLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
}
