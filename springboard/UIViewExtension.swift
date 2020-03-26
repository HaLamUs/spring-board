//
//  UIViewExtension.swift
//  springboard
//
//  Created by lamha on 3/26/20.
//  Copyright © 2020 lam.pte. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
