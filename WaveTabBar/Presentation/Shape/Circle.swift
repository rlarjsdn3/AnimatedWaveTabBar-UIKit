//
//  CircleView.swift
//  UIKitTemplate
//
//  Created by 김건우 on 5/10/25.
//

import UIKit

final class Circle: UIView {
    
    /// <#Description#>
    override var tintColor: UIColor? {
        didSet { self.setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = createPath(rect)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = tintColor?.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    /// <#Description#>
    /// - Parameter rect: <#rect description#>
    /// - Returns: <#description#>
    func createPath(_ rect: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: rect)
    }
}
#Preview {
    let circle = Circle()
    circle.tintColor = UIColor.red
    return circle
}
