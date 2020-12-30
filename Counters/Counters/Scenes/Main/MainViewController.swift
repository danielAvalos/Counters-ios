//
//  MainViewController.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol MainDisplayLogic: class {
}

final class MainViewController: UIViewController {

    var interactor: (MainBusinessLogic & MainDataStore)?
    var router: MainRoutingLogic?
    var isopenSearch: Bool = false

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addContainerView: UIView!
    @IBOutlet private weak var addButton: UIButton!

    static func instantiate() -> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.main.rawValue,
                                      bundle: .main)
        let viewController = storyboard.instantiateInitialViewController()
        return viewController
    }

    lazy var searchController: UISearchController = {
        UISearchController()
    }()

    private lazy var refreshControl: UIRefreshControl = { [unowned self] in
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshMain(sender:)), for: .valueChanged)
        return refreshControl
    }()

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

// MARK: - Private functions

private extension MainViewController {
    func setup() {
    }

    func setupNavigation() {
        navigationItem.title = "Categorias"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - Actions

    @objc
    func refreshMain(sender _: UIRefreshControl) {
        //interactor?.prepareCategories()
        refreshControl.endRefreshing()
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        navigationItem.title = "Counters Search"
        guard isopenSearch else {
            return
        }
        interactor?.filterContent(forQuery: searchController.searchBar.text)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchControllerDelegate {

    func willPresentSearchController(_ searchController: UISearchController) {
        isopenSearch = true
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        isopenSearch = false
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            navigationItem.title = "Counters"
            return
        }
        navigationItem.title = "Search result"
    }
}
