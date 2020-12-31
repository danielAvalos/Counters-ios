//
//  CustomizedView.swift
//  Counters
//
//  Created by DESARROLLO on 30/12/20.
//

import UIKit

@IBDesignable class CustomizedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        sharedInit()
    }

    private func sharedInit() {
        layer.cornerRadius = cornerRadius
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
