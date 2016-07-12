//
//  FeaturesViewController.swift
//  Features
//
//  Created by iainsmith on 11/07/2016.
//  Copyright © 2016 M23. All rights reserved.
//

import UIKit

@objc public protocol FeaturesViewControllerDelegate: AnyObject {
    func featuresViewControllerFinished(controller: FeaturesViewController)
}

public extension SequenceType {
    func groupBy<U: Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}


public class FeaturesViewController: UITableViewController {
    var features: [Feature]? = nil
    var groupedBy: [String: [Feature]]? = nil

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
        groupedBy = features!.groupBy { feature in
            return feature.section.name
        }

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

        let key = keyForSection(indexPath.section)
        let features = groupedBy![key]!

        let feature = features[indexPath.row]
        cell.nameLabel.text = feature.name
        cell.detailLabel.text = feature.platforms.debugDescription
        cell.featureActive = feature.active
        cell.delegate = self
        return cell
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keyForSection(section)
        return groupedBy![key]!.count
    }

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupedBy!.keys.count
    }

    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyForSection(section)
    }
}

extension FeaturesViewController {
    private func keyForSection(index: Int) -> String {
        let sortedKeys = groupedBy!.keys.sort()
        return sortedKeys[index]
    }

    private func featureForIndexPath(indexPath: NSIndexPath) -> Feature {
        let key = keyForSection(indexPath.section)
        let features = groupedBy![key]!
        return features[indexPath.row]
    }
}

extension FeaturesViewController: FeatureCellDelegate {
    func cell(cell: FeatureCell, setFeatureEnabled enabled: Bool) {
        let index = tableView.indexPathForCell(cell)!

        var feature = featureForIndexPath(index)
        feature.active = enabled

        FeatureService.featureStore.updateFeature(feature)
        features = FeatureService.featureStore.features
    }
}