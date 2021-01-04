//
//  GenericMessageView.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

protocol GenericMessageViewDelegate: AnyObject {
    func didTapActionButton(action: MessageModel.ButtonItem)
}

final class GenericMessageView: UIView, NibLoadableView {

    private var action: MessageModel.ButtonItem?

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
        self.action = message.action
        titleLabel.text = message.title
        messageLabel.text = message.description
        actionButton.setTitle(message.action?.title, for: .normal)
    }
}

// MARK: IBActions
private extension GenericMessageView {
    @IBAction func didTapAction(_: Any) {
        guard let action = action else {
            return
        }
        delegate?.didTapActionButton(action: action)
    }
}
