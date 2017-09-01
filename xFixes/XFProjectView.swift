//
//  XFProjectView.swift
//  xFixes
//
//  Created by Ryad on 24.08.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import UIKit

protocol ProjectViewDelegate: class {
	func show(project: XFProjectView)
	func delete(project: XFProjectView)
}

class XFProjectView : UIView  {
	var delegate: ProjectViewDelegate?
	var projectName: String? { didSet { setNeedsDisplay() } }
	var titleField: UITextField!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		path = rectPath()
		initGestureRecognizers()
		
		titleField = UITextField(frame: CGRect(x: 2, y: 10, width: 170, height: 50))
		titleField.text = "Project Name"
		titleField.adjustsFontSizeToFitWidth = true
		titleField.textAlignment = .center
		titleField.font = UIFont.boldSystemFont(ofSize: 18)
		titleField.textColor = UIColor.darkText
		titleField.backgroundColor = UIColor(hue: 210/360, saturation: 0/100, brightness: 90/100, alpha: 1.0)
		titleField.tintColor = UIColor.clear
		addSubview(titleField)
	}
	
	func initGestureRecognizers() {
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR: )))
		addGestureRecognizer(tapGR)
		
		let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(LongPressGR: )))
		addGestureRecognizer(longPressGR)
		
	}
	
	func show(project: XFProjectView) {
		delegate?.show(project: project)
	}
	
	func delete(project: XFProjectView) {
		delegate?.delete(project: project)
	}
	
	@objc func didTap(tapGR: UITapGestureRecognizer) {
		show(project: self)
	}
	
	@objc func didLongPress(LongPressGR: UILongPressGestureRecognizer) {
		delete(project: self)
	}
	
	let lineWidth = CGFloat(1.5)
	var path: UIBezierPath!
	var fillColor = UIColor.white
	
	func rectPath() -> UIBezierPath {
		let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
		return UIBezierPath(roundedRect: insetRect, cornerRadius: 0.0)
	}
	
	override func draw(_ rect: CGRect) {
		path.lineWidth = lineWidth
		self.fillColor.setFill()
		self.path.fill()
		UIColor.black.setStroke()
		path.stroke()
	}
}
