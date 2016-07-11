//
//  FeatureCell.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import UIKit

protocol FeatureCellDelegate: AnyObject {
    func cell(cell: FeatureCell, setFeatureEnabled: Bool)
}

internal class FeatureCell: UITableViewCell {
    internal weak var delegate: FeatureCellDelegate?
    static var reuseIdentifier = "com.features.featurecell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!

    override var reuseIdentifier: String? {
        return FeatureCell.reuseIdentifier
    }

    @IBAction func updatedToggle(sender: UISwitch) {
        featureActive = sender.on
        delegate?.cell(self, setFeatureEnabled: featureActive)
    }

    var featureActive: Bool {
        get {
            return toggle.on
        }

        set {
            toggle.on = newValue
        }
    }
}
