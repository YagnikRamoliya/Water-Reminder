import UIKit

class CurvedTabBar: UITabBar {

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
        
    }
    
    

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 2)
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowRadius = 4

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 20
        let radius: CGFloat = 36
        let padding: CGFloat = 16 // left/right padding
        let bottomPadding: CGFloat = -20 // bottom se upar uthana

        let centerWidth = self.frame.width / 2

        let path = UIBezierPath()
        // Start point with left padding
        path.move(to: CGPoint(x: padding, y: bottomPadding))

        // Left side se curve start hone se pehle ki line
        path.addLine(to: CGPoint(x: centerWidth - radius*2, y: bottomPadding))

        // Arc (smooth round notch)
        path.addArc(withCenter: CGPoint(x: centerWidth, y: bottomPadding),
                    radius: radius,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)

        // Right side ki line with padding
        path.addLine(to: CGPoint(x: self.frame.width - padding, y: bottomPadding))
        path.addLine(to: CGPoint(x: self.frame.width - padding, y: self.frame.height))
        path.addLine(to: CGPoint(x: padding, y: self.frame.height))
        path.close()

        return path.cgPath
    }


    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            if let result = member.hitTest(subPoint, with: event) {
                return result
            }
        }
        return nil
    }
}
