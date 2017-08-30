//
//  EditPanel.swift
//  starter
//
//  Created by Ryad on 09.04.17.
//  Copyright © 2017 Ryad. All rights reserved.
//
import UIKit

protocol InterfacePickerDelegate: class {
	func setInterface(side: String, interface1: String, interface2: String, interface3: String)
}

class InterfacePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var type = ""
	var picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 210, height: 35.0))
	var delegate: InterfacePickerDelegate?
	
	let pickerData = [
		["---","passive","activeIn","activeOut","activeInOut","analogIn","analogOut","timing"],
		["---","passive","activeIn","activeOut","activeInOut","analogIn","analogOut","timing"],
		["---","passive","activeIn","activeOut","activeInOut","analogIn","analogOut","timing"]
	]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		picker.delegate = self
		picker.dataSource = self
		picker.backgroundColor = UIColor.white
		self.addSubview(picker)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setInterface(side: String, interface1: String, interface2: String, interface3: String) {
		delegate?.setInterface(side: side, interface1: interface1, interface2: interface2, interface3: interface3)
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return pickerData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let pickerLabel = UILabel()
		pickerLabel.textColor = UIColor.black
		pickerLabel.text = pickerData[0][row]
		pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 10)
		pickerLabel.textAlignment = NSTextAlignment.center
		return pickerLabel
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerData[component].count
	}
	
	func pickerView(_  pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerData[component][row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		updateLabel()
	}
	
	func updateLabel() {
		switch type {
		case "InterfaceTop":
			let interface1 = pickerData[0][picker.selectedRow(inComponent: 0)]
			let interface2 = pickerData[1][picker.selectedRow(inComponent: 1)]
			let interface3 = pickerData[2][picker.selectedRow(inComponent: 2)]
			setInterface(side: "Top", interface1: interface1 , interface2: interface2, interface3: interface3)
			break
		case "InterfaceRight":
			let interface1 = pickerData[0][picker.selectedRow(inComponent: 0)]
			let interface2 = pickerData[1][picker.selectedRow(inComponent: 1)]
			let interface3 = pickerData[2][picker.selectedRow(inComponent: 2)]
			setInterface(side: "Right", interface1: interface1 , interface2: interface2, interface3: interface3)
			break
		case "InterfaceLeft":
			let interface1 = pickerData[0][picker.selectedRow(inComponent: 0)]
			let interface2 = pickerData[1][picker.selectedRow(inComponent: 1)]
			let interface3 = pickerData[2][picker.selectedRow(inComponent: 2)]
			setInterface(side: "Left", interface1: interface1 , interface2: interface2, interface3: interface3)
			break
		case "InterfaceButtom":
			let interface1 = pickerData[0][picker.selectedRow(inComponent: 0)]
			let interface2 = pickerData[1][picker.selectedRow(inComponent: 1)]
			let interface3 = pickerData[2][picker.selectedRow(inComponent: 2)]
			setInterface(side: "Buttom", interface1: interface1 , interface2: interface2, interface3: interface3)
			break
		default:
			break
		}
	}
}

class XFEditPanel : UIView  {
	
	var component: XFComponentView? = nil
	let setTitle = UITextField()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setup() {
        initGestureRecognizers()
    }
	
