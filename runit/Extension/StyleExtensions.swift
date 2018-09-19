//
//  StyleExtensions.swift
//  runit
//
//  Created by Denise NGUYEN on 14/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import Foundation

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.cornerRadius = 5
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = RIColors.CYAN.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.1
        
    }
}
