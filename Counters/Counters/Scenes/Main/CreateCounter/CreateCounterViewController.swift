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
    }
}