	func setupUI(type: String) {
		
		layer.shadowColor = UIColor.gray.cgColor
		layer.shadowOpacity = 1
		layer.shadowOffset = CGSize.zero
		layer.shadowRadius = 3
		backgroundColor = UIColor(hue: 0.1694, saturation: 0.02, brightness: 0.89, alpha: 1.0)
		layer.shouldRasterize = true
		
		var colorLabel = UILabel()
		let setWhiteColorButton = UIButton()
		let setGrayColorButton = UIButton()
		let setOrangeColorButton = UIButton()
		let setGreenColorButton = UIButton()
		let setBlueColorButton = UIButton()
		let setRedColorButton = UIButton()
		let setYellowColorButton = UIButton()
		let setCyanColorButton = UIButton()
		let deleteButton = UIButton()
		
		colorLabel.text = "Farbe"
		colorLabel.adjustsFontSizeToFitWidth = true
		colorLabel.textAlignment = .center
		colorLabel.font = UIFont.boldSystemFont(ofSize: 14)
		colorLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
		addSubview(colorLabel)

		setWhiteColorButton.backgroundColor = UIColor.white
		setWhiteColorButton.addTarget(component!, action: #selector(component?.setWhiteColorButtonAction), for: .touchUpInside)
		addSubview(setWhiteColorButton)

		setGrayColorButton.backgroundColor = UIColor.gray
		setGrayColorButton.addTarget(component!, action: #selector(component?.setGrayColorButtonAction), for: .touchUpInside)
		addSubview(setGrayColorButton)

		setOrangeColorButton.backgroundColor = UIColor.orange
		setOrangeColorButton.addTarget(component!, action: #selector(component?.setOrangeColorButtonAction), for: .touchUpInside)
		addSubview(setOrangeColorButton)

		setGreenColorButton.backgroundColor = UIColor.green
		setGreenColorButton.addTarget(component!, action: #selector(component?.setGreenColorButtonAction), for: .touchUpInside)
		addSubview(setGreenColorButton)

		setBlueColorButton.backgroundColor = UIColor.blue
		setBlueColorButton.addTarget(component!, action: #selector(component?.setBlueColorButtonAction), for: .touchUpInside)
		addSubview(setBlueColorButton)

		setRedColorButton.backgroundColor = UIColor.red
		setRedColorButton.addTarget(component!, action: #selector(component?.setRedColorButtonAction), for: .touchUpInside)
		addSubview(setRedColorButton)

		setYellowColorButton.backgroundColor = UIColor.yellow
		setYellowColorButton.addTarget(component!, action: #selector(component?.setYellowColorButtonAction), for: .touchUpInside)
		addSubview(setYellowColorButton)

		setCyanColorButton.backgroundColor = UIColor.cyan
		setCyanColorButton.addTarget(component!, action: #selector(component?.setCyanColorButtonAction), for: .touchUpInside)
		addSubview(setCyanColorButton)

		deleteButton.setTitle("Löschen", for: .normal)
		deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		deleteButton.setTitleColor(UIColor.white, for: .normal)
		deleteButton.backgroundColor = UIColor.red
		deleteButton.addTarget(component!, action: #selector(component?.removeEditPanel), for: .touchUpInside)
		addSubview(deleteButton)
		
		switch type {
		case "Rect":
			let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 30))
			titleLabel.text = "Name"
			titleLabel.adjustsFontSizeToFitWidth = true
			titleLabel.textAlignment = .center
			titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
			titleLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(titleLabel)
			
			setTitle.frame = CGRect(x: 0, y: 30, width: 210, height: 30)
			setTitle.backgroundColor = UIColor.white
			setTitle.adjustsFontSizeToFitWidth = true
			setTitle.textAlignment = .center
			setTitle.isUserInteractionEnabled = true;
			setTitle.addTarget(component!, action: #selector(component?.setTitleAction), for: .editingDidEnd)
			addSubview(setTitle)
			
			let intarfaceTopLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 210, height: 30))
			intarfaceTopLabel.text = "Interface Top"
			intarfaceTopLabel.adjustsFontSizeToFitWidth = true
			intarfaceTopLabel.textAlignment = .center
			intarfaceTopLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceTopLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceTopLabel)
			
			let pickerInterfaceTop = InterfacePicker(frame: CGRect(x: 0, y: 90, width: 210, height: 35.0))
			pickerInterfaceTop.type = "InterfaceTop"
			pickerInterfaceTop.delegate = component!
			addSubview(pickerInterfaceTop)
			
			let intarfaceRightLabel = UILabel(frame: CGRect(x: 0, y: 120, width: 210, height: 30))
			intarfaceRightLabel.text = "Interface Right"
			intarfaceRightLabel.adjustsFontSizeToFitWidth = true
			intarfaceRightLabel.textAlignment = .center
			intarfaceRightLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceRightLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceRightLabel)
			
			let pickerInterfaceRight = InterfacePicker(frame: CGRect(x: 0, y: 150, width: 210, height: 35.0))
			pickerInterfaceRight.type = "InterfaceRight"
			pickerInterfaceRight.delegate = component!
			addSubview(pickerInterfaceRight)
			
			let intarfaceLeftLabel = UILabel(frame: CGRect(x: 0, y: 180, width: 210, height: 30))
			intarfaceLeftLabel.text = "Interface Left"
			intarfaceLeftLabel.adjustsFontSizeToFitWidth = true
			intarfaceLeftLabel.textAlignment = .center
			intarfaceLeftLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceLeftLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceLeftLabel)
			
			let pickerInterfaceLeft = InterfacePicker(frame: CGRect(x: 0, y: 210, width: 210, height: 35.0))
			pickerInterfaceLeft.type = "InterfaceLeft"
			pickerInterfaceLeft.delegate = component!
			addSubview(pickerInterfaceLeft)
			
			let intarfaceButtomLabel = UILabel(frame: CGRect(x: 0, y: 240, width: 210, height: 30))
			intarfaceButtomLabel.text = "Interface Buttom"
			intarfaceButtomLabel.adjustsFontSizeToFitWidth = true
			intarfaceButtomLabel.textAlignment = .center
			intarfaceButtomLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceButtomLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceButtomLabel)
			
			let pickerInterfaceButtom = InterfacePicker(frame: CGRect(x: 0, y: 270, width: 210, height: 35.0))
			pickerInterfaceButtom.type = "InterfaceButtom"
			pickerInterfaceButtom.delegate = component!
			addSubview(pickerInterfaceButtom)
			
			colorLabel.frame = CGRect(x: 0, y: 300, width: 210, height: 30)
			setWhiteColorButton.frame = CGRect(x: 5, y: 340, width: 20, height: 20)
			setGrayColorButton.frame = CGRect(x: 30, y: 340, width: 20, height: 20)
			setOrangeColorButton.frame = CGRect(x: 55, y: 340, width: 20, height: 20)
			setGreenColorButton.frame = CGRect(x: 80, y: 340, width: 20, height: 20)
			setBlueColorButton.frame =  CGRect(x: 105, y: 340, width: 20, height: 20)
			setRedColorButton.frame = CGRect(x: 130, y: 340, width: 20, height: 20)
			setYellowColorButton.frame = CGRect(x: 155, y: 340, width: 20, height: 20)
			setCyanColorButton.frame = CGRect(x: 180, y: 340, width: 20, height: 20)
			deleteButton.frame = CGRect(x: 0, y: 370, width: 210, height: 30)

		case "Bus":
			let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 30))
			titleLabel.text = "Name"
			titleLabel.adjustsFontSizeToFitWidth = true
			titleLabel.textAlignment = .center
			titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
			titleLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(titleLabel)
			
			setTitle.frame = CGRect(x: 0, y: 30, width: 210, height: 30)
			setTitle.backgroundColor = UIColor.white
			setTitle.adjustsFontSizeToFitWidth = true
			setTitle.textAlignment = .center
			setTitle.isUserInteractionEnabled = true;
			setTitle.addTarget(component!, action: #selector(component?.setTitleAction), for: .editingDidEnd)
			addSubview(setTitle)
			
			let intarfaceRightLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 210, height: 30))
			intarfaceRightLabel.text = "Interface Right"
			intarfaceRightLabel.adjustsFontSizeToFitWidth = true
			intarfaceRightLabel.textAlignment = .center
			intarfaceRightLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceRightLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceRightLabel)
			
