//
//  CreateCounterViewController.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol CreateCounterDisplayLogic: class {
    func displaySavedStatus(viewModel: CreateCounterViewModel)
}

final class CreateCounterViewController: UIViewController {

    var interactor: CreateCounterBusinessLogic?
    var router: CreateCounterRoutingLogic?

    // MARK: - IBOutlets
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var moreExamplesButton: UIButton!

    static func instantiate() -> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.create.rawValue,
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

// MARK: - NavigationConfigureProtocol
extension CreateCounterViewController: NavigationConfigureProtocol {
    func didTapBarItem(sender: UIBarButtonItem) {
        switch sender.tag {
        case BarButtonItemTag.cancel.rawValue:
            router?.navigatePopViewController()
            navigationController?.popViewController(animated: true)
        case BarButtonItemTag.save.rawValue:
            interactor?.saveCounter(title: nameTextField.text ?? "")
        default:
            break
        }
    }
}

// MARK: - CreateCounterDisplayLogic
extension CreateCounterViewController: CreateCounterDisplayLogic {
    func displaySavedStatus(viewModel: CreateCounterViewModel) {
        showAlert(title: viewModel.title, message: viewModel.message, customActionTitle: "Continue") { [weak self] _ in
            if viewModel.status == .successful {
                self?.router?.navigatePopViewController()
            }
        }
    }
}

// MARK: - Private functions

private extension CreateCounterViewController {

    func setup() {
        CreateCounterConfigurator.configure(self)
    }

    func setupNavigation() {
        showLeftBarButtonItems(navigationItem: navigationItem,
                               items: [.cancel])
        showRightBarButtonItems(navigationItem: navigationItem,
                                items: [.save])
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Create a counter"
    }

    @IBAction func didTapMoreExamples(_ sender: Any) {
        router?.navigateToShowExample()
    }
}
