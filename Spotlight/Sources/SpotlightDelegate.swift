//
//  SpotlightDelegate.swift
//  LRSpotlight
//
//  Created by Michael Mather on 15.02.18.
//

import Foundation


public protocol SpotlightDelegate: class {
    
    func cleanUp()
    func scrollTo(_ direction: Spotlight.ScrollDirection, _ index: Int)
    func scrollAfter(_ index: Int) -> Bool
    
}

public extension SpotlightDelegate {
    
    func scrollTo(_ direction: Spotlight.ScrollDirection, _ index: Int) {
    }
    
    func scrollAfter(_ index: Int) -> Bool {
        return false
    }

}