			let pickerInterfaceRight = InterfacePicker(frame: CGRect(x: 0, y: 90, width: 210, height: 35.0))
			pickerInterfaceRight.type = "InterfaceRight"
			pickerInterfaceRight.delegate = component!
			addSubview(pickerInterfaceRight)
			
			let intarfaceLeftLabel = UILabel(frame: CGRect(x: 0, y: 125, width: 210, height: 30))
			intarfaceLeftLabel.text = "Interface Left"
			intarfaceLeftLabel.adjustsFontSizeToFitWidth = true
			intarfaceLeftLabel.textAlignment = .center
			intarfaceLeftLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceLeftLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceLeftLabel)
			
			let pickerInterfaceLeft = InterfacePicker(frame: CGRect(x: 0, y: 155, width: 210, height: 35.0))
			pickerInterfaceLeft.type = "InterfaceLeft"
			pickerInterfaceLeft.delegate = component!
			addSubview(pickerInterfaceLeft)
			
		    colorLabel = UILabel(frame: CGRect(x: 0, y: 190, width: 210, height: 30))
			setWhiteColorButton.frame = CGRect(x: 5, y: 220, width: 20, height: 20)
			setGrayColorButton.frame = CGRect(x: 30, y: 220, width: 20, height: 20)
			setOrangeColorButton.frame = CGRect(x: 55, y: 220, width: 20, height: 20)
			setGreenColorButton.frame = CGRect(x: 80, y: 220, width: 20, height: 20)
			setBlueColorButton.frame =  CGRect(x: 105, y: 220, width: 20, height: 20)
			setRedColorButton.frame = CGRect(x: 130, y: 220, width: 20, height: 20)
			setYellowColorButton.frame = CGRect(x: 155, y: 220, width: 20, height: 20)
			setCyanColorButton.frame = CGRect(x: 180, y: 220, width: 20, height: 20)
			deleteButton.frame = CGRect(x: 0, y: 245, width: 210, height: 30)

		case "Timer":
			
			let TimerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 30))
			TimerLabel.text = "Timer"
			TimerLabel.adjustsFontSizeToFitWidth = true
			TimerLabel.textAlignment = .center
			TimerLabel.font = UIFont.boldSystemFont(ofSize: 14)
			TimerLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(TimerLabel)
			
			let setTimerTopButton = UIButton()
			setTimerTopButton.frame = CGRect(x: 5, y: 30, width: 40, height: 20)
			setTimerTopButton.backgroundColor = UIColor.blue
			setTimerTopButton.tintColor = UIColor.white
			setTimerTopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerTopButton.setTitle("Top", for: .normal)
			setTimerTopButton.addTarget(component!, action: #selector(component?.setTimerTopAction), for: .touchUpInside)
			addSubview(setTimerTopButton)
			
			let setTimerRightButton = UIButton()
			setTimerRightButton.frame = CGRect(x: 105, y: 30, width: 40, height: 20)
			setTimerRightButton.backgroundColor = UIColor.blue
			setTimerRightButton.tintColor = UIColor.white
			setTimerRightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerRightButton.setTitle("Right", for: .normal)
			setTimerRightButton.addTarget(component!, action: #selector(component?.setTimerRightAction), for: .touchUpInside)
			addSubview(setTimerRightButton)
			
			let setTimerLeftButton = UIButton()
			setTimerLeftButton.frame = CGRect(x: 55, y: 30, width: 40, height: 20)
			setTimerLeftButton.backgroundColor = UIColor.blue
			setTimerLeftButton.tintColor = UIColor.white
			setTimerLeftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerLeftButton.setTitle("Left", for: .normal)
			setTimerLeftButton.addTarget(component!, action: #selector(component?.setTimerLeftAction), for: .touchUpInside)
			addSubview(setTimerLeftButton)
			
			let setTimerButtomButton = UIButton()
			setTimerButtomButton.frame = CGRect(x: 155, y: 30, width: 40, height: 20)
			setTimerButtomButton.backgroundColor = UIColor.blue
			setTimerButtomButton.tintColor = UIColor.white
			setTimerButtomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerButtomButton.setTitle("Buttom", for: .normal)
			setTimerButtomButton.addTarget(component!, action: #selector(component?.setTimerButtomAction), for: .touchUpInside)
			addSubview(setTimerButtomButton)
			
			colorLabel.frame = CGRect(x: 0, y: 60, width: 210, height: 30)
			setWhiteColorButton.frame = CGRect(x: 5, y: 90, width: 20, height: 20)
			setGrayColorButton.frame = CGRect(x: 30, y: 90, width: 20, height: 20)
			setOrangeColorButton.frame = CGRect(x: 55, y: 90, width: 20, height: 20)
			setGreenColorButton.frame = CGRect(x: 80, y: 90, width: 20, height: 20)
			setBlueColorButton.frame =  CGRect(x: 105, y: 90, width: 20, height: 20)
			setRedColorButton.frame = CGRect(x: 130, y: 90, width: 20, height: 20)
			setYellowColorButton.frame = CGRect(x: 155, y: 90, width: 20, height: 20)
			setCyanColorButton.frame = CGRect(x: 180, y: 90, width: 20, height: 20)
			deleteButton.frame = CGRect(x: 0, y: 115, width: 210, height: 30)

		default:
			break
		}
		
	}
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR: )))
        addGestureRecognizer(panGR)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(panGR: )))
        addGestureRecognizer(tapGR)
    }
    
    @objc func didTap(panGR: UITapGestureRecognizer) {
        // added to disable tap on component view
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        var translation = panGR.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(CGPoint.zero, in: self)
    }
}

