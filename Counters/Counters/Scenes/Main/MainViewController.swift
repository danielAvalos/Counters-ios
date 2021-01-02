//
//  MainViewController.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol MainDisplayLogic: class {
    func displayCounters(_ viewmodel: [MainViewModel], message: String)
    func displayCountersShare(_ textToShare: String)
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
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.imageView?.tintColor = UIColor.color(named: .orange)
        }
    }
    @IBOutlet private weak var deleteButton: UIButton! {
        didSet {
            deleteButton.imageView?.tintColor = UIColor.color(named: .orange)
        }
    }

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
        if CoreDataManager.isDataChanged {
            interactor?.prepareCountersList()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - NavigationConfigureProtocol
extension MainViewController: NavigationConfigureProtocol {
    func didTapBarItem(sender: UIBarButtonItem) {
        switch sender.tag {
        case BarButtonItemTag.edit.rawValue:
            interactor?.isEditing = true
            tableView.reloadData()
            showLeftBarButtonItems(navigationItem: navigationItem, items: [.done])
            showRightBarButtonItems(navigationItem: navigationItem, items: [.selectAll])
            deleteButton.isHidden = false
            actionButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        case BarButtonItemTag.selectAll.rawValue:
            interactor?.select(isSelectAll: true)
            showRightBarButtonItems(navigationItem: navigationItem, items: [.unselectAll])
        case BarButtonItemTag.unselectAll.rawValue:
            interactor?.select(isSelectAll: false)
            showRightBarButtonItems(navigationItem: navigationItem, items: [.selectAll])
        case BarButtonItemTag.done.rawValue:
            interactor?.isEditing = false
            tableView.reloadData()
            deleteButton.isHidden = true
            actionButton.setImage(UIImage(systemName: "plus"), for: .normal)
            showLeftBarButtonItems(navigationItem: navigationItem, items: [.edit])
            showRightBarButtonItems(navigationItem: navigationItem, items: [])
        default:
            break
        }
    }
}

// MARK: - MainDisplayLogic
extension MainViewController: MainDisplayLogic {

    func displayCountersShare(_ textToShare: String) {
        guard let url = URL(string: textToShare) else {
            return
        }
        UIApplication.shared.open(url) { (result) in
            if result {
            }
        }
    }

    func displayCounters(_ viewmodel: [MainViewModel], message: String) {
        dataProvider.update(rows: viewmodel)
        if !viewmodel.isEmpty && interactor?.isEditing == false {
            showLeftBarButtonItems(navigationItem: navigationItem, items: [.edit])
            itemsSelectedLabel.text = message
            itemsSelectedLabel.isHidden = false
        } else {
            itemsSelectedLabel.isHidden = true
        }
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
        navigationItem.title = "Counters"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        deleteButton.isHidden = interactor?.isEditing == false
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
        interactor?.prepareCountersList()
        refreshControl.endRefreshing()
    }

    @IBAction func didTapAction(_ sender: Any) {
        if interactor?.isEditing == true {
            interactor?.shareCountersSelected()
        } else {
            router?.navigateToNewCounter()
        }
    }

    @IBAction func didTapDelete(_ sender: Any) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        alertController
            .popoverPresentationController?
            .sourceRect = CGRect(x: 0,
                                 y: UIScreen.main.bounds.height / 2,
                                 width: UIScreen.main.bounds.width,
                                 height: 0)
        let deleteAction = UIAlertAction(title: "Delete 5 Counters",
                                         style: .destructive) { [weak self] _ in
            self?.interactor?.deleteSelected()
        }
        alertController.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        present(alertController,
                animated: true,
                completion: nil)
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

// MARK: - CounterViewDelegate
extension MainViewController: CounterViewDelegate {

    func counterViewDidTapIncrementCounter(_ counter: CounterModel) {
        interactor?.incrementCounter(counter: counter)
    }

    func counterViewDidTapDecrementCounter(_ counter: CounterModel) {
        interactor?.decrementCounter(counter: counter)
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
        cell.isEditing = interactor?.isEditing ?? false
        configurableCell.configure(with: viewModel, parent: self)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if interactor?.isEditing == true {
            let viewModel = self.dataProvider[indexPath]!
            viewModel.counter.isSelected = !viewModel.counter.isSelected
            interactor?.select(counterModel: viewModel.counter)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
