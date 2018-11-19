//
//  IndentedLabel.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 11/18/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {

    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }

}
