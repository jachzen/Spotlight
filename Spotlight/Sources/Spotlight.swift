//
//  Spotlight.swift
//  Spotlight
//
//  Created by Lekshmi Raveendranathapanicker on 2/5/18.
//  Copyright © 2018 Lekshmi Raveendranathapanicker. All rights reserved.
//

import Foundation
import UIKit

public struct Spotlight {

    public static var moveDuration: TimeInterval = 4.0
    public static var animationDuration: TimeInterval = 0.25
    public static var scrollDuration: TimeInterval = 0.3

    public init() {}
    
    public func startIntro(from controller: UIViewController, withNodes nodes: [SpotlightNode]) -> Spotlight? {
        guard nodes.count > 0 else { return nil }
        vc.spotlightNodes = nodes
        controller.present(vc, animated: true, completion: nil)
        
        vc.delegate = controller as? SpotlightDelegate
        
        return self
    }
    
    public func update(withNodes nodes: [SpotlightNode]) {
        guard nodes.count > 0 else { return }
        vc.spotlightNodes = nodes
    }

    private let vc = SpotlightViewController()
}
