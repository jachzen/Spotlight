//
//  UIKitExtensions.swift
//  Spotlight
//
//  Created by Lekshmi Raveendranathapanicker on 2/5/18.
//  Copyright © 2018 Lekshmi Raveendranathapanicker. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    func embedAndpin(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(self, at: 0)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension UIColor {
    
    static var adaptiveLabel: UIColor {
        if #available(iOS 13, *) {
            return UIColor.label
        } else {
            return UIColor.adaptiveBlack
        }
    }
 
    static var adaptiveBlack: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            }
        } else {
            return UIColor.black
        }
    }
    
    static var adaptiveWhite: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.black
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }

}

