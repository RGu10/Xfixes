import UIKit

class InterfaceView: UIView {
    
    var path: UIBezierPath!
    var type = "" { didSet{ setNeedsDisplay() } }
    var id = ""
    var orient = CGFloat(0.0)
    let lineWidth: CGFloat = 2
    var lineColor = UIColor.black  { didSet { setNeedsDisplay() } }
    var fillColor = UIColor.white  { didSet { setNeedsDisplay() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.path = pathForInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, interfaceType: String) {
        super.init(frame: frame)
        if interfaceType == "timing"
        {
            self.path = pathForInterfaceTimer()
        }
        else {
            self.path = pathForInterface()
        }
    }
    
    func rotate(deg: Int) {
        switch deg {
        case 1:
            orient = orient + CGFloat(Double.pi / 2)
            self.transform = CGAffineTransform(rotationAngle: orient);
        case 2:
            orient = orient + CGFloat((Double.pi / 2)*2)
            self.transform = CGAffineTransform(rotationAngle: orient);
        case 3:
            orient = orient + CGFloat((Double.pi / 2)*3)
            self.transform = CGAffineTransform(rotationAngle: orient);
        case 4:
            orient = orient + CGFloat((Double.pi / 2)*4)
            self.transform = CGAffineTransform(rotationAngle: orient);
        default:
            break
        }
    }
    
    private func pathForInterface() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        path.close()
        return path
    }
    
    private func pathForInterfaceTimer() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: lineWidth, dy: lineWidth)
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height/2))
        path.close()
        return path
    }
    
    override func draw(_ rect: CGRect) {
        path.lineWidth = lineWidth
        self.fillColor.setFill()
        self.path.fill()
        UIColor.black.setStroke()
        path.stroke()
    }
}

class InterfaceTechnologieView: UIView {
    
    var path: UIBezierPath!
    var path2: UIBezierPath!
    var drawSecondPath = false
    let lineWidth: CGFloat = 2
    var orient = CGFloat(0.0)
    
    init(frame: CGRect, interfaceType: String) {
        super.init(frame: frame)
        
        switch interfaceType {
        case "activeIn":
            self.path = pathForInterfaceActive()
            break
        case "activeOut":
            self.path = pathForInterfaceActive()
            break
        case "activeInOut":
            self.path = pathForInterfaceInOut()
            break
        case "analogIn":
            self.path = pathForInterfaceAnalog()
            break
        case "analogOut":
            self.path = pathForInterfaceAnalog()
            break
        case "half":
            drawSecondPath = true
            self.path = pathForInterfaceHalfTriangleWihte()
            self.path2 = pathForInterfaceHalfTriangleGray()
            break
        case "timing":
            break
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(deg: Int) {
        switch deg {
        case 1:
            orient = orient + CGFloat((Double.pi / 2))
            self.transform = CGAffineTransform(rotationAngle: orient);
        case 2:
            orient = orient + CGFloat((Double.pi / 2)*2)
            self.transform = CGAffineTransform(rotationAngle: orient);
        case 3:
            orient = orient + CGFloat((Double.pi / 2)*3)
            self.transform = CGAffineTransform(rotationAngle: orient);
        default:
            break
        }
    }
    
    private func pathForInterfaceActive() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        path.close()
        return path
    }
    
    private func pathForInterfaceAnalog() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addQuadCurve(to: CGPoint(x: rect.origin.x, y: rect.height), controlPoint: CGPoint(x: rect.width - 2, y: rect.height/2))
        path.close()
        return path
    }
    
    private func pathForInterfaceInOut() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: 1.0,dy: 1.0)
        path.move(to: CGPoint(x: rect.width/4, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width/4, y: rect.height))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height/2))
        path.close()
        return path
    }
    
    private func pathForInterfaceHalfTriangleWihte() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: 1.0,dy: 1.0)
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height/2))
        path.close()
        return path
    }
    
    private func pathForInterfaceHalfTriangleGray() -> UIBezierPath {
        let path = UIBezierPath()
        let rect = self.bounds.insetBy(dx: 1.0,dy: 1.0)
        path.move(to: CGPoint(x: rect.origin.x, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        path.close()
        return path
    }
    
    override func draw(_ rect: CGRect) {
        
        path.lineWidth = lineWidth
        UIColor.gray.setFill()
        self.path.fill()
        UIColor.black.setStroke()
        path.stroke()
        
        if drawSecondPath {
            path2.lineWidth = 1.0
            UIColor.white.setFill()
            self.path2.fill()
            UIColor.black.setStroke()
            path2.stroke()
        }
    }
    
}
