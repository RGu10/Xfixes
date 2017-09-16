import UIKit

class InterfaceTechnologieView: UIView
{
	var orient = CGFloat(0.0)
	let lineWidth: CGFloat = 2
	var path: UIBezierPath!

	init(frame: CGRect, interfaceType: String)
	{
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
		switch interfaceType {
		case "activeIn":
			self.path = pathForInterfaceActive()
		case "activeOut":
			self.path = pathForInterfaceActive()
		case "InOut":
			self.path = pathForInterfaceInOut()
		case "analogIn":
			self.path = pathForInterfaceAnalog()
		case "analogOut":
			self.path = pathForInterfaceAnalog()
		case "timing":
			break
		default:
			break
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	func rotate(deg: Int)
	{
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
	
	private func pathForInterfaceActive() -> UIBezierPath
	{
		let path = UIBezierPath()
		let rect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
		path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
		path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
		path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
		path.close()
		return path
	}
	
	private func pathForInterfaceAnalog() -> UIBezierPath
	{
		let path = UIBezierPath()
		let rect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
		path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
		path.addQuadCurve(to: CGPoint(x: rect.origin.x, y: rect.height), controlPoint: CGPoint(x: rect.width - 2, y: rect.height/2))
		path.close()
		return path
	}
	
	private func pathForInterfaceInOut() -> UIBezierPath
	{
		let path = UIBezierPath()
		let rect = self.bounds.insetBy(dx: 1.0,dy: 1.0)
		path.move(to: CGPoint(x: rect.width/4, y: rect.origin.y))
		path.addLine(to: CGPoint(x: rect.width/2, y: rect.height/2))
		path.addLine(to: CGPoint(x: rect.width/4, y: rect.height))
		path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height/2))
		path.close()
		return path
	}
	
	override func draw(_ rect: CGRect)
	{
		path.lineWidth = lineWidth
		UIColor.gray.setFill()
		self.path.fill()
		UIColor.black.setStroke()
		path.stroke()
	}
}

class XFInterfaceView: UIView
{
	var type = ""
	var position = ""
	var orient = CGFloat(0.0)
	var fillColor = UIColor.white  { didSet { setNeedsDisplay() } }
	let component: XFComponentView? = nil
	var path: UIBezierPath!
    let lineWidth: CGFloat = 2
    let lineColor = UIColor.black
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.path = pathForInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, interfaceType: String) {
        super.init(frame: frame)
		type = interfaceType
		switch interfaceType {
		case "passive":
			self.path = pathForInterface()
		case "activeIn":
			self.path = pathForInterface()
			//let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interfaceType)
			//tech.rotate(deg: 2)
		    //self.addSubview(tech)
		case "activeOut":
			self.path = pathForInterface()
			//let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interfaceType)
			//tech.rotate(deg: 2)
			//self.addSubview(tech)
		case "InOut":
			self.path = pathForInterface()
			//let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interfaceType)
			//tech.rotate(deg: 2)
			//self.addSubview(tech)
		case "analogIn":
			self.path = pathForInterface()
			//let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interfaceType)
			//tech.rotate(deg: 2)
			//self.addSubview(tech)
		case "analogOut":
			self.path = pathForInterface()
			//let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interfaceType)
			//tech.rotate(deg: 2)
			//self.addSubview(tech)
		case "timing":
			self.path = pathForInterfaceTimer()
			//let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interfaceType)
			//tech.rotate(deg: 2)
			//self.addSubview(tech)
		default:
			break
		}
    }

    func rotate(deg: Int)
	{
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
    
    private func pathForInterface() -> UIBezierPath
	{
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
    
    private func pathForInterfaceTimer() -> UIBezierPath
	{
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
