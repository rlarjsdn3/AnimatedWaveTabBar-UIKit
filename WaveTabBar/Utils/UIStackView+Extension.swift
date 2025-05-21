//
//  UIStackView+Extension.swift
//  UIKitTemplate
//
//  Created by 김건우 on 5/10/25.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
    
    func removeAllArragedSubviews() {
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
        }
    }
    
    func replaceArrangedSubviews(_ views: [UIView]) {
        self.removeAllArragedSubviews()
        self.addArrangedSubviews(views)
    }
}
