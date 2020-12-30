//
//  CounterTableViewCell.swift
//  Counters
//
//  Created by DESARROLLO on 29/12/20.
//

import UIKit

final class CounterTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var stepQuantityContainerView: UIView!
    @IBOutlet private weak var minusQuantityButton: UIButton!

    @IBOutlet private weak var plusQuantityButton: UIButton!

    @IBOutlet private weak var checkImageView: UIImageView!

    // MARK: - Lyfe cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
