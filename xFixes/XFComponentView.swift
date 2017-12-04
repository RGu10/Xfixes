//
//  ComponentView.swift
//  starter
//
//  Created by Ryad on 09.04.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import UIKit

protocol ComponentViewDelegate: class {
	func create(component: XFComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool)
	func select(component: XFComponentView)
	func delete(component: XFComponentView)
	func merge(component: XFComponentView)
	func interface(component: XFComponentView)
	func updateColor(component: XFComponentView)
	func updateTitle(component: XFComponentView)
}

class XFComponentView : UIView, InterfacePickerDelegate {
	
	var id = 0
	var type = ""
	var fillColor = UIColor.white  { didSet { setNeedsDisplay() } }
	var titleField = UITextField(frame: CGRect(x: 0, y: 5, width: 100, height: 20)) { didSet { setNeedsDisplay() } }
	var newTitleField = UITextField()  { didSet { setNeedsDisplay() } }
	var bDraggable = false
	var bOrigin = true
	var bMoved = false
	var bSelected = false
	var delegate: ComponentViewDelegate?
	var neighbors  = [XFComponentView]()
	var neighborsTags  = [Int64]()
	var interfaces = [XFInterfaceView]()
	var neighborInterfacesName = [String]()
	var editPanel  = XFEditPanelView()
	
	var path: UIBezierPath!
	var path2: UIBezierPath!
	let lineWidth: CGFloat = 2
	var lineColor = UIColor.black
	var width = 70.0 { didSet { setNeedsDisplay() } }
	var height = 100.0 { didSet { setNeedsDisplay() } }
	
	var neighborTop1: XFComponentView? = nil
	var neighborTop2: XFComponentView? = nil
	var neighborTop3: XFComponentView? = nil
	var neighborInterfaceNameTop1: String?
	var neighborInterfaceNameTop2: String?
	var neighborInterfaceNameTop3: String?
	var neighborButtom1: XFComponentView? = nil
	var neighborButtom2: XFComponentView? = nil
	var neighborButtom3: XFComponentView? = nil
	var neighborInterfaceNameButtom1: String?
	var neighborInterfaceNameButtom2: String?
	var neighborInterfaceNameButtom3: String?
	var neighborRight1: XFComponentView? = nil
	var neighborRight2: XFComponentView? = nil
	var neighborRight3: XFComponentView? = nil
	var neighborInterfaceNameRight1: String?
	var neighborInterfaceNameRight2: String?
	var neighborInterfaceNameRight3: String?
	var neighborLeft1: XFComponentView? = nil
	var neighborLeft2: XFComponentView? = nil
	var neighborLeft3: XFComponentView? = nil
	var neighborInterfaceNameLeft1: String?
	var neighborInterfaceNameLeft2: String?
	var neighborInterfaceNameLeft3: String?
	
	var intarface1Top: XFInterfaceView? = nil
	var intarface2Top: XFInterfaceView? = nil
	var intarface3Top: XFInterfaceView? = nil
	var intarface1Buttom: XFInterfaceView? = nil
	var intarface2Buttom: XFInterfaceView? = nil
	var intarface3Buttom: XFInterfaceView? = nil
	var intarface1Right: XFInterfaceView? = nil
	var intarface2Right: XFInterfaceView? = nil
	var intarface3Right: XFInterfaceView? = nil
	var intarface1Left: XFInterfaceView? = nil
	var intarface2Left: XFInterfaceView? = nil
	var intarface3Left: XFInterfaceView? = nil
	
	func create(component: XFComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool) {
		delegate?.create(component: component, frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
	}
	
	func interface(component: XFComponentView) {
		delegate?.interface(component: component)
	}
	
	func merge(component: XFComponentView) {
		delegate?.merge(component: component)
	}
	
	func select(component: XFComponentView) {
		delegate?.select(component: component)
	}
	
	func delete(component: XFComponentView) {
		delegate?.delete(component: component)
	}
	
	func updateColor(component: XFComponentView) {
		delegate?.updateColor(component: self)
	}
	
	func updateTitle(component: XFComponentView) {
		delegate?.updateTitle(component: self)
	}
	
	func rectPath() -> UIBezierPath {
		let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
		return UIBezierPath(roundedRect: insetRect, cornerRadius: 0.0)
	}
	
	func roundedRectPath() -> UIBezierPath {
		let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
		return UIBezierPath(roundedRect: insetRect, cornerRadius: 10.0)
	}
	
	func roundedMultiRectPath() -> UIBezierPath {
		let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
		return UIBezierPath(roundedRect: insetRect, cornerRadius: 5.0)
	}
	
	func cyclePath() -> UIBezierPath {
		let center = CGPoint(x:bounds.width/2, y: (bounds.height/2) - 10)
		let radius: CGFloat = (bounds.width / 2) - 5
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = 360
		
		return UIBezierPath(arcCenter: center,
		                    radius: radius,
		                    startAngle: startAngle,
		                    endAngle: endAngle,
		                    clockwise: true)
	}
	
	func rectTimerPath() -> UIBezierPath {
		let path = UIBezierPath()
		let rect = self.bounds.insetBy(dx: 1.0,dy: 1.0)
		path.move(to: CGPoint(x: rect.width - 21, y: rect.height/2 + 20))
		path.addLine(to: CGPoint(x: rect.width - 21, y: rect.height - 13))
		path.addLine(to: CGPoint(x: rect.origin.x + 21, y: rect.height - 13))
		path.addLine(to: CGPoint(x: rect.origin.x + 21, y: rect.height/2 + 20))
		path.close()
		return path
	}
	
	func randomColor() -> UIColor {
		let hue:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
	}
	
	override func draw(_ rect: CGRect) {
		path.lineWidth = self.lineWidth
		self.fillColor.setFill()
		self.path.fill()
		UIColor.black.setStroke()
		path.stroke()
	}
	
	init(frame: CGRect, type: String , bDraggable: Bool,  bOrigin: Bool) {
		super.init(frame: frame)
		self.type = type
		self.bDraggable = bDraggable
		self.bOrigin = bOrigin
		self.backgroundColor = UIColor.clear
		fillColor = UIColor.white
		titleField.text = ""
		titleField.isUserInteractionEnabled = false
		newTitleField.text = ""
		editPanel.component = self
		
		switch type {
		case "Rect":
			self.path = rectPath()
			editPanel.setupUI(type: "Rect")
		case "RoundedRect":
			self.path = roundedRectPath()
			editPanel.setupUI(type: "Rect")
		case "RoundedMultiRect":
			self.path = roundedMultiRectPath()
			editPanel.setupUI(type: "Rect")
		case "Timer":
			self.path = cyclePath()
			editPanel.setupUI(type: "Timer")
		case "Clock":
			self.path = cyclePath()
			editPanel.setupUI(type: "Timer")
		case "Bus":
			self.path = rectPath()
			editPanel.setupUI(type: "Bus")
		default:
			break
		}
		
		initGestureRecognizers()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func initGestureRecognizers() {
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR: )))
		addGestureRecognizer(tapGR)
		
