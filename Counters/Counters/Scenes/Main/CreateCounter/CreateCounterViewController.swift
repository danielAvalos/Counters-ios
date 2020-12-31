//
//  CreateCounterViewController.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

final class CreateCounterViewController: UIViewController {

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

// MARK: - Private functions

private extension CreateCounterViewController {

    func setup() {
    }

    func setupNavigation() {
        navigationItem.backButtonTitle = "Cancel"
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(saveCounter(sender:)))
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                         style: .plain,
                                         target: self,
                                         action: #selector(cancelCounter(sender:)))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Create a counter"
    }

    @objc
    func saveCounter(sender _: UIBarButtonItem) {
        showAlert(title: "Successful", message: "Counter Saved", customActionTitle: "OK") { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    @objc
    func cancelCounter(sender _: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
