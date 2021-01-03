//
//  CreateItemExampleViewController.swift
//  Counters
//
//  Created by DESARROLLO on 2/01/21.
//

import UIKit

final class CreateItemExampleViewController: UIViewController {

    var router: CreateItemExampleRoutingLogic?

    // MARK: - IB Outlets
    @IBOutlet private weak var containerTitleView: UIView! {
        didSet {
            let bottomLayer = CALayer()
            let frame = containerTitleView.frame
            bottomLayer.frame = CGRect(x: 0,
                                       y: frame.height - 1,
                                       width: frame.width - 2,
                                       height: 1)
            bottomLayer.backgroundColor = UIColor.lightGray.cgColor
            containerTitleView.layer.addSublayer(bottomLayer)
            //For Shadow
            containerTitleView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            containerTitleView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            containerTitleView.layer.shadowOpacity = 1.0
            containerTitleView.layer.shadowRadius = 0.0
            containerTitleView.layer.masksToBounds = false
            containerTitleView.layer.cornerRadius = 4.0
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    private var dataProvider = CreateItemExampleDataProvider(rows: [])

    static func instantiate() -> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.createItemExamples.rawValue,
                                      bundle: .main)
        let viewController = storyboard.instantiateInitialViewController()
        return viewController
    }

    // MARK: Object lifecycle

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
        setupNavigation()
    }
}

// MARK: - Private functions
private extension CreateItemExampleViewController {

    func setup() {
        CreateItemExampleConfigurator.configure(self)
    }

    func setupNavigation() {
        showLeftBarButtonItems(navigationItem: navigationItem,
                               items: [.create])
        navigationItem.title = "Examples"
    }
}

// MARK: - NavigationConfigureProtocol
extension CreateItemExampleViewController: NavigationConfigureProtocol {
    func didTapBarItem(sender: UIBarButtonItem) {
        switch sender.tag {
        case BarButtonItemTag.create.rawValue:
            router?.navigatePopViewController()
        default:
            break
        }
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