		if(bDraggable){
			let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR: )))
			addGestureRecognizer(panGR)
		}
	}
	
	
	@objc func didTap(tapGR: UITapGestureRecognizer) {
		if !bSelected {
			bSelected = true
		} else {
			bSelected = false
		}
		if !bOrigin {
			select(component: self)
		}
	}
	
	@objc func didPan(panGR: UIPanGestureRecognizer) {
		
		var translation = panGR.translation(in: self)
		translation = translation.applying(self.transform)
		self.center.x += translation.x
		self.center.y += translation.y
		panGR.setTranslation(CGPoint.zero, in: self)
		
		switch (panGR.state) {
		case .began:
			neighbors.removeAll()
			traceNeighbors(component: self)
		case .changed:
			bMoved = true
			for v in neighbors {
				v.center.x += translation.x
				v.center.y += translation.y
				panGR.setTranslation(CGPoint.zero, in: v)
			}
		case .ended:
			switch type {
			case "Rect":
				if bOrigin == true {
					bOrigin = false
					create(component: self, frame: CGRect(x: 150.0, y: 80, width: 100.0, height: 100.0),
					       type: "Rect",
					       bDraggable: true,
					       bOrigin: true)
				}
			case "RoundedRect":
				if bOrigin == true {
					bOrigin = false
					create(component: self, frame: CGRect(x: 300.0, y: 80, width: 100.0, height: 100.0),
					       type: "RoundedRect",
					       bDraggable: true,
					       bOrigin: true)
				}
			case "RoundedMultiRect":
				if bOrigin == true {
					bOrigin = false
					create(component: self, frame: CGRect(x: 450.0, y: 80, width: 100.0, height: 100.0),
					       type: "RoundedMultiRect",
					       bDraggable: true,
					       bOrigin: true)
				}
			case "Bus":
				if bOrigin == true {
					bOrigin = false
					create(component: self, frame: CGRect(x: 600.0, y: 80, width: 70.0, height: 100.0),
					       type: "Bus",
					       bDraggable: true,
					       bOrigin: true)
				}
			case "Timer":
				if bOrigin == true {
					bOrigin = false
					create(component: self, frame: CGRect(x: 700.0, y: 100, width: 70.0, height: 90.0),
					       type: "Timer",
					       bDraggable: true,
					       bOrigin: true)
				}
			case "Clock":
				if bOrigin == true {
					bOrigin = false
					create(component: self, frame: CGRect(x: 800.0, y: 100, width: 70.0, height: 90.0),
					       type: "Clock",
					       bDraggable: true,
					       bOrigin: true)
				}
			default:
				break
			}
			merge(component: self)
			break;
		default:
			break;
		}
	}
	
	func setupInterface(interface: XFInterfaceView, position: String, deg: Int){
		intarface1Top?.backgroundColor = UIColor.clear
		intarface1Top?.rotate(deg: deg)
		intarface1Top?.position = position
	}
	
	internal func setInterface(side: String, interface1: String, interface2: String, interface3: String) {
		
		switch side {
		case "Top":
			if intarface1Top != nil {
				intarface1Top!.removeFromSuperview()
			}
			if intarface2Top != nil {
				intarface2Top!.removeFromSuperview()
			}
			if intarface3Top != nil {
				intarface3Top!.removeFromSuperview()
			}

			switch interface1 {
			case "---":
				intarface1Top?.type = "---"
				intarface1Top?.position = "top1"
			case "passive":
				intarface1Top = XFInterfaceView(frame: CGRect(x: 0, y: -26, width: 30, height: 30), interfaceType: interface1 )
				setupInterface(interface: intarface1Top!, position: "top1", deg: 3)
				self.addSubview(intarface1Top!)
				break
			case "activeIn":
				intarface1Top = XFInterfaceView(frame: CGRect(x: 0, y: -26, width: 30, height: 30), interfaceType: interface1) // to extend
				setupInterface(interface: intarface1Top!, position: "top1", deg: 3)
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface1Top?.addSubview(tech)
				self.addSubview(intarface1Top!)
				break
			case "activeOut":
				intarface1Top = XFInterfaceView(frame: CGRect(x: 0, y: -26, width: 30, height: 30), interfaceType: interface1) // to extend
				setupInterface(interface: intarface1Top!, position: "top1", deg: 3)
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0.5, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface1Top?.addSubview(tech)
				self.addSubview(intarface1Top!)
				break
			case "InOut":
				intarface1Top = XFInterfaceView(frame: CGRect(x: 0, y: -26, width: 30, height: 30), interfaceType: interface1) // to extend
				setupInterface(interface: intarface1Top!, position: "top1", deg: 3)
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 2, y: 1, width: 26, height: 26),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface1Top?.addSubview(tech)
				self.addSubview(intarface1Top!)
				break
			case "analogIn":
				intarface1Top = XFInterfaceView(frame: CGRect(x: 0, y: -26, width: 30, height: 30), interfaceType: interface1) // to extend
				setupInterface(interface: intarface1Top!, position: "top1", deg: 3)
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface1Top?.addSubview(tech)
				self.addSubview(intarface1Top!)
				break
			case "analogOut":
				intarface1Top = XFInterfaceView(frame: CGRect(x: 0, y: -26, width: 30, height: 30), interfaceType: interface1) // to extend
				setupInterface(interface: intarface1Top!, position: "top1", deg: 3)
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 1, y: 1, width: 28, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface1Top?.addSubview(tech)
				self.addSubview(intarface1Top!)
				break
			case "timing":
				break
			default:
				break
			}
			
			switch interface2 {
			case "---":
				intarface2Top?.type = "---"
				intarface2Top?.position = "top2"
			case "passive":
				intarface2Top = XFInterfaceView(frame: CGRect(x: 36, y: -26, width: 30, height: 30), interfaceType: interface2)
				intarface2Top?.backgroundColor = UIColor.clear
				intarface2Top?.rotate(deg: 3)
				intarface2Top?.position = "top2"
				self.addSubview(intarface2Top!)
				break
			case "activeIn":
				intarface2Top = XFInterfaceView(frame: CGRect(x: 36, y: -26, width: 30, height: 30), interfaceType: interface2) // to extend
				intarface2Top?.backgroundColor = UIColor.clear
				intarface2Top?.rotate(deg: 3)
				intarface2Top?.position = "top2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface2Top?.addSubview(tech)
				self.addSubview(intarface2Top!)
				break
			case "activeOut":
				intarface2Top = XFInterfaceView(frame: CGRect(x: 36, y: -26, width: 30, height: 30), interfaceType: interface2) // to extend
				intarface2Top?.backgroundColor = UIColor.clear
				intarface2Top?.rotate(deg: 3)
				intarface2Top?.position = "top2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0.5, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface2Top?.addSubview(tech)
				self.addSubview(intarface2Top!)
				break
			case "InOut":
				intarface2Top = XFInterfaceView(frame: CGRect(x: 36, y: -26, width: 30, height: 30), interfaceType: interface2) // to extend
				intarface2Top?.backgroundColor = UIColor.clear
				intarface2Top?.rotate(deg: 3)
				intarface2Top?.position = "top2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 2, y: 1, width: 26, height: 26),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface2Top?.addSubview(tech)
				self.addSubview(intarface2Top!)
				break
			case "analogIn":
				intarface2Top = XFInterfaceView(frame: CGRect(x: 36, y: -26, width: 30, height: 30), interfaceType: interface2) // to extend
				intarface2Top?.backgroundColor = UIColor.clear
				intarface2Top?.rotate(deg: 3)
				intarface2Top?.position = "top2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface2Top?.addSubview(tech)
				self.addSubview(intarface2Top!)
				break
			case "analogOut":
				intarface2Top = XFInterfaceView(frame: CGRect(x: 36, y: -26, width: 30, height: 30), interfaceType: interface2) // to extend
				intarface2Top?.backgroundColor = UIColor.clear
				intarface2Top?.rotate(deg: 3)
				intarface2Top?.position = "top2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 1, y: 1, width: 28, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface2Top?.addSubview(tech)
				self.addSubview(intarface2Top!)
				break
			case "timing":
				if self.type == "Timer" {
					intarface2Top = XFInterfaceView(frame: CGRect(x: 21, y: -8, width: 30, height: 30), interfaceType: interface2) // to extend
					intarface2Top?.backgroundColor = UIColor.clear
					intarface2Top?.position = "top2"
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Top?.addSubview(txtField)
					self.addSubview(intarface2Top!)
				} else if self.type == "Clock" {
					intarface2Top = XFInterfaceView(frame: CGRect(x: 21, y: -8, width: 30, height: 30), interfaceType: interface2) // to extend
					intarface2Top?.backgroundColor = UIColor.clear
					intarface2Top?.position = "top2"
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Top?.addSubview(txtField)
					self.addSubview(intarface2Top!)
				}else {
					intarface2Top = XFInterfaceView(frame: CGRect(x: 35, y: -11, width: 30, height: 30), interfaceType: interface2) // to extend
					intarface2Top?.backgroundColor = UIColor.clear
					intarface2Top?.type = "timing"
					intarface2Top?.position = "top2"
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Top?.addSubview(txtField)
					self.addSubview(intarface2Top!)
				}
				break
			default:
				break
			}
			
			switch interface3 {
			case "---":
				intarface3Top?.type = "---"
				intarface3Top?.position = "top3"
			case "passive":
				intarface3Top = XFInterfaceView(frame: CGRect(x: 72, y: -26, width: 30, height: 30), interfaceType: interface3)
				intarface3Top?.backgroundColor = UIColor.clear
				intarface3Top?.rotate(deg: 3)
				intarface3Top?.position = "top3"
				self.addSubview(intarface3Top!)
				break
			case "activeIn":
				intarface3Top = XFInterfaceView(frame: CGRect(x: 72, y: -26, width: 30, height: 30), interfaceType: interface3) // to extend
				intarface3Top?.backgroundColor = UIColor.clear
				intarface3Top?.rotate(deg: 3)
				intarface3Top?.position = "top3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -0.5, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface3Top?.addSubview(tech)
				self.addSubview(intarface3Top!)
				break
			case "activeOut":
				intarface3Top = XFInterfaceView(frame: CGRect(x: 72, y: -26, width: 30, height: 30), interfaceType: interface3) // to extend
				intarface3Top?.backgroundColor = UIColor.clear
				intarface3Top?.rotate(deg: 3)
				intarface3Top?.position = "top3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0.5, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface3Top?.addSubview(tech)
				self.addSubview(intarface3Top!)
				break
			case "InOut":
				intarface3Top = XFInterfaceView(frame: CGRect(x: 72, y: -26, width: 30, height: 30), interfaceType: interface3) // to extend
				intarface3Top?.backgroundColor = UIColor.clear
				intarface3Top?.rotate(deg: 3)
				intarface3Top?.position = "top3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 2, y: 1, width: 26, height: 26),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface3Top?.addSubview(tech)
				self.addSubview(intarface3Top!)
				break
			case "analogIn":
				intarface3Top = XFInterfaceView(frame: CGRect(x: 72, y: -26, width: 30, height: 30), interfaceType: interface3) // to extend
				intarface3Top?.backgroundColor = UIColor.clear
				intarface3Top?.rotate(deg: 3)
				intarface3Top?.position = "top3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface3Top?.addSubview(tech)
				self.addSubview(intarface3Top!)
				break
			case "analogOut":
				intarface3Top = XFInterfaceView(frame: CGRect(x: 72, y: -26, width: 30, height: 30), interfaceType: interface3) // to extend
				intarface3Top?.backgroundColor = UIColor.clear
				intarface3Top?.rotate(deg: 3)
				intarface3Top?.position = "top3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 1, y: 1, width: 28, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 4)
				intarface3Top?.addSubview(tech)
				self.addSubview(intarface3Top!)
				break
			case "timing":
				break
			default:
				break
			}
			break
		case "Right":
			if intarface1Right != nil {
				intarface1Right!.removeFromSuperview()
			}
			if intarface2Right != nil {
				intarface2Right!.removeFromSuperview()
			}
			if intarface3Right != nil {
				intarface3Right!.removeFromSuperview()
			}
			
			switch interface1 {
			case "---":
				intarface1Right?.type = "---"
				intarface1Right?.position = "right1"
			case "passive":
				if self.type == "Bus" {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 66, y: 0, width: 30, height: 30), interfaceType: interface1)
				} else {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 96, y: 0, width: 30, height: 30), interfaceType: interface1)
				}
				intarface1Right?.position = "right1"
				intarface1Right?.backgroundColor = UIColor.clear
				self.addSubview(intarface1Right!)
				break
			case "activeIn":
				if self.type == "Bus" {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 66, y: 0, width: 30, height: 30), interfaceType: interface1)
				} else {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 96, y: 0, width: 30, height: 30), interfaceType: interface1)
				}
				intarface1Right?.backgroundColor = UIColor.clear
				intarface1Right?.position = "right1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface1Right?.addSubview(tech)
				self.addSubview(intarface1Right!)
				break
			case "activeOut":
				if self.type == "Bus" {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 66, y: 0, width: 30, height: 30), interfaceType: interface1)
				} else {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 96, y: 0, width: 30, height: 30), interfaceType: interface1)
				}
				intarface1Right?.backgroundColor = UIColor.clear
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Right?.position = "right1"
				intarface1Right?.addSubview(tech)
				self.addSubview(intarface1Right!)
				break
			case "InOut":
				if self.type == "Bus" {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 66, y: 0, width: 30, height: 30), interfaceType: interface1)
				} else {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 96, y: 0, width: 30, height: 30), interfaceType: interface1)
				}
				intarface1Right?.backgroundColor = UIColor.clear
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 26, height: 26),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Right?.position = "right1"
				intarface1Right?.addSubview(tech)
				self.addSubview(intarface1Right!)
				break
			case "analogIn":
				if self.type == "Bus" {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 66, y: 0, width: 30, height: 30), interfaceType: interface1)
				} else {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 96, y: 0, width: 30, height: 30), interfaceType: interface1)
				}
				intarface1Right?.backgroundColor = UIColor.clear
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Right?.position = "right1"
				tech.rotate(deg: 2)
				intarface1Right?.addSubview(tech)
				self.addSubview(intarface1Right!)
				break
			case "analogOut":
				if self.type == "Bus" {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 66, y: 0, width: 30, height: 30), interfaceType: interface1)
				} else {
					intarface1Right = XFInterfaceView(frame: CGRect(x: 96, y: 0, width: 30, height: 30), interfaceType: interface1)
				}
				intarface1Right?.backgroundColor = UIColor.clear
				intarface1Right?.position = "right1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Right?.addSubview(tech)
				self.addSubview(intarface1Right!)
				break
			case "timing":
				break
			default:
				break
			}
			
			switch interface2 {
			case "---":
				intarface2Right?.type = "---"
				intarface2Right?.position = "right2"
			case "passive":
				if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 66, y: 37, width: 30, height: 30), interfaceType: interface2)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 96, y: 37, width: 30, height: 30), interfaceType: interface2)
				}
				intarface2Right?.backgroundColor = UIColor.clear
				intarface2Right?.position = "right2"
				self.addSubview(intarface2Right!)
				break
			case "activeIn":
				if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 66, y: 37, width: 30, height: 30), interfaceType: interface2)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 96, y: 37, width: 30, height: 30), interfaceType: interface2)
				}
				intarface2Right?.backgroundColor = UIColor.clear
				intarface2Right?.position = "right2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface2Right?.addSubview(tech)
				self.addSubview(intarface2Right!)
				break
			case "activeOut":
				if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 66, y: 37, width: 30, height: 30), interfaceType: interface2)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 96, y: 37, width: 30, height: 30), interfaceType: interface2)
				}
				intarface2Right?.backgroundColor = UIColor.clear
				intarface2Right?.position = "right2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				intarface2Right?.addSubview(tech)
				self.addSubview(intarface2Right!)
				break
			case "InOut":
				if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 66, y: 37, width: 30, height: 30), interfaceType: interface2)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 96, y: 37, width: 30, height: 30), interfaceType: interface2)
				}
				intarface2Right?.backgroundColor = UIColor.clear
				intarface2Right?.position = "right2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 26, height: 26),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				intarface2Right?.addSubview(tech)
				self.addSubview(intarface2Right!)
				break
			case "analogIn":
				if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 66, y: 37, width: 30, height: 30), interfaceType: interface2)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 96, y: 37, width: 30, height: 30), interfaceType: interface2)
				}
				intarface2Right?.backgroundColor = UIColor.clear
				intarface2Right?.position = "right2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface2Right?.addSubview(tech)
				self.addSubview(intarface2Right!)
				break
			case "analogOut":
				if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 66, y: 37, width: 30, height: 30), interfaceType: interface2)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 96, y: 37, width: 30, height: 30), interfaceType: interface2)
				}
				intarface2Right?.backgroundColor = UIColor.clear
				intarface2Right?.position = "right2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				intarface2Right?.addSubview(tech)
				self.addSubview(intarface2Right!)
				break
			case "timing":
				if self.type == "Timer"  || self.type == "Clock" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 48, y: 20, width: 30, height: 30), interfaceType: interface2)
					intarface2Right?.backgroundColor = UIColor.clear
					intarface2Right?.position = "right2"
					intarface2Right?.rotate(deg: 1)
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Right?.addSubview(txtField)
					self.addSubview(intarface2Right!)
				}
				else if self.type == "Bus" {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 52, y: 35, width: 30, height: 30), interfaceType: interface2)
					intarface2Right?.backgroundColor = UIColor.clear
					intarface2Right?.position = "right2"
					intarface2Right?.rotate(deg: 1)
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Right?.addSubview(txtField)
					self.addSubview(intarface2Right!)
				} else {
					intarface2Right = XFInterfaceView(frame: CGRect(x: 82, y: 35, width: 30, height: 30), interfaceType: interface2)
					intarface2Right?.backgroundColor = UIColor.clear
					intarface2Right?.position = "right2"
					intarface2Right?.rotate(deg: 1)
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Right?.addSubview(txtField)
					self.addSubview(intarface2Right!)
				}
				break
			default:
				break
			}
			
			switch interface3 {
			case "---":
				intarface3Right?.type = "---"
				intarface3Right?.position = "right3"
			case "passive":
				if self.type == "Bus" {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 66, y: 72, width: 30, height: 30), interfaceType: interface3)
				} else {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 96, y: 72, width: 30, height: 30), interfaceType: interface3)
				}
				intarface3Right?.backgroundColor = UIColor.clear
				intarface3Right?.position = "right3"
				self.addSubview(intarface3Right!)
				break
			case "activeIn":
				if self.type == "Bus" {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 66, y: 72, width: 30, height: 30), interfaceType: interface3)
				} else {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 96, y: 72, width: 30, height: 30), interfaceType: interface3)
				}
				intarface3Right?.backgroundColor = UIColor.clear
				intarface3Right?.position = "right3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface3Right?.addSubview(tech)
				self.addSubview(intarface3Right!)
				break
			case "activeOut":
				if self.type == "Bus" {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 66, y: 72, width: 30, height: 30), interfaceType: interface3)
				} else {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 96, y: 72, width: 30, height: 30), interfaceType: interface3)
				}
				intarface3Right?.backgroundColor = UIColor.clear
				intarface3Right?.position = "right3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				intarface3Right?.addSubview(tech)
				self.addSubview(intarface3Right!)
				break
			case "InOut":
				if self.type == "Bus" {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 66, y: 72, width: 30, height: 30), interfaceType: interface3)
				} else {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 96, y: 72, width: 30, height: 30), interfaceType: interface3)
				}
				intarface3Right?.backgroundColor = UIColor.clear
				intarface3Right?.position = "right3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 26, height: 26),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				intarface3Right?.addSubview(tech)
				self.addSubview(intarface3Right!)
				break
			case "analogIn":
				if self.type == "Bus" {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 66, y: 72, width: 30, height: 30), interfaceType: interface3)
				} else {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 96, y: 72, width: 30, height: 30), interfaceType: interface3)
				}
				intarface3Right?.backgroundColor = UIColor.clear
				intarface3Right?.position = "right3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface3Right?.addSubview(tech)
				self.addSubview(intarface3Right!)
				break
			case "analogOut":
				if self.type == "Bus" {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 66, y: 72, width: 30, height: 30), interfaceType: interface3)
				} else {
					intarface3Right = XFInterfaceView(frame: CGRect(x: 96, y: 72, width: 30, height: 30), interfaceType: interface3)
				}
				intarface3Right?.backgroundColor = UIColor.clear
				intarface3Right?.position = "right3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				intarface3Right?.addSubview(tech)
				self.addSubview(intarface3Right!)
				break
			case "timing":
				break
			default:
				break
			}
		case "Left":
			if intarface1Left != nil {
				intarface1Left!.removeFromSuperview()
			}
			if intarface2Left != nil {
				intarface2Left!.removeFromSuperview()
			}
			if intarface3Left != nil {
				intarface3Left!.removeFromSuperview()
			}
			
			switch interface1 {
			case "---":
				intarface1Left?.type = "---"
				intarface1Left?.position = "left1"
			case "passive":
				intarface1Left = XFInterfaceView(frame: CGRect(x: -26, y: -2, width: 30, height: 30), interfaceType: interface1)
				intarface1Left?.backgroundColor = UIColor.clear
				intarface1Left?.rotate(deg: 2)
				intarface1Left?.position = "left1"
				self.addSubview(intarface1Left!)
				break
			case "activeIn":
				intarface1Left = XFInterfaceView(frame: CGRect(x: -26, y: -2, width: 30, height: 30), interfaceType: interface1)
				intarface1Left?.backgroundColor = UIColor.clear
				intarface1Left?.rotate(deg: 2)
				intarface1Left?.position = "left1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface1Left?.addSubview(tech)
				self.addSubview(intarface1Left!)
				break
			case "activeOut":
				intarface1Left = XFInterfaceView(frame: CGRect(x: -26, y: -2, width: 30, height: 30), interfaceType: interface1)
				intarface1Left?.backgroundColor = UIColor.clear
				intarface1Left?.rotate(deg: 2)
				intarface1Left?.position = "left1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Left?.addSubview(tech)
				self.addSubview(intarface1Left!)
				break
			case "InOut":
				intarface1Left = XFInterfaceView(frame: CGRect(x: -26, y: -2, width: 30, height: 30), interfaceType: interface1)
				intarface1Left?.backgroundColor = UIColor.clear
				intarface1Left?.rotate(deg: 2)
				intarface1Left?.position = "left1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Left?.addSubview(tech)
				self.addSubview(intarface1Left!)
				break
			case "analogIn":
				intarface1Left = XFInterfaceView(frame: CGRect(x: -26, y: -2, width: 30, height: 30), interfaceType: interface1)
				intarface1Left?.backgroundColor = UIColor.clear
				intarface1Left?.rotate(deg: 2)
				intarface1Left?.position = "left1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 30),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface1Left?.addSubview(tech)
				self.addSubview(intarface1Left!)
				break
			case "analogOut":
				intarface1Left = XFInterfaceView(frame: CGRect(x: -26, y: -2, width: 30, height: 30), interfaceType: interface1)
				intarface1Left?.backgroundColor = UIColor.clear
				intarface1Left?.rotate(deg: 2)
				intarface1Left?.position = "left1"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface1)
				tech.backgroundColor = UIColor.clear
				intarface1Left?.addSubview(tech)
				self.addSubview(intarface1Left!)
				break
			case "timing":
				break
			default:
				break
			}
			
			switch interface2 {
			case "---":
				intarface2Left?.type = "---"
				intarface2Left?.position = "left2"
			case "passive":
				intarface2Left = XFInterfaceView(frame: CGRect(x: -26, y: 35, width: 30, height: 30), interfaceType: interface2)
				intarface2Left?.backgroundColor = UIColor.clear
				intarface2Left?.rotate(deg: 2)
				intarface2Left?.position = "left2"
				self.addSubview(intarface2Left!)
				break
			case "activeIn":
				intarface2Left = XFInterfaceView(frame: CGRect(x: -26, y: 35, width: 30, height: 30), interfaceType: interface2)
				intarface2Left?.backgroundColor = UIColor.clear
				intarface2Left?.rotate(deg: 2)
				intarface2Left?.position = "left2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface2Left?.addSubview(tech)
				self.addSubview(intarface2Left!)
				break
			case "activeOut":
				intarface2Left = XFInterfaceView(frame: CGRect(x: -26, y: 35, width: 30, height: 30), interfaceType: interface2)
				intarface2Left?.backgroundColor = UIColor.clear
				intarface2Left?.rotate(deg: 2)
				intarface2Left?.position = "left2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				intarface2Left?.addSubview(tech)
				self.addSubview(intarface2Left!)
				break
			case "InOut":
				intarface2Left = XFInterfaceView(frame: CGRect(x: -26, y: 35, width: 30, height: 30), interfaceType: interface2)
				intarface2Left?.backgroundColor = UIColor.clear
				intarface2Left?.rotate(deg: 2)
				intarface2Left?.position = "left2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				intarface2Left?.addSubview(tech)
				self.addSubview(intarface2Left!)
				break
			case "analogIn":
				intarface2Left = XFInterfaceView(frame: CGRect(x: -26, y: 35, width: 30, height: 30), interfaceType: interface2)
				intarface2Left?.backgroundColor = UIColor.clear
				intarface2Left?.rotate(deg: 2)
				intarface2Left?.position = "left2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 30),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface2Left?.addSubview(tech)
				self.addSubview(intarface2Left!)
				break
			case "analogOut":
				intarface2Left = XFInterfaceView(frame: CGRect(x: -26, y: 35, width: 30, height: 30), interfaceType: interface2)
				intarface2Left?.backgroundColor = UIColor.clear
				intarface2Left?.rotate(deg: 2)
				intarface2Left?.position = "left2"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface2)
				tech.backgroundColor = UIColor.clear
				intarface2Left?.addSubview(tech)
				self.addSubview(intarface2Left!)
				break
			case "timing":
				if self.type == "Timer" || self.type == "Clock"  {
					intarface2Left = XFInterfaceView(frame: CGRect(x: -8, y: 20, width: 30, height: 30), interfaceType: interface2)
					intarface2Left?.backgroundColor = UIColor.clear
					intarface2Left?.rotate(deg: 3)
					intarface2Left?.position = "left2"
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Left?.addSubview(txtField)
					self.addSubview(intarface2Left!)
				} else {
					intarface2Left = XFInterfaceView(frame: CGRect(x: -12, y: 35, width: 30, height: 30), interfaceType: interface2)
					intarface2Left?.backgroundColor = UIColor.clear
					intarface2Left?.rotate(deg: 3)
					intarface2Left?.position = "left2"
					let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
					txtField.text = "T"
					txtField.adjustsFontSizeToFitWidth = true
					txtField.textAlignment = .center
					txtField.font = UIFont.boldSystemFont(ofSize: 10)
					intarface2Left?.addSubview(txtField)
					self.addSubview(intarface2Left!)
				}
				break
			default:
				break
			}
			
			switch interface3 {
			case "---":
				intarface3Left?.type = "---"
				intarface3Left?.position = "left3"
			case "passive":
				intarface3Left = XFInterfaceView(frame: CGRect(x: -26, y: 70, width: 30, height: 30), interfaceType: interface3)
				intarface3Left?.backgroundColor = UIColor.clear
				intarface3Left?.rotate(deg: 2)
				intarface3Left?.position = "left3"
				self.addSubview(intarface3Left!)
				break
			case "activeIn":
				intarface3Left = XFInterfaceView(frame: CGRect(x: -26, y: 70, width: 30, height: 30), interfaceType: interface3)
				intarface3Left?.backgroundColor = UIColor.clear
				intarface3Left?.rotate(deg: 2)
				intarface3Left?.position = "left3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface3Left?.addSubview(tech)
				self.addSubview(intarface3Left!)
				break
			case "activeOut":
				intarface3Left = XFInterfaceView(frame: CGRect(x: -26, y: 70, width: 30, height: 30), interfaceType: interface3)
				intarface3Left?.backgroundColor = UIColor.clear
				intarface3Left?.rotate(deg: 2)
				intarface3Left?.position = "left3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				intarface3Left?.addSubview(tech)
				self.addSubview(intarface3Left!)
				break
			case "InOut":
				intarface3Left = XFInterfaceView(frame: CGRect(x: -26, y: 70, width: 30, height: 30), interfaceType: interface3)
				intarface3Left?.backgroundColor = UIColor.clear
				intarface3Left?.rotate(deg: 2)
				intarface3Left?.position = "left3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				intarface3Left?.addSubview(tech)
				self.addSubview(intarface3Left!)
				break
			case "analogIn":
				intarface3Left = XFInterfaceView(frame: CGRect(x: -26, y: 70, width: 30, height: 30), interfaceType: interface3)
				intarface3Left?.backgroundColor = UIColor.clear
				intarface3Left?.rotate(deg: 2)
				intarface3Left?.position = "left3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 30),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				tech.rotate(deg: 2)
				intarface3Left?.addSubview(tech)
				self.addSubview(intarface3Left!)
				break
			case "analogOut":
				intarface3Left = XFInterfaceView(frame: CGRect(x: -26, y: 70, width: 30, height: 30), interfaceType: interface3)
				intarface3Left?.backgroundColor = UIColor.clear
				intarface3Left?.rotate(deg: 2)
				intarface3Left?.position = "left3"
				let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface3)
				tech.backgroundColor = UIColor.clear
				intarface3Left?.addSubview(tech)
				self.addSubview(intarface3Left!)
				break
			case "timing":
				break
			default:
				break
			}
		case "Buttom":
			if self.type != "Bus" {
				if intarface1Buttom != nil {
					intarface1Buttom!.removeFromSuperview()
				}
				if intarface2Buttom != nil {
					intarface2Buttom!.removeFromSuperview()
				}
				if intarface3Buttom != nil {
					intarface3Buttom!.removeFromSuperview()
				}
				
				switch interface1 {
				case "---":
					intarface1Buttom?.type = "---"
					intarface1Buttom?.position = "buttom1"
				case "passive":
					intarface1Buttom = XFInterfaceView(frame: CGRect(x: -2, y: 96, width: 30, height: 30), interfaceType: interface1)
					intarface1Buttom?.backgroundColor = UIColor.clear
					intarface1Buttom?.rotate(deg: 1)
					intarface1Buttom?.position = "buttom1"
					self.addSubview(intarface1Buttom!)
					break
				case "activeIn":
					intarface1Buttom = XFInterfaceView(frame: CGRect(x: -2, y: 96, width: 30, height: 30), interfaceType: interface1)
					intarface1Buttom?.backgroundColor = UIColor.clear
					intarface1Buttom?.rotate(deg: 1)
					intarface1Buttom?.position = "buttom1"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: interface1)
					tech.backgroundColor = UIColor.clear
					tech.rotate(deg: 2)
					intarface1Buttom?.addSubview(tech)
					self.addSubview(intarface1Buttom!)
					break
				case "activeOut":
					intarface1Buttom = XFInterfaceView(frame: CGRect(x: -2, y: 96, width: 30, height: 30), interfaceType: interface1)
					intarface1Buttom?.backgroundColor = UIColor.clear
					intarface1Buttom?.rotate(deg: 1)
					intarface1Buttom?.position = "buttom1"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface1)
					tech.backgroundColor = UIColor.clear
					intarface1Buttom?.addSubview(tech)
					self.addSubview(intarface1Buttom!)
					break
				case "InOut":
					intarface1Buttom = XFInterfaceView(frame: CGRect(x: -2, y: 96, width: 30, height: 30), interfaceType: interface1)
					intarface1Buttom?.backgroundColor = UIColor.clear
					intarface1Buttom?.rotate(deg: 1)
					intarface1Buttom?.position = "buttom1"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: interface1)
					tech.backgroundColor = UIColor.clear
					intarface1Buttom?.addSubview(tech)
					self.addSubview(intarface1Buttom!)
					break
				case "analogIn":
					intarface1Buttom = XFInterfaceView(frame: CGRect(x: -2, y: 96, width: 30, height: 30), interfaceType: interface1)
					intarface1Buttom?.backgroundColor = UIColor.clear
					intarface1Buttom?.rotate(deg: 1)
					intarface1Buttom?.position = "buttom1"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -2, width: 30, height: 30),interfaceType: interface1)
					tech.backgroundColor = UIColor.clear
					tech.rotate(deg: 2)
					intarface1Buttom?.addSubview(tech)
					self.addSubview(intarface1Buttom!)
					break
				case "analogOut":
					intarface1Buttom = XFInterfaceView(frame: CGRect(x: -2, y: 96, width: 30, height: 30), interfaceType: interface1)
					intarface1Buttom?.backgroundColor = UIColor.clear
					intarface1Buttom?.rotate(deg: 1)
					intarface1Buttom?.position = "buttom1"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface1)
					tech.backgroundColor = UIColor.clear
					intarface1Buttom?.addSubview(tech)
					self.addSubview(intarface1Buttom!)
					break
				case "timing":
					break
				default:
					break
				}
				
				switch interface2 {
				case "---":
					intarface2Buttom?.type = "---"
					intarface2Buttom?.position = "buttom2"
				case "passive":
					intarface2Buttom = XFInterfaceView(frame: CGRect(x: 34, y: 96, width: 30, height: 30), interfaceType: interface2)
					intarface2Buttom?.backgroundColor = UIColor.clear
					intarface2Buttom?.rotate(deg: 1)
					intarface2Buttom?.position = "buttom2"
					self.addSubview(intarface2Buttom!)
					break
				case "activeIn":
					intarface2Buttom = XFInterfaceView(frame: CGRect(x: 34, y: 96, width: 30, height: 30), interfaceType: interface2)
					intarface2Buttom?.backgroundColor = UIColor.clear
					intarface2Buttom?.rotate(deg: 1)
					intarface2Buttom?.position = "buttom2"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: interface2)
					tech.backgroundColor = UIColor.clear
					tech.rotate(deg: 2)
					intarface2Buttom?.addSubview(tech)
					self.addSubview(intarface2Buttom!)
					break
				case "activeOut":
					intarface2Buttom = XFInterfaceView(frame: CGRect(x: 34, y: 96, width: 30, height: 30), interfaceType: interface2)
					intarface2Buttom?.backgroundColor = UIColor.clear
					intarface2Buttom?.rotate(deg: 1)
					intarface2Buttom?.position = "buttom2"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface2)
					tech.backgroundColor = UIColor.clear
					intarface2Buttom?.addSubview(tech)
					self.addSubview(intarface2Buttom!)
					break
				case "InOut":
					intarface2Buttom = XFInterfaceView(frame: CGRect(x: 34, y: 96, width: 30, height: 30), interfaceType: interface2)
					intarface2Buttom?.backgroundColor = UIColor.clear
					intarface2Buttom?.rotate(deg: 1)
					intarface2Buttom?.position = "buttom2"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: interface2)
					tech.backgroundColor = UIColor.clear
					intarface2Buttom?.addSubview(tech)
					self.addSubview(intarface2Buttom!)
					break
				case "analogIn":
					intarface2Buttom = XFInterfaceView(frame: CGRect(x: 34, y: 96, width: 30, height: 30), interfaceType: interface2)
					intarface2Buttom?.backgroundColor = UIColor.clear
					intarface2Buttom?.rotate(deg: 1)
					intarface2Buttom?.position = "buttom2"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -2, width: 30, height: 30),interfaceType: interface2)
					tech.backgroundColor = UIColor.clear
					tech.rotate(deg: 2)
					intarface2Buttom?.addSubview(tech)
					self.addSubview(intarface2Buttom!)
					break
				case "analogOut":
					intarface2Buttom = XFInterfaceView(frame: CGRect(x: 34, y: 96, width: 30, height: 30), interfaceType: interface2)
					intarface2Buttom?.backgroundColor = UIColor.clear
					intarface2Buttom?.rotate(deg: 1)
					intarface2Buttom?.position = "buttom2"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface2)
					tech.backgroundColor = UIColor.clear
					intarface2Buttom?.addSubview(tech)
					self.addSubview(intarface2Buttom!)
					break
				case "timing":
					if self.type == "Timer"  || self.type == "Clock"  {
						intarface2Buttom = XFInterfaceView(frame: CGRect(x: 19, y: 48, width: 30, height: 30), interfaceType: interface2)
						intarface2Buttom?.backgroundColor = UIColor.clear
						intarface2Buttom?.rotate(deg: 2)
						intarface2Buttom?.position = "buttom2"
						let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
						txtField.text = "T"
						txtField.adjustsFontSizeToFitWidth = true
						txtField.textAlignment = .center
						txtField.font = UIFont.boldSystemFont(ofSize: 10)
						intarface2Buttom?.addSubview(txtField)
						self.addSubview(intarface2Buttom!)
					} else {
						intarface2Buttom = XFInterfaceView(frame: CGRect(x: 35, y: 82, width: 30, height: 30), interfaceType: interface2)
						intarface2Buttom?.backgroundColor = UIColor.clear
						intarface2Buttom?.rotate(deg: 2)
						intarface2Buttom?.position = "buttom2"
						let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
						txtField.text = "T"
						txtField.adjustsFontSizeToFitWidth = true
						txtField.textAlignment = .center
						txtField.font = UIFont.boldSystemFont(ofSize: 10)
						intarface2Buttom?.addSubview(txtField)
						self.addSubview(intarface2Buttom!)
					}
					break
				default:
					break
				}
				
				switch interface3 {
				case "---":
					intarface3Buttom?.type = "---"
					intarface3Buttom?.position = "buttom3"
				case "passive":
					intarface3Buttom = XFInterfaceView(frame: CGRect(x: 70, y: 96, width: 30, height: 30), interfaceType: interface3)
					intarface3Buttom?.backgroundColor = UIColor.clear
					intarface3Buttom?.rotate(deg: 1)
					intarface3Buttom?.position = "buttom3"
					self.addSubview(intarface3Buttom!)
					break
				case "activeIn":
					intarface3Buttom = XFInterfaceView(frame: CGRect(x: 70, y: 96, width: 30, height: 30), interfaceType: interface3)
					intarface3Buttom?.backgroundColor = UIColor.clear
					intarface3Buttom?.rotate(deg: 1)
					intarface3Buttom?.position = "buttom3"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: interface3)
					tech.backgroundColor = UIColor.clear
					tech.rotate(deg: 2)
					intarface3Buttom?.addSubview(tech)
					self.addSubview(intarface3Buttom!)
					break
				case "activeOut":
					intarface3Buttom = XFInterfaceView(frame: CGRect(x: 70, y: 96, width: 30, height: 30), interfaceType: interface3)
					intarface3Buttom?.backgroundColor = UIColor.clear
					intarface3Buttom?.rotate(deg: 1)
					intarface3Buttom?.position = "buttom3"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface3)
					tech.backgroundColor = UIColor.clear
					intarface3Buttom?.addSubview(tech)
					self.addSubview(intarface3Buttom!)
					break
				case "InOut":
					intarface3Buttom = XFInterfaceView(frame: CGRect(x: 70, y: 96, width: 30, height: 30), interfaceType: interface3)
					intarface3Buttom?.backgroundColor = UIColor.clear
					intarface3Buttom?.rotate(deg: 1)
					intarface3Buttom?.position = "buttom3"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: interface3)
					tech.backgroundColor = UIColor.clear
					intarface3Buttom?.addSubview(tech)
					self.addSubview(intarface3Buttom!)
					break
				case "analogIn":
					intarface3Buttom = XFInterfaceView(frame: CGRect(x: 70, y: 96, width: 30, height: 30), interfaceType: interface3)
					intarface3Buttom?.backgroundColor = UIColor.clear
					intarface3Buttom?.rotate(deg: 1)
					intarface3Buttom?.position = "buttom3"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: -15, y: -2, width: 30, height: 30),interfaceType: interface3)
					tech.backgroundColor = UIColor.clear
					tech.rotate(deg: 2)
					intarface3Buttom?.addSubview(tech)
					self.addSubview(intarface3Buttom!)
					break
				case "analogOut":
					intarface3Buttom = XFInterfaceView(frame: CGRect(x: 70, y: 96, width: 30, height: 30), interfaceType: interface3)
					intarface3Buttom?.backgroundColor = UIColor.clear
					intarface3Buttom?.rotate(deg: 1)
					intarface3Buttom?.position = "buttom3"
					let tech = XFInterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: interface3)
					tech.backgroundColor = UIColor.clear
					intarface3Buttom?.addSubview(tech)
					self.addSubview(intarface3Buttom!)
					break
				case "timing":
					break
				default:
					break
				}
			}
		default:
			break
		}
		interface(component: self)
	}
	
	@objc func setTitleAction() {
		
		if type == "Bus" {
			titleField.adjustsFontSizeToFitWidth = true
			titleField.frame = CGRect(x: 0, y: 20, width: 70, height: 20)
			titleField.textAlignment = .center
			self.titleField.text! = self.newTitleField.text!
			self.addSubview(titleField)
		}
		else {
			titleField.adjustsFontSizeToFitWidth = true
			titleField.textAlignment = .center
			self.titleField.text! = self.newTitleField.text!
			self.addSubview(titleField)
		}
		
		self.updateTitle(component: self)
	}
	
	var setTimerTop = false
	var setTimerRight = false
	var setTimerButtom = false
	var setTimerLeft = false
	
	@objc func setTimerTopAction(){
		if !setTimerTop {
			intarface2Top = XFInterfaceView(frame: CGRect(x: 21, y: -8, width: 30, height: 30), interfaceType: "timing") // to extend
			intarface2Top?.backgroundColor = UIColor.clear
			intarface2Top?.position = "top2"
			intarface2Top?.type = "timing"
			let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
			txtField.text = "T"
			txtField.adjustsFontSizeToFitWidth = true
			txtField.textAlignment = .center
			txtField.font = UIFont.boldSystemFont(ofSize: 10)
			intarface2Top?.addSubview(txtField)
			self.addSubview(intarface2Top!)
			setTimerTop = true
			interface(component: self)
		} else {
			intarface2Top?.removeFromSuperview()
			intarface2Top?.type = "---"
			setTimerTop = false
			interface(component: self)
		}
	}
	
	@objc func setTimerRightAction(){
		if !setTimerRight {
			intarface2Right = XFInterfaceView(frame: CGRect(x: 48, y: 20, width: 30, height: 30), interfaceType: "timing")
			intarface2Right?.backgroundColor = UIColor.clear
			intarface2Right?.rotate(deg: 1)
			intarface2Right?.position = "right2"
			intarface2Right?.type = "timing"
			let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
			txtField.text = "T"
			txtField.adjustsFontSizeToFitWidth = true
			txtField.textAlignment = .center
			txtField.font = UIFont.boldSystemFont(ofSize: 10)
			intarface2Right?.addSubview(txtField)
			self.addSubview(intarface2Right!)
			setTimerRight = true
			interface(component: self)
		} else {
			intarface2Right?.removeFromSuperview()
			intarface2Right?.type = "---"
			setTimerRight = false
			interface(component: self)
		}
	}
	
	@objc func setTimerLeftAction(){
		if !setTimerLeft {
			intarface2Left = XFInterfaceView(frame: CGRect(x: -8, y: 20, width: 30, height: 30), interfaceType: "timing")
			intarface2Left?.backgroundColor = UIColor.clear
			intarface2Left?.rotate(deg: 3)
			intarface2Left?.position = "left2"
			intarface2Left?.type = "timing"
			let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
			txtField.text = "T"
			txtField.adjustsFontSizeToFitWidth = true
			txtField.textAlignment = .center
			txtField.font = UIFont.boldSystemFont(ofSize: 10)
			intarface2Left?.addSubview(txtField)
			self.addSubview(intarface2Left!)
			setTimerLeft = true
			interface(component: self)
		} else {
			intarface2Left?.removeFromSuperview()
			intarface2Left?.type = "---"
			setTimerLeft = false
			interface(component: self)
		}
	}
	
	@objc func setTimerButtomAction(){
		if !setTimerButtom {
			intarface2Buttom = XFInterfaceView(frame: CGRect(x: 19, y: 48, width: 30, height: 30), interfaceType: "timing")
			intarface2Buttom?.backgroundColor = UIColor.clear
			intarface2Buttom?.rotate(deg: 2)
			intarface2Buttom?.position = "buttom2"
			intarface2Buttom?.type = "timing"
			let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
			txtField.text = "T"
			txtField.adjustsFontSizeToFitWidth = true
			txtField.textAlignment = .center
			txtField.font = UIFont.boldSystemFont(ofSize: 10)
			intarface2Buttom?.addSubview(txtField)
			self.addSubview(intarface2Buttom!)
			setTimerButtom = true
			interface(component: self)
		} else {
			intarface2Buttom?.removeFromSuperview()
			intarface2Buttom?.type = "---"
			setTimerButtom = false
			interface(component: self)
		}
	}
	
	@objc func setWhiteColorButtonAction() {
		self.fillColor = UIColor.white
		self.updateColor(component: self)
	}
	@objc func setGrayColorButtonAction()  {
		self.fillColor = UIColor.gray
		self.updateColor(component: self)
	}
	@objc func setOrangeColorButtonAction(){
		self.fillColor = UIColor.orange
		self.updateColor(component: self)
	}
	@objc func setGreenColorButtonAction() {
		self.fillColor = UIColor.green
		self.updateColor(component: self)
	}
	@objc func setBlueColorButtonAction()  {
		self.fillColor = UIColor.blue
		self.updateColor(component: self)
	}
	@objc func setRedColorButtonAction()   {
		self.fillColor = UIColor.red
		self.updateColor(component: self)
	}
	@objc func setYellowColorButtonAction(){
		self.fillColor = UIColor.yellow
		self.updateColor(component: self)
	}
	@objc func setCyanColorButtonAction()  {
		self.fillColor = UIColor.cyan
		self.updateColor(component: self)
	}
	
	var orient = CGFloat(0.0)
	
	func rotate() {
		orient = orient + CGFloat((Double.pi / 2))
		self.transform = CGAffineTransform(rotationAngle: orient)
	}
	
	func removeFromNeighborList (){
		for c in neighbors {
			if c.id == id {
				neighbors.remove(at: id)
			}
		}
	}
	
	@objc func removeEditPanel(){
		editPanel.removeFromSuperview()
		delete(component: self)
	}
	
	func traceNeighbors(component: XFComponentView!) {
		if component.neighborTop1 != nil && !neighbors.contains(component.neighborTop1!) && component.neighborTop1 != self {
			neighbors.append(component.neighborTop1!)
			traceNeighbors(component: component.neighborTop1!)
		}
		if component.neighborTop2 != nil && !neighbors.contains(component.neighborTop2!) && component.neighborTop2 != self {
			neighbors.append(component.neighborTop2!)
			traceNeighbors(component: component.neighborTop2!)
		}
		if component.neighborTop3 != nil && !neighbors.contains(component.neighborTop3!) && component.neighborTop3 != self {
			neighbors.append(component.neighborTop3!)
			traceNeighbors(component: component.neighborTop3!)
		}
		
		if component.neighborRight1 != nil && !neighbors.contains(component.neighborRight1!) && component.neighborRight1 != self {
			neighbors.append(component.neighborRight1!)
			traceNeighbors(component: component.neighborRight1!)
		}
		if component.neighborRight2 != nil && !neighbors.contains(component.neighborRight2!) && component.neighborRight2 != self {
			neighbors.append(component.neighborRight2!)
			traceNeighbors(component: component.neighborRight2!)
		}
		if component.neighborRight3 != nil && !neighbors.contains(component.neighborRight3!) && component.neighborRight3 != self {
			neighbors.append(component.neighborRight3!)
			traceNeighbors(component: component.neighborRight3!)
		}
		
		if component.neighborButtom1 != nil && !neighbors.contains(component.neighborButtom1!) && component.neighborButtom1 != self {
			neighbors.append(component.neighborButtom1!)
			traceNeighbors(component: component.neighborButtom1!)
		}
		if component.neighborButtom2 != nil && !neighbors.contains(component.neighborButtom2!) && component.neighborButtom2 != self {
			neighbors.append(component.neighborButtom2!)
			traceNeighbors(component: component.neighborButtom2!)
		}
		if component.neighborButtom3 != nil && !neighbors.contains(component.neighborButtom3!) && component.neighborButtom3 != self {
			neighbors.append(component.neighborButtom3!)
			traceNeighbors(component: component.neighborButtom3!)
		}
		
		if component.neighborLeft1 != nil && !neighbors.contains(component.neighborLeft1!) && component.neighborLeft1 != self {
			neighbors.append(component.neighborLeft1!)
			traceNeighbors(component: component.neighborLeft1!)
		}
		if component.neighborLeft2 != nil && !neighbors.contains(component.neighborLeft2!) && component.neighborLeft2 != self {
			neighbors.append(component.neighborLeft2!)
			traceNeighbors(component: component.neighborLeft2!)
		}
		if component.neighborLeft3 != nil && !neighbors.contains(component.neighborLeft3!) && component.neighborLeft3 != self {
			neighbors.append(component.neighborLeft3!)
			traceNeighbors(component: component.neighborLeft3!)
		}
	}
}
