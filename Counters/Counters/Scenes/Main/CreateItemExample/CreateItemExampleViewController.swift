//
//  CreateItemExampleViewController.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import UIKit

final class CreateItemExampleViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private var dataProvider = CreateItemExampleDataProvider(rows: [])

    static func instantiate() -> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.createItemExamples.rawValue,
                                      bundle: .main)
        let viewController = storyboard.instantiateInitialViewController()
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension CreateItemExampleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        dataProvider.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataProvider.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_unwrapping
        let viewModel = self.dataProvider[indexPath]!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemExamplesCollectionViewCell.reuseIdentifier) else {
            fatalError("Main Section Cell Not Found - Reuse identifier: \(CounterTableViewCell.reuseIdentifier)")
        }
        guard let configurableCell = cell as? MainConfigurable else {
            fatalError("Main Section Cell Must Conform with MainnConfigurable")
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateItemExampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
