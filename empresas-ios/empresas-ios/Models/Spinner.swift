//
//  Spinner.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 11/04/21.
//

import Foundation
import MaterialComponents.MDCActivityIndicator

class Spinner {
    private let outerIndicator = MDCActivityIndicator()
    private let innerIndicator = MDCActivityIndicator()
    private var spinnerView: UIView?
    private var blackView: UIView?
    private var mainView: UIView?

    init(_ spinnerView: UIView, _ blackView: UIView?, _ mainView: UIView) {

        self.spinnerView = spinnerView
        self.blackView = blackView
        self.mainView = mainView

        configureOuterIndicator()
        configureInnerIndicator()

        spinnerView.addSubview(outerIndicator)
        spinnerView.addSubview(innerIndicator)
        if let blackView = blackView {
            mainView.bringSubviewToFront(blackView)
        }
        mainView.bringSubviewToFront(spinnerView)

        centerView(outerIndicator, mainView)
        centerView(innerIndicator, mainView)

        outerIndicator.layoutIfNeeded()
        innerIndicator.layoutIfNeeded()
    }

    private func configureOuterIndicator() {
        outerIndicator.radius = 35
        outerIndicator.progress = 0.8
        outerIndicator.cycleColors = [UIColor.white]
        outerIndicator.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
    }

    private func configureInnerIndicator() {
        innerIndicator.radius = 25
        innerIndicator.progress = 0.8
        innerIndicator.cycleColors = [UIColor.white]
        innerIndicator.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        innerIndicator.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

    private func centerView(_ firstView: UIView, _ secondView: UIView) {
        let xConstraint = NSLayoutConstraint(item: firstView,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: secondView,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let yConstraint = NSLayoutConstraint(item: firstView,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: secondView,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)
        secondView.addConstraints([xConstraint, yConstraint])
    }

    func startAnimating() {
        self.blackView?.isHidden = false
        outerIndicator.startAnimating()
        innerIndicator.startAnimating()
    }

    func stopAnimating() {
        self.blackView?.isHidden = true
        outerIndicator.stopAnimating()
        innerIndicator.stopAnimating()
    }

    func changeSpinnerColor(_ colors: [UIColor]) {
        self.outerIndicator.cycleColors = colors
        self.innerIndicator.cycleColors = colors
    }
}
