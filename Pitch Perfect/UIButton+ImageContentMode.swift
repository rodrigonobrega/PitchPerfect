//
//  UIButton+AspectFit.swift
//  Pitch Perfect
//
//  Created by Rodrigo Nobrega on 18/06/2018.
//  Copyright © 2018 Rodrigo Nóbrega. All rights reserved.
//

import UIKit

extension UIButton {
    
    // MARK: draw for change content mode in imageView from all UIButtons
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let imageView = self.imageView {
            imageView.contentMode = .scaleAspectFit
        }
    }
}
