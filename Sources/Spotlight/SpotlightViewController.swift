//
//  SpotlightViewController.swift
//  Spotlight
//
//  Created by Lekshmi Raveendranathapanicker on 2/5/18.
//  Copyright © 2018 Lekshmi Raveendranathapanicker. All rights reserved.
//

import Foundation
import UIKit


final class SpotlightViewController: UIViewController {

    weak var delegate: SpotlightDelegate?
    var spotlightNodes: [SpotlightNode] = []
    var scrolled = false

    // MARK: - View Controller Life cycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpotlightView()
        setupInfoView()
        setupTapGestureRecognizer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextSpotlight()
        timer = Timer.scheduledTimer(timeInterval: Spotlight.moveDuration, target: self, selector: #selector(nextSpotlight), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()

        if let delegate = delegate {
            delegate.cleanUp()
        }
    }

    let spotlightView = SpotlightView()
    var infoLabel: UILabel!
    var infoStackView: UIStackView!
    var infoStackTopConstraint: NSLayoutConstraint!
    var infoStackBottomConstraint: NSLayoutConstraint!
    fileprivate var timer = Timer()
    fileprivate var currentNodeIndex: Int = -1
}

// MARK: - User Actions

extension SpotlightViewController {

    @objc func buttonPressed(_ button: UIButton) {
        timer.invalidate()
        guard let title = button.titleLabel?.text else { return }
        switch title {
        case ButtonTitles.getTitleFor(title: .next):
            nextSpotlight()
        case ButtonTitles.getTitleFor(title: .cancel):
            cancelSpotlight()
        case ButtonTitles.getTitleFor(title: .back):
            previousSpotlight()
        default:
            break
        }
    }

    @objc func viewTapped(_: UITapGestureRecognizer) {
        timer.invalidate()
        nextSpotlight()
    }

    @objc func nextSpotlight() {
        if let delegate = delegate {
            if delegate.scrollAfter(currentNodeIndex) {
                scrolled = true
                UIView.animate(withDuration: Spotlight.scrollDuration, delay: 0.0, options: .curveEaseOut,
                  animations: {
                    delegate.scrollTo(Spotlight.ScrollDirection.down, self.currentNodeIndex)
                }, completion: { _ in
                    self.nextOrDismissSpotlight()
                })
            }
        }

        if !scrolled {
            nextOrDismissSpotlight()
        }
        scrolled = false
    }
    
    func cancelSpotlight() {
        dismiss(animated: true, completion: nil)
    }

    func previousSpotlight() {
        if let delegate = delegate {
            if delegate.scrollAfter(currentNodeIndex - 1) {
                scrolled = true
                UIView.animate(withDuration: Spotlight.scrollDuration, delay: 0.0, options: .curveEaseOut,
                  animations: {
                    delegate.scrollTo(Spotlight.ScrollDirection.up, self.currentNodeIndex)
                }, completion: { _ in
                    self.previousOrDismissSpotlight()
                })
            }
        }

        if !scrolled {
            previousOrDismissSpotlight()
        }
        scrolled = false
    }
    
    func nextOrDismissSpotlight() {
        if currentNodeIndex == spotlightNodes.count - 1 {
            dismiss(animated: true, completion: nil)
            return
        }
        
        currentNodeIndex += 1
        showSpotlight()
    }
    
    func previousOrDismissSpotlight() {
        if currentNodeIndex == 0 {
            dismiss(animated: true, completion: nil)
            return
        }
        
        guard currentNodeIndex > 0 else { return }
        currentNodeIndex -= 1
        showSpotlight()
    }

    func showSpotlight() {
        let node = spotlightNodes[currentNodeIndex]
        let targetRect: CGRect
        switch currentNodeIndex {
        case 0:
            targetRect = spotlightView.appear(node)
        case let index where index == spotlightNodes.count:
            targetRect = spotlightView.disappear(node)
        default:
            targetRect = spotlightView.move(node)
        }

        // Animate the info label change
        view.layoutIfNeeded()
        UIView.animate(withDuration: Spotlight.animationDuration, animations: { [weak self] in
            guard let `self` = self else { return }
            if let text = node.text {
                self.infoLabel.text = text
            }
            if let attributedText = node.attributedText {
                self.infoLabel.attributedText = attributedText
            }
            if targetRect.intersects(self.infoStackView.frame) {
                if self.infoStackTopConstraint.priority == .defaultLow {
                    self.infoStackTopConstraint.priority = .defaultHigh
                    self.infoStackBottomConstraint.priority = .defaultLow
                } else {
                    self.infoStackTopConstraint.priority = .defaultLow
                    self.infoStackBottomConstraint.priority = .defaultHigh
                }
            }
            self.view.layoutIfNeeded()
        })
    }
}
