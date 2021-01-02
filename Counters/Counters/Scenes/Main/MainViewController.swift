//
//  MainViewController.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol MainDisplayLogic: class {
    func displayCounters(_ viewmodel: [MainViewModel])
}

final class MainViewController: UIViewController {

    var interactor: (MainBusinessLogic & MainDataStore)?
    var router: MainRoutingLogic?
    var isopenSearch: Bool = false

    private var dataProvider = MainDataProvider(rows: [])

    // MARK: - IBOutlets

    @IBOutlet private weak var itemsSelectedLabel: UILabel!
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
        setupTableView()
        interactor?.prepareCountersList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - MainDisplayLogic
extension MainViewController: MainDisplayLogic {

    func displayCounters(_ viewmodel: [MainViewModel]) {
        dataProvider.update(rows: viewmodel)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Private functions

private extension MainViewController {
    func setup() {
        MainConfigurator.configure(self)
    }

    func setupNavigation() {
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .plain,
                                         target: self,
                                         action: #selector(editCounters(sender:)))
        navigationItem.leftBarButtonItem = editButton
        navigationItem.title = "Counters"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupTableView() {
        tableView.layer.shadowOpacity = 0.05
        tableView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableView.registerCells([CounterTableViewCell.self])
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Actions

    @objc
    func refreshMain(sender _: UIRefreshControl) {
        refreshControl.endRefreshing()
        interactor?.prepareCountersList()
    }

    @objc
    func editCounters(sender _: UIBarButtonItem) {
        isEditing = true
        tableView.reloadData()
    }

    @IBAction func didTapAction(_ sender: Any) {
        router?.navigateToNewCounter()
    }

    @IBAction func didTapDelete(_ sender: Any) {
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
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

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        dataProvider.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataProvider.numberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_unwrapping
        let viewModel = self.dataProvider[indexPath]!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CounterTableViewCell.reuseIdentifier) else {
            fatalError("Main Section Cell Not Found - Reuse identifier: \(CounterTableViewCell.reuseIdentifier)")
        }
        guard let configurableCell = cell as? MainConfigurable else {
            fatalError("Main Section Cell Must Conform with MainnConfigurable")
        }
        cell.isEditing = isEditing
        configurableCell.configure(with: viewModel, parent: self)
        return cell
    }
}

// MARK: - CounterViewDelegate
extension MainViewController: CounterViewDelegate {

    func counterViewDidTapIncrementCounter(_ product: CounterModel) {
        showAlert(title: "INCREMENT", message: "SUCC")
    }

    func counterViewDidTapDecrementCounter(_ product: CounterModel) {
        showAlert(title: "DECREMENT", message: "SUCC")
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            let viewModel = self.dataProvider[indexPath]!
            viewModel.counter.isSelected = !viewModel.counter.isSelected
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
