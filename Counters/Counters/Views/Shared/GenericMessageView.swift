//
//  GenericMessageView.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol GenericMessageViewDelegate: AnyObject {
    func didTapActionButton()
}

final class GenericMessageView: UIView, NibLoadableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton! {
        didSet {
            actionButton.layer.cornerRadius = 8
        }
    }

    // MARK: Public variables
    weak var delegate: GenericMessageViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension GenericMessageView {
    func configureView(message: MessageModel) {
        titleLabel.text = message.title
        messageLabel.text = message.description
        actionButton.setTitle(message.titleAction, for: .normal)
    }
}

// MARK: IBActions
private extension GenericMessageView {
    @IBAction func didTapAction(_: Any) {
        delegate?.didTapActionButton()
    }
}
