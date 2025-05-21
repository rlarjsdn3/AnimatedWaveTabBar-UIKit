//
//  Wavy.swift
//  UIKitTemplate
//
//  Created by 김건우 on 5/10/25.
//

import UIKit

final class Wavy: UIView {
    
    /// <#Description#>
    private var offsetX: CGFloat
    
    /// <#Description#>
    /// - Parameter offsetX: <#offsetX description#>
    init(offsetX: CGFloat = 0) {
        self.offsetX = offsetX
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = createPath(rect, offsetX: offsetX)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
    }

    /// <#Description#>
    /// - Parameters:
    ///   - rect: <#rect description#>
    ///   - midX: <#midX description#>
    /// - Returns: <#description#>
    func createPath(_ rect: CGRect, offsetX midX: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.move(to: CGPoint(x: midX - 40.0, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: midX, y: rect.maxY - 20.0),
            controlPoint1: CGPoint(x: midX - 15.0, y: rect.maxY),
            controlPoint2: CGPoint(x: midX - 15.0, y: rect.maxY - 20.0)
        )
        path.addCurve(
            to: CGPoint(x: midX + 40, y: rect.maxY),
            controlPoint1: CGPoint(x: midX + 15, y: rect.maxY - 20),
            controlPoint2: CGPoint(x: midX + 15, y: rect.maxY)
        )
        path.close()

        return path
    }
}


#Preview {
    Wavy(offsetX: 200)
}
