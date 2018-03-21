//
//  SpotlightDelegate.swift
//  LRSpotlight
//
//  Created by Michael Mather on 15.02.18.
//

import Foundation


public protocol SpotlightDelegate {
    
    func cleanUp()
    func scrollTo(_ tag: String)
    func scrollAfter(_ index: Int) -> Bool
    
}

public extension SpotlightDelegate {
    
    func scrollTo(_ tag: String) {
    }
    
    func scrollAfter(_ index: Int) -> Bool {
        return false
    }

}
