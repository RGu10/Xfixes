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
	var picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 230, height: 40.0))
	var delegate: InterfacePickerDelegate?
	
	let pickerData = [
		["---","passive","activeIn","activeOut","InOut","analogIn","analogOut","timing"],
		["---","passive","activeIn","activeOut","InOut","analogIn","analogOut","timing"],
		["---","passive","activeIn","activeOut","InOut","analogIn","analogOut","timing"]
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
		pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 14)
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
	let titleField = UITextField()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		titleField.text = component?.titleField.text
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func setup() {
        initGestureRecognizers()
    }
	
	func setupUI(type: String) {
		
		//layer.shadowColor = UIColor.black.cgColor
		//layer.shadowOpacity = 5
		//layer.shadowOffset = CGSize.zero
		//layer.shadowRadius = 3
		layer.borderColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0).cgColor
		layer.borderWidth = 3
		backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
		layer.shouldRasterize = true
		
		let setWhiteColorButton = UIButton()
		let setGrayColorButton = UIButton()
		let setOrangeColorButton = UIButton()
		let setGreenColorButton = UIButton()
		let setBlueColorButton = UIButton()
		let setRedColorButton = UIButton()
		let setYellowColorButton = UIButton()
		let setCyanColorButton = UIButton()
		let deleteButton = UIButton()

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
			titleField.frame = CGRect(x: 0, y: 0, width: 230, height: 30)
			titleField.backgroundColor = UIColor.white
			titleField.adjustsFontSizeToFitWidth = true
			titleField.textAlignment = .center
			titleField.isUserInteractionEnabled = true;
			titleField.placeholder = "Name"
			component?.newTitleField = titleField
			titleField.addTarget(component!, action: #selector(component?.setTitleAction), for: .editingDidEnd)
			addSubview(titleField)
			
			let intarfaceTopLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 230, height: 30))
			intarfaceTopLabel.text = "Schnittstellen"
			intarfaceTopLabel.adjustsFontSizeToFitWidth = true
			intarfaceTopLabel.textAlignment = .center
			intarfaceTopLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceTopLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceTopLabel)
			
			let pickerInterfaceTop = InterfacePicker(frame: CGRect(x: 0, y: 60, width: 230, height: 60.0))
			pickerInterfaceTop.type = "InterfaceTop"
			pickerInterfaceTop.delegate = component!
			addSubview(pickerInterfaceTop)
			
			let pickerInterfaceRight = InterfacePicker(frame: CGRect(x: 0, y: 100, width: 230, height: 60.0))
			pickerInterfaceRight.type = "InterfaceRight"
			pickerInterfaceRight.delegate = component!
			addSubview(pickerInterfaceRight)
			
			let pickerInterfaceLeft = InterfacePicker(frame: CGRect(x: 0, y: 140, width: 230, height: 60.0))
			pickerInterfaceLeft.type = "InterfaceLeft"
			pickerInterfaceLeft.delegate = component!
			addSubview(pickerInterfaceLeft)
			
			let pickerInterfaceButtom = InterfacePicker(frame: CGRect(x: 0, y: 180, width: 230, height: 60.0))
			pickerInterfaceButtom.type = "InterfaceButtom"
			pickerInterfaceButtom.delegate = component!
			addSubview(pickerInterfaceButtom)
			
			setWhiteColorButton.frame = CGRect(x: 10, y: 225, width: 40, height: 40)
			setGrayColorButton.frame = CGRect(x: 60, y: 225, width: 40, height: 40)
			setOrangeColorButton.frame = CGRect(x: 110, y: 225, width: 40, height: 40)
			setGreenColorButton.frame = CGRect(x: 160, y: 225, width: 40, height: 40)
			deleteButton.frame = CGRect(x: 0, y: 270, width: 230, height: 30)

		case "Bus":
			titleField.frame = CGRect(x: 0, y: 0, width: 230, height: 30)
			titleField.backgroundColor = UIColor.white
			titleField.adjustsFontSizeToFitWidth = true
			titleField.textAlignment = .center
			titleField.isUserInteractionEnabled = true;
			titleField.placeholder = "Name"
			component?.newTitleField = titleField
			titleField.addTarget(component!, action: #selector(component?.setTitleAction), for: .editingDidEnd)
			addSubview(titleField)
			
			let intarfaceTopLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 230, height: 30))
			intarfaceTopLabel.text = "Schnittstellen"
			intarfaceTopLabel.adjustsFontSizeToFitWidth = true
			intarfaceTopLabel.textAlignment = .center
			intarfaceTopLabel.font = UIFont.boldSystemFont(ofSize: 14)
			intarfaceTopLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(intarfaceTopLabel)
			
			let pickerInterfaceRight = InterfacePicker(frame: CGRect(x: 0, y: 60, width: 230, height: 40.0))
			pickerInterfaceRight.type = "InterfaceRight"
			pickerInterfaceRight.delegate = component!
			addSubview(pickerInterfaceRight)

			let pickerInterfaceLeft = InterfacePicker(frame: CGRect(x: 0, y: 100, width: 210, height: 40.0))
			pickerInterfaceLeft.type = "InterfaceLeft"
			pickerInterfaceLeft.delegate = component!
			addSubview(pickerInterfaceLeft)
			
			setWhiteColorButton.frame = CGRect(x: 10, y: 145, width: 40, height: 40)
			setGrayColorButton.frame = CGRect(x: 60, y: 145, width: 40, height: 40)
			setOrangeColorButton.frame = CGRect(x: 110, y: 145, width: 40, height: 40)
			setGreenColorButton.frame = CGRect(x: 160, y: 145, width: 40, height: 40)
			deleteButton.frame = CGRect(x: 0, y: 185, width: 230, height: 30)

		case "Timer":
			
			let TimerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: 30))
			TimerLabel.text = "Timer"
			TimerLabel.adjustsFontSizeToFitWidth = true
			TimerLabel.textAlignment = .center
			TimerLabel.font = UIFont.boldSystemFont(ofSize: 14)
			TimerLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
			addSubview(TimerLabel)
			
			let setTimerTopButton = UIButton()
			setTimerTopButton.frame = CGRect(x: 10, y: 30, width: 45, height: 20)
			setTimerTopButton.backgroundColor = UIColor.blue
			setTimerTopButton.tintColor = UIColor.white
			setTimerTopButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerTopButton.isHighlighted = true
			setTimerTopButton.setTitle("Top", for: .normal)
			setTimerTopButton.addTarget(component!, action: #selector(component?.setTimerTopAction), for: .touchUpInside)
			addSubview(setTimerTopButton)
			
			let setTimerLeftButton = UIButton()
			setTimerLeftButton.frame = CGRect(x: 65, y: 30, width: 45, height: 20)
			setTimerLeftButton.backgroundColor = UIColor.blue
			setTimerLeftButton.tintColor = UIColor.white
			setTimerLeftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerLeftButton.setTitle("Left", for: .normal)
			setTimerLeftButton.addTarget(component!, action: #selector(component?.setTimerLeftAction), for: .touchUpInside)
			addSubview(setTimerLeftButton)
			
			let setTimerRightButton = UIButton()
			setTimerRightButton.frame = CGRect(x: 115, y: 30, width: 45, height: 20)
			setTimerRightButton.backgroundColor = UIColor.blue
			setTimerRightButton.tintColor = UIColor.white
			setTimerRightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerRightButton.setTitle("Right", for: .normal)
			setTimerRightButton.addTarget(component!, action: #selector(component?.setTimerRightAction), for: .touchUpInside)
			addSubview(setTimerRightButton)
			
			let setTimerButtomButton = UIButton()
			setTimerButtomButton.frame = CGRect(x: 165, y: 30, width: 45, height: 20)
			setTimerButtomButton.backgroundColor = UIColor.blue
			setTimerButtomButton.tintColor = UIColor.white
			setTimerButtomButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
			setTimerButtomButton.setTitle("Buttom", for: .normal)
			setTimerButtomButton.addTarget(component!, action: #selector(component?.setTimerButtomAction), for: .touchUpInside)
			addSubview(setTimerButtomButton)
			
			setWhiteColorButton.frame = CGRect(x: 10, y: 70, width: 40, height: 40)
			setGrayColorButton.frame = CGRect(x: 60, y: 70, width: 40, height: 40)
			setOrangeColorButton.frame = CGRect(x: 110, y: 70, width: 40, height: 40)
			setGreenColorButton.frame = CGRect(x: 160, y: 70, width: 40, height: 40)
			deleteButton.frame = CGRect(x: 0, y: 115, width: 230, height: 30)

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

