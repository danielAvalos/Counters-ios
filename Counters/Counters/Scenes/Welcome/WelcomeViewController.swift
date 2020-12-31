//
//  WelcomeViewController.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

final class WelcomeViewController: UIViewController {

    //var interactor: (HomeBusinessLogic & HomeDataStore)?
    var router: WelcomeRoutingLogic?

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerTutorialStackView: UIStackView!
    @IBOutlet private weak var continueButton: UIButton!

    static func instantiate() -> UIViewController? {
        let storyboard = UIStoryboard(name: StoryboardName.welcome.rawValue,
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
        loadData()
    }
}

// MARK: - Private functions

private extension WelcomeViewController {

    func setup() {
        WelcomeConfigurator.configure(self)
    }

    func loadData() {
        let firtsLetterAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color(named: .black) ?? UIColor.black,
                                     .font: UIFont.systemFont(ofSize: 33)]

        let secondsLetterAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color(named: .orange) ?? UIColor.orange,
                                       .font: UIFont.systemFont(ofSize: 33)]

        let attributeText = NSMutableAttributedString(string: "Welcome to \n",
                                           attributes: firtsLetterAttributes)
        let counterText = NSAttributedString(string: "Counters",
                                             attributes: secondsLetterAttributes)
        attributeText.append(counterText)
        titleLabel.attributedText = attributeText

        continueButton.layer.cornerRadius = 8
        continueButton.layer.shadowOpacity = 0.05
        continueButton.layer.shadowColor = UIColor.color(named: .black)?.cgColor ?? UIColor.black.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

// MARK: - IBActions

private extension WelcomeViewController {
    @IBAction func didTapContinue(_ sender: Any) {
        router?.navigateToMain()
    }
}
