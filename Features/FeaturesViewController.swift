//
//  FeaturesViewController.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import UIKit

public protocol FeaturesViewControllerDelegate: AnyObject {
    func featuresViewControllerFinished(controller: FeaturesViewController)
}

public class FeaturesViewController: UITableViewController {
    var features: [Feature]? = nil
    weak var delegate: FeaturesViewControllerDelegate? = nil

    public init(delegate: FeaturesViewControllerDelegate) {
        self.delegate = delegate
        super.init(style: .Grouped)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        features = FeatureService.featureStore.features
        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Done, target: self, action: #selector(didSelectSave))
    }

    private func configureTableView() {
        let nib = UINib(nibName: "FeatureCell", bundle: NSBundle(forClass: self.dynamicType))
        tableView.registerNib(nib, forCellReuseIdentifier: FeatureCell.reuseIdentifier)

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
    }

    @objc private func didSelectSave() {
        delegate?.featuresViewControllerFinished(self)
    }
}

extension FeaturesViewController {
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeatureCell.reuseIdentifier, forIndexPath: indexPath) as! FeatureCell
        let feature = features![indexPath.row]
        cell.nameLabel.text = feature.name
        cell.detailLabel.text = feature.platforms.debugDescription
        cell.featureActive = feature.active
        cell.delegate = self
        return cell
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features?.count ?? 0
    }
}

extension FeaturesViewController: FeatureCellDelegate {
    func cell(cell: FeatureCell, setFeatureEnabled enabled: Bool) {
        let index = tableView.indexPathForCell(cell)!

        var feature = features![index.row]
        feature.active = enabled

        FeatureService.featureStore.updateFeature(feature)
        features = FeatureService.featureStore.features
    }
}