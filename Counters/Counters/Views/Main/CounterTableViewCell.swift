//
//  CounterTableViewCell.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol CounterViewDelegate: class {
    func counterViewDidTapIncrementCounter(_ counter: CounterModel)
    func counterViewDidTapDecrementCounter(_ counter: CounterModel)
}

final class CounterTableViewCell: UITableViewCell {

    // MARK: - Model
    private var counterModel: CounterModel?

    // MARK: - IBOutlets
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var quantityContainerView: CustomizedView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var containerDataView: UIView! {
            didSet {
                containerDataView.layer.cornerRadius = 8
            }
    }
    @IBOutlet private weak var stepQuantityContainerView: UIView! {
        didSet {
            stepQuantityContainerView.layer.cornerRadius = 8
        }
    }
    @IBOutlet private weak var minusQuantityButton: UIButton!
    @IBOutlet private weak var plusQuantityButton: UIButton!
    @IBOutlet private weak var containerCheckView: UIView!
    @IBOutlet private weak var checkImageView: UIImageView!

    private weak var delegate: CounterViewDelegate?

    // MARK: - Lyfe cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Private functions
private extension CounterTableViewCell {
    func updateUI() {
        checkImageView.layer.cornerRadius = checkImageView.frame.width / 2
        quantityContainerView.stopActivityIndicator(animated: true)
    }

    // MARK: - IBActions
    @IBAction func didTapMinusCounter(_ sender: Any) {
        guard let counterModel = self.counterModel else {
            return
        }
        quantityContainerView.startActivityIndicator()
        delegate?.counterViewDidTapDecrementCounter(counterModel)
    }

    @IBAction func didTapPlusCounter(_ sender: Any) {
        guard let counterModel = self.counterModel else {
            return
        }
        quantityContainerView.startActivityIndicator()
        delegate?.counterViewDidTapIncrementCounter(counterModel)
    }
}

// MARK: - MainConfigurable
extension CounterTableViewCell: MainConfigurable {

    func configure(with viewModel: MainViewModel, parent: AnyObject) {
        updateUI()
        let counterModel = viewModel.counter
        self.counterModel = counterModel
        if isEditing {
            if counterModel.isSelected {
                checkImageView.image = UIImage(systemName: "checkmark.circle")
                checkImageView.tintColor = UIColor.color(named: .white)
                checkImageView.backgroundColor = UIColor.color(named: .orange)
            } else {
                checkImageView.image = UIImage(systemName: "poweroff")
                checkImageView.tintColor = UIColor.color(named: .grayLightColor)
                checkImageView.backgroundColor = UIColor.clear
            }
        }
        containerCheckView.isHidden = !isEditing
        quantityLabel.text = "\(counterModel.count)"
        nameLabel.text = counterModel.title
        delegate = parent as? CounterViewDelegate
        quantityLabel.textColor = counterModel.count == 0 ? UIColor.color(named: .grayLightColor) :
            UIColor.color(named: .orange)
    }
}
