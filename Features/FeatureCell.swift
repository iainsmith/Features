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

extension CGRect {
    func edgeInset(insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: self.minX + insets.left, y: self.minY + insets.top, width: self.width - insets.left - insets.right, height: self.height - insets.top - insets.bottom);
    }
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

    override func layoutSubviews() {
        super.layoutSubviews()
        let totalIndentation = CGFloat(indentationLevel) * indentationWidth
        contentView.frame = contentView.frame.edgeInset(UIEdgeInsets(top: 0, left: totalIndentation, bottom: 0, right: 0))
    }
}
