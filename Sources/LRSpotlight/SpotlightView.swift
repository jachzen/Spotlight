//
//  SpotlightView.swift
//  Gecco
//
//  Created by yukiasai on 2016/01/16.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

open class SpotlightView: UIView {

    fileprivate lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        layer.fillColor = UIColor.black.cgColor
        return layer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        layer.mask = maskLayer
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        maskLayer.frame = frame
    }

    open func appear(_ node: SpotlightNode, duration: TimeInterval = Spotlight.animationDuration) -> CGRect {
        maskLayer.add(appearAnimation(duration, node: node), forKey: nil)
        return node.target.targetView.frame
    }

    open func disappear(_ node: SpotlightNode, duration: TimeInterval = Spotlight.animationDuration) -> CGRect {
        maskLayer.add(disappearAnimation(duration, node: node), forKey: nil)
        return node.target.targetView.frame
    }

    open func move(_ toNode: SpotlightNode, duration: TimeInterval = Spotlight.animationDuration, moveType: SpotlightMoveType = .direct) -> CGRect {
        switch moveType {
        case .direct:
            moveDirect(toNode, duration: duration)
        case .disappear:
            moveDisappear(toNode, duration: duration)
        }
        return toNode.target.targetView.frame
    }
}

fileprivate extension SpotlightView {

    func moveDirect(_ toNode: SpotlightNode, duration: TimeInterval = Spotlight.animationDuration) {
        maskLayer.add(moveAnimation(duration, toNode: toNode), forKey: nil)
    }

    func moveDisappear(_ toNode: SpotlightNode, duration: TimeInterval = Spotlight.animationDuration) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            _ = self.appear(toNode, duration: duration)
        }
        _ = disappear(toNode)
        CATransaction.commit()
    }

    func maskPath(_ path: UIBezierPath) -> UIBezierPath {
        return [path].reduce(UIBezierPath(rect: frame)) {
            $0.append($1)
            return $0
        }
    }

    func appearAnimation(_ duration: TimeInterval, node: SpotlightNode) -> CAAnimation {
        let beginPath = maskPath(node.target.infinitesmalPath(translater: self))
        let endPath = maskPath(node.target.path(translater: self))
        return pathAnimation(duration, beginPath: beginPath, endPath: endPath)
    }

    func disappearAnimation(_ duration: TimeInterval, node: SpotlightNode) -> CAAnimation {
        let endPath = maskPath(node.target.infinitesmalPath(translater: self))
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }

    func moveAnimation(_ duration: TimeInterval, toNode: SpotlightNode) -> CAAnimation {
        let endPath = maskPath(toNode.target.path(translater: self))
        return pathAnimation(duration, beginPath:nil, endPath: endPath)
    }

    func pathAnimation(_ duration: TimeInterval, beginPath: UIBezierPath?, endPath: UIBezierPath) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.66, 0, 0.33, 1)
        if let path = beginPath {
            animation.fromValue = path.cgPath
        }
        animation.toValue = endPath.cgPath
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        return animation
    }
}

public enum SpotlightMoveType {
    case direct
    case disappear
}
