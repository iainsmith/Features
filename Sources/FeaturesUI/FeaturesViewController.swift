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

class BundleMarker {}
let bundle = Bundle(for: BundleMarker.self)

public class FeaturesViewController: UITableViewController {
    var features: [Feature] = []
    var groupedBy: [String: [Feature]] = [:]
    var headerView: FeaturesHeaderView? = nil

    weak var delegate: FeaturesViewControllerDelegate? = nil

    public convenience init(delegate: FeaturesViewControllerDelegate) {
        self.init(style: .grouped)
        self.delegate = delegate
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidLoad() {
        let features = FeatureService.featureStore.features
        groupedBy = Dictionary(grouping: features) { $0.section ?? "" }

        navigationItem.title = "Features"

        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didSelectSave))
    }

    private func configureTableView() {
        let nib = UINib(nibName: "FeatureCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: FeatureCell.reuseIdentifier)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false

        headerView = FeaturesHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70), delegate: self)

        headerView?.percentage = FeatureService.featureStore.devicePercentage
        tableView.tableHeaderView = headerView

    }

    @objc private func didSelectSave() {
        delegate?.featuresViewControllerFinished(controller: self)
    }
}

extension FeaturesViewController: FeaturesHeaderViewDelegate {
    func didUpdateDevicePercentage(percentage: UInt) {
        FeatureService.updatePercentage(percentage)
        headerView?.percentage = FeatureService.featureStore.devicePercentage
    }
}

extension FeaturesViewController {
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureCell.reuseIdentifier, for: indexPath) as! FeatureCell

        let key = keyForSection(index: indexPath.section)
        let features = groupedBy[key]!

        let feature = features[indexPath.row]
        cell.nameLabel.text = feature.name
        cell.detailLabel.text = feature.platforms.displayString
        cell.featureActive = feature.active
        cell.delegate = self
        return cell
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keyForSection(index: section)
        return groupedBy[key]!.count
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedBy.keys.count
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyForSection(index: section)
    }
}

extension FeaturesViewController {
    private func keyForSection(index: Int) -> String {
        let sortedKeys = groupedBy.keys.sorted()
        return sortedKeys[index]
    }

    private func featureForIndexPath(indexPath: IndexPath) -> Feature {
        let key = keyForSection(index: indexPath.section)
        let features = groupedBy[key]!
        return features[indexPath.row]
    }
}

extension FeaturesViewController: FeatureCellDelegate {
    func cell(cell: FeatureCell, setFeatureEnabled enabled: Bool) {
        let index = tableView.indexPath(for: cell)!

        let existingFeature = featureForIndexPath(indexPath: index)
        let newFeature = Feature(name: existingFeature.name, rolloutPercentage: existingFeature.rolloutPercentage, platforms: existingFeature.platforms, section: existingFeature.section, active: enabled)

        let newStore = FeatureService.featureStore.featureStoreByUpdatingFeature(feature: newFeature)
        FeatureService.featureStore = newStore
        features = newStore.features
    }
}

