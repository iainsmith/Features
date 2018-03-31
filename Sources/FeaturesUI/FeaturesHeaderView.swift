//
//  FeaturesHeaderView.swift
//  Features
//
//  Created by iainsmith on 12/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import Foundation
import UIKit

let iOSBundle = Bundle(for: FeaturesHeaderView.self)

protocol FeaturesHeaderViewDelegate: AnyObject {
    func didUpdateDevicePercentage(percentage: UInt)
}

class FeaturesHeaderView: UIView {
    weak var delegate: FeaturesHeaderViewDelegate?

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var percentageLabel: UILabel!

    var percentage: UInt {
        get {
            return UInt(stepper.value)
        }

        set {
            stepper.value = Double(newValue)
            percentageLabel.text = "\(newValue)%"
        }
    }

    init(frame: CGRect, delegate: FeaturesHeaderViewDelegate?) {
        self.delegate = delegate
        super.init(frame: frame)
        let view = iOSBundle.loadNibNamed("FeaturesHeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = frame
        self.addSubview(view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didUpdatePercentage(sender: UIStepper) {
        delegate?.didUpdateDevicePercentage(percentage: UInt(sender.value))
    }
}
