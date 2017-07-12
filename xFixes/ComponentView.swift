//
//  ComponentView.swift
//  starter
//
//  Created by Ryad on 09.04.17.
//  Copyright © 2017 Ryad. All rights reserved.
//
/*
 Module ComponentView
 */

//Git
import UIKit

protocol ComponentViewDelegate: class {
    func create(component: ComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool)
    func select(component: ComponentView)
    func delete(component: ComponentView)
    func merge(component: ComponentView)
}

protocol InterfacePickerDelegate: class {
    func setInterface(side: String, interface1: String, interface2: String, interface3: String)
}

class InterfacePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var type = ""
    var picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 210, height: 35.0))
    
    var delegate: InterfacePickerDelegate?
    
    func setInterface(side: String, interface1: String, interface2: String, interface3: String) {
        delegate?.setInterface(side: side, interface1: interface1, interface2: interface2, interface3: interface3)
    }
    
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

class ComponentView : UIView, InterfacePickerDelegate {
    
    let lineWidth: CGFloat = 2
    var lineColor = UIColor.black  { didSet { setNeedsDisplay() } }
    var fillColor = UIColor.white  { didSet { setNeedsDisplay() } }
    var width = 70.0 { didSet { setNeedsDisplay() } }
    var height = 100.0 { didSet { setNeedsDisplay() } }
    var path: UIBezierPath!
    var type = ""
    var id = 0
    var bDraggable = false
    var bOrigin = true
    var bMoved = false
    var bSelected = false
    var title = UITextField(frame: CGRect(x: 0, y: 5, width: 100, height: 20)) { didSet { setNeedsDisplay() } }
    let setTitle = UITextField()
    var editPanel = EditPanel()
    
    var neighborTop: ComponentView?
    var neighborButtom: ComponentView?
    var neighborRight: ComponentView?
    var neighborLeft: ComponentView?
    
    var componetViewNeighborList = [ComponentView]()
    
    var intarface1Top: InterfaceView?
    var intarface2Top: InterfaceView?
    var intarface3Top: InterfaceView?
    
    var intarface1Buttom: InterfaceView?
    var intarface2Buttom: InterfaceView?
    var intarface3Buttom: InterfaceView?
    
    var intarface1Right: InterfaceView?
    var intarface2Right: InterfaceView?
    var intarface3Right: InterfaceView?
    
    var intarface1Left: InterfaceView?
    var intarface2Left: InterfaceView?
    var intarface3Left: InterfaceView?
    
    var delegate: ComponentViewDelegate?
    
    func create(component: ComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool) {
        delegate?.create(component: component, frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
    }
    
    func merge(component: ComponentView) {
        delegate?.merge(component: component)
    }
    
    func select(component: ComponentView) {
        delegate?.select(component: component)
    }
    
    func delete(component: ComponentView) {
        delegate?.delete(component: component)
    }
    
    init(frame: CGRect, type: String , bDraggable: Bool,  bOrigin: Bool) {
        super.init(frame: frame)
        self.type = type
        self.bDraggable = bDraggable
        self.bOrigin = bOrigin
        self.backgroundColor = UIColor.clear
        fillColor = UIColor.white
        
        switch type {
        case "Rect":
            self.path = rectPath()
        case "RoundedRect":
            self.path = roundedRectPath()
        case "RoundedMultiRect":
            self.path = roundedMultiRectPath()
        case "Timer":
            self.path = cyclePath()
        case "Clock":
            self.path = cyclePath()
        case "Bus":
            self.path = rectPath()
        default:
            break
        }
        
        initGestureRecognizers()
        setupEditPanel()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let result = super.hitTest(point, with: event) {
            return result
        }
        
        for sub in self.subviews.reversed() {
            let pt = self.convert(point, to:sub)
            if let result = sub.hitTest(pt, with: event) {
                return result
            }
        }
        return nil
    }

    /*override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true;
    }*/

    internal func setInterface(side: String, interface1: String, interface2: String, interface3: String) {
        print("\(side): \(interface1)   \(interface2)   \(interface3)")
        setInterfaceAction(side: side, interface1: interface1, interface2: interface2, interface3: interface3)
    }
    
    func setInterfaceAction(side: String, interface1: String, interface2: String, interface3: String){
            if side == "Top" {
                if self.type != "Bus" {
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
                        break
                    case "passive":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface1Top = InterfaceView(frame: CGRect(x: 0, y: -28, width: 30, height: 30), interfaceType: "passive")
                        intarface1Top?.backgroundColor = UIColor.clear
                        intarface1Top?.id = "top1"
                        intarface1Top?.rotate(deg: 3)
                        intarface1Top?.type = "passive"
                        self.addSubview(intarface1Top!)
                        break
                    case "activeIn":
                        if self.type == "Timer" || self.type == "Clock" { break }
                        intarface1Top = InterfaceView(frame: CGRect(x: 0, y: -28, width: 30, height: 30), interfaceType: "activeOut") // to extend
                        intarface1Top?.backgroundColor = UIColor.clear
                        intarface1Top?.id = "top1"
                        intarface1Top?.rotate(deg: 3)
                        intarface1Top?.type = "activeOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface1Top?.addSubview(tech)
                        self.addSubview(intarface1Top!)
                        break
                    case "activeOut":
                        if self.type == "Timer" || self.type == "Clock" { break }
                        intarface1Top = InterfaceView(frame: CGRect(x: 0, y: -28, width: 30, height: 30), interfaceType: "activeIn") // to extend
                        intarface1Top?.backgroundColor = UIColor.clear
                        intarface1Top?.id = "top1"
                        intarface1Top?.rotate(deg: 3)
                        intarface1Top?.type = "activeIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "activeIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface1Top?.addSubview(tech)
                        self.addSubview(intarface1Top!)
                        break
                    case "activeInOut":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface1Top = InterfaceView(frame: CGRect(x: 0, y: -28, width: 30, height: 30), interfaceType: "activeInOut") // to extend
                        intarface1Top?.backgroundColor = UIColor.clear
                        intarface1Top?.id = "top1"
                        intarface1Top?.rotate(deg: 3)
                        intarface1Top?.type = "activeInOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 2, y: 1, width: 26, height: 26),interfaceType: "activeInOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface1Top?.addSubview(tech)
                        self.addSubview(intarface1Top!)
                        break
                    case "analogIn":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface1Top = InterfaceView(frame: CGRect(x: 0, y: -28, width: 30, height: 30), interfaceType: "analogIn") // to extend
                        intarface1Top?.backgroundColor = UIColor.clear
                        intarface1Top?.id = "top1"
                        intarface1Top?.rotate(deg: 3)
                        intarface1Top?.type = "analogIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "analogIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface1Top?.addSubview(tech)
                        self.addSubview(intarface1Top!)
                        break
                    case "analogOut":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface1Top = InterfaceView(frame: CGRect(x: 0, y: -28, width: 30, height: 30), interfaceType: "analogOut") // to extend
                        intarface1Top?.backgroundColor = UIColor.clear
                        intarface1Top?.id = "top1"
                        intarface1Top?.rotate(deg: 3)
                        intarface1Top?.type = "analogOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "analogOut")
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
                        break
                    case "passive":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -28, width: 30, height: 30), interfaceType: "passive")
                        intarface2Top?.backgroundColor = UIColor.clear
                        intarface2Top?.id = "top1"
                        intarface2Top?.rotate(deg: 3)
                        intarface2Top?.type = "passive"
                        self.addSubview(intarface2Top!)
                        break
                    case "activeIn":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -28, width: 30, height: 30), interfaceType: "activeOut") // to extend
                        intarface2Top?.backgroundColor = UIColor.clear
                        intarface2Top?.id = "top1"
                        intarface2Top?.rotate(deg: 3)
                        intarface2Top?.type = "activeOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface2Top?.addSubview(tech)
                        self.addSubview(intarface2Top!)
                        break
                    case "activeOut":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -28, width: 30, height: 30), interfaceType: "activeIn") // to extend
                        intarface2Top?.backgroundColor = UIColor.clear
                        intarface2Top?.id = "top1"
                        intarface2Top?.rotate(deg: 3)
                        intarface2Top?.type = "activeIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "activeIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface2Top?.addSubview(tech)
                        self.addSubview(intarface2Top!)
                        break
                    case "activeInOut":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -28, width: 30, height: 30), interfaceType: "activeInOut") // to extend
                        intarface2Top?.backgroundColor = UIColor.clear
                        intarface2Top?.id = "top1"
                        intarface2Top?.rotate(deg: 3)
                        intarface2Top?.type = "activeInOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 2, y: 1, width: 26, height: 26),interfaceType: "activeInOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface2Top?.addSubview(tech)
                        self.addSubview(intarface2Top!)
                        break
                    case "analogIn":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -28, width: 30, height: 30), interfaceType: "analogIn") // to extend
                        intarface2Top?.backgroundColor = UIColor.clear
                        intarface2Top?.id = "top1"
                        intarface2Top?.rotate(deg: 3)
                        intarface2Top?.type = "analogIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "analogIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface2Top?.addSubview(tech)
                        self.addSubview(intarface2Top!)
                        break
                    case "analogOut":
                        if self.type == "Timer" || self.type == "Clock" { break }
                        intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -28, width: 30, height: 30), interfaceType: "analogOut") // to extend
                        intarface2Top?.backgroundColor = UIColor.clear
                        intarface2Top?.id = "top1"
                        intarface2Top?.rotate(deg: 3)
                        intarface2Top?.type = "analogOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "analogOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface2Top?.addSubview(tech)
                        self.addSubview(intarface2Top!)
                        break
                    case "timing":
                        if self.type == "Timer" {
                            intarface2Top = InterfaceView(frame: CGRect(x: 21, y: -8, width: 30, height: 30), interfaceType: "timing") // to extend
                            intarface2Top?.backgroundColor = UIColor.clear
                            intarface2Top?.id = "top1"
                            //intarface2Top?.rotate(deg: 3)
                            intarface2Top?.type = "timing"
                            let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                            txtField.text = "T"
                            txtField.adjustsFontSizeToFitWidth = true
                            txtField.textAlignment = .center
                            txtField.font = UIFont.boldSystemFont(ofSize: 10)
                            intarface2Top?.addSubview(txtField)
                            self.addSubview(intarface2Top!)
                        } else if self.type == "Clock" {
                            intarface2Top = InterfaceView(frame: CGRect(x: 21, y: -8, width: 30, height: 30), interfaceType: "timing") // to extend
                            intarface2Top?.backgroundColor = UIColor.clear
                            intarface2Top?.id = "top1"
                            //intarface2Top?.rotate(deg: 3)
                            intarface2Top?.type = "timing"
                            let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                            txtField.text = "T"
                            txtField.adjustsFontSizeToFitWidth = true
                            txtField.textAlignment = .center
                            txtField.font = UIFont.boldSystemFont(ofSize: 10)
                            intarface2Top?.addSubview(txtField)
                            self.addSubview(intarface2Top!)
                        }else {
                            intarface2Top = InterfaceView(frame: CGRect(x: 35, y: -11, width: 30, height: 30), interfaceType: "timing") // to extend
                            intarface2Top?.backgroundColor = UIColor.clear
                            intarface2Top?.id = "top1"
                            //intarface2Top?.rotate(deg: 3)
                            intarface2Top?.type = "timing"
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
                        break
                    case "passive":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -28, width: 30, height: 30), interfaceType: "passive")
                        intarface3Top?.backgroundColor = UIColor.clear
                        intarface3Top?.id = "top1"
                        intarface3Top?.rotate(deg: 3)
                        intarface3Top?.type = "passive"
                        self.addSubview(intarface3Top!)
                        break
                    case "activeIn":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -28, width: 30, height: 30), interfaceType: "activeOut") // to extend
                        intarface3Top?.backgroundColor = UIColor.clear
                        intarface3Top?.id = "top1"
                        intarface3Top?.rotate(deg: 3)
                        intarface3Top?.type = "activeOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface3Top?.addSubview(tech)
                        self.addSubview(intarface3Top!)
                        break
                    case "activeOut":
                        if self.type == "Timer" || self.type == "Clock"  { break }
                        intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -28, width: 30, height: 30), interfaceType: "activeIn") // to extend
                        intarface3Top?.backgroundColor = UIColor.clear
                        intarface3Top?.id = "top1"
                        intarface3Top?.rotate(deg: 3)
                        intarface3Top?.type = "activeIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "activeIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface3Top?.addSubview(tech)
                        self.addSubview(intarface3Top!)
                        break
                    case "activeInOut":
                        if self.type == "Timer"  || self.type == "Clock" { break }
                        intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -28, width: 30, height: 30), interfaceType: "activeInOut") // to extend
                        intarface3Top?.backgroundColor = UIColor.clear
                        intarface3Top?.id = "top1"
                        intarface3Top?.rotate(deg: 3)
                        intarface3Top?.type = "activeInOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 2, y: 1, width: 26, height: 26),interfaceType: "activeInOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface3Top?.addSubview(tech)
                        self.addSubview(intarface3Top!)
                        break
                    case "analogIn":
                        if self.type == "Timer"  || self.type == "Clock" { break }
                        intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -28, width: 30, height: 30), interfaceType: "analogIn") // to extend
                        intarface3Top?.backgroundColor = UIColor.clear
                        intarface3Top?.id = "top1"
                        intarface3Top?.rotate(deg: 3)
                        intarface3Top?.type = "analogIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "analogIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface3Top?.addSubview(tech)
                        self.addSubview(intarface3Top!)
                        break
                    case "analogOut":
                        if self.type == "Timer"  || self.type == "Clock" { break }
                        intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -28, width: 30, height: 30), interfaceType: "analogOut") // to extend
                        intarface3Top?.backgroundColor = UIColor.clear
                        intarface3Top?.id = "top1"
                        intarface3Top?.rotate(deg: 3)
                        intarface3Top?.type = "analogOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "analogOut")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 4)
                        intarface3Top?.addSubview(tech)
                        self.addSubview(intarface3Top!)
                        break
                    case "timing":
                        /*intarface3Top = InterfaceView(frame: CGRect(x: 70, y: -11, width: 30, height: 30), interfaceType: "timing") // to extend
                         intarface3Top?.backgroundColor = UIColor.clear
                         intarface3Top?.id = "top1"
                         //intarface3Top?.rotate(deg: 3)
                         intarface3Top?.type = "timing"
                         let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                         txtField.text = "T"
                         txtField.adjustsFontSizeToFitWidth = true
                         txtField.textAlignment = .center
                         txtField.font = UIFont.boldSystemFont(ofSize: 10)
                         intarface3Top?.addSubview(txtField)
                         self.addSubview(intarface3Top!)*/
                        break
                    default:
                        break
                    }
                    
                }
            }
            else if side == "Right" {
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
                case "passive":
                    if self.type == "Timer"  || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface1Right = InterfaceView(frame: CGRect(x: 68, y: 0, width: 30, height: 30), interfaceType: "passive")
                    } else {
                        intarface1Right = InterfaceView(frame: CGRect(x: 98, y: 0, width: 30, height: 30), interfaceType: "passive")
                    }
                    intarface1Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface1Right?.id = "right1"
                    intarface1Right?.type = "passive"
                    self.addSubview(intarface1Right!)
                    break
                case "activeIn":
                    if self.type == "Timer"  || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface1Right = InterfaceView(frame: CGRect(x: 68, y: 0, width: 30, height: 30), interfaceType: "activeIn")
                    } else {
                        intarface1Right = InterfaceView(frame: CGRect(x: 98, y: 0, width: 30, height: 30), interfaceType: "activeIn")
                    }
                    intarface1Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface1Right?.id = "right1"
                    intarface1Right?.type = "activeIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface1Right?.addSubview(tech)
                    self.addSubview(intarface1Right!)
                    break
                case "activeOut":
                    if self.type == "Timer"  || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface1Right = InterfaceView(frame: CGRect(x: 68, y: 0, width: 30, height: 30), interfaceType: "activeOut")
                    } else {
                        intarface1Right = InterfaceView(frame: CGRect(x: 98, y: 0, width: 30, height: 30), interfaceType: "activeOut")
                    }
                    intarface1Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface1Right?.id = "right1"
                    intarface1Right?.type = "activeOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "activeOut")
                    tech.backgroundColor = UIColor.clear
                    intarface1Right?.addSubview(tech)
                    self.addSubview(intarface1Right!)
                    break
                case "activeInOut":
                    if self.type == "Timer"  || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface1Right = InterfaceView(frame: CGRect(x: 68, y: 0, width: 30, height: 30), interfaceType: "activeInOut")
                    } else {
                        intarface1Right = InterfaceView(frame: CGRect(x: 98, y: 0, width: 30, height: 30), interfaceType: "activeInOut")
                    }
                    intarface1Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface1Right?.id = "right1"
                    intarface1Right?.type = "activeInOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 1, width: 26, height: 26),interfaceType: "activeInOut")
                    tech.backgroundColor = UIColor.clear
                    intarface1Right?.addSubview(tech)
                    self.addSubview(intarface1Right!)
                    break
                case "analogIn":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface1Right = InterfaceView(frame: CGRect(x: 68, y: 0, width: 30, height: 30), interfaceType: "analogIn")
                    } else {
                        intarface1Right = InterfaceView(frame: CGRect(x: 98, y: 0, width: 30, height: 30), interfaceType: "analogIn")
                    }
                    intarface1Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface1Right?.id = "right1"
                    intarface1Right?.type = "analogIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "analogIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface1Right?.addSubview(tech)
                    self.addSubview(intarface1Right!)
                    break
                case "analogOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface1Right = InterfaceView(frame: CGRect(x: 68, y: 0, width: 30, height: 30), interfaceType: "analogOut")
                    } else {
                        intarface1Right = InterfaceView(frame: CGRect(x: 98, y: 0, width: 30, height: 30), interfaceType: "analogOut")
                    }
                    intarface1Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface1Right?.id = "right1"
                    intarface1Right?.type = "analogOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "analogOut")
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
                case "passive":
                    if self.type == "Timer"  || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 68, y: 35, width: 30, height: 30), interfaceType: "passive")
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 98, y: 35, width: 30, height: 30), interfaceType: "passive")
                    }
                    intarface2Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface2Right?.id = "right2"
                    intarface2Right?.type = "passive"
                    self.addSubview(intarface2Right!)
                    break
                case "activeIn":
                    if self.type == "Timer" || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 68, y: 35, width: 30, height: 30), interfaceType: "activeIn")
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 98, y: 35, width: 30, height: 30), interfaceType: "activeIn")
                    }
                    intarface2Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface2Right?.id = "right2"
                    intarface2Right?.type = "activeIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface2Right?.addSubview(tech)
                    self.addSubview(intarface2Right!)
                    break
                case "activeOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 68, y: 35, width: 30, height: 30), interfaceType: "activeOut")
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 98, y: 35, width: 30, height: 30), interfaceType: "activeOut")
                    }
                    intarface2Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface2Right?.id = "right2"
                    intarface2Right?.type = "activeOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "activeOut")
                    tech.backgroundColor = UIColor.clear
                    intarface2Right?.addSubview(tech)
                    self.addSubview(intarface2Right!)
                    break
                case "activeInOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 68, y: 35, width: 30, height: 30), interfaceType: "activeInOut")
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 98, y: 35, width: 30, height: 30), interfaceType: "activeInOut")
                    }
                    intarface2Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface2Right?.id = "right2"
                    intarface2Right?.type = "activeInOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 1, width: 26, height: 26),interfaceType: "activeInOut")
                    tech.backgroundColor = UIColor.clear
                    intarface2Right?.addSubview(tech)
                    self.addSubview(intarface2Right!)
                    break
                case "analogIn":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 68, y: 35, width: 30, height: 30), interfaceType: "analogIn")
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 98, y: 35, width: 30, height: 30), interfaceType: "analogIn")
                    }
                    intarface2Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface2Right?.id = "right2"
                    intarface2Right?.type = "analogIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "analogIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface2Right?.addSubview(tech)
                    self.addSubview(intarface2Right!)
                    break
                case "analogOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 68, y: 35, width: 30, height: 30), interfaceType: "analogOut")
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 98, y: 35, width: 30, height: 30), interfaceType: "analogOut")
                    }
                    intarface2Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface2Right?.id = "right2"
                    intarface2Right?.type = "analogOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "analogOut")
                    tech.backgroundColor = UIColor.clear
                    intarface2Right?.addSubview(tech)
                    self.addSubview(intarface2Right!)
                    break
                case "timing":
                    if self.type == "Timer"  || self.type == "Clock" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 48, y: 20, width: 30, height: 30), interfaceType: "timing")
                        intarface2Right?.backgroundColor = UIColor.clear
                        intarface2Right?.rotate(deg: 1)
                        intarface2Right?.id = "right2"
                        intarface2Right?.type = "timing"
                        let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                        txtField.text = "T"
                        txtField.adjustsFontSizeToFitWidth = true
                        txtField.textAlignment = .center
                        txtField.font = UIFont.boldSystemFont(ofSize: 10)
                        intarface2Right?.addSubview(txtField)
                        self.addSubview(intarface2Right!)
                    }
                    else if self.type == "Bus" {
                        intarface2Right = InterfaceView(frame: CGRect(x: 52, y: 35, width: 30, height: 30), interfaceType: "timing")
                        intarface2Right?.backgroundColor = UIColor.clear
                        intarface2Right?.rotate(deg: 1)
                        intarface2Right?.id = "right2"
                        intarface2Right?.type = "timing"
                        let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                        txtField.text = "T"
                        txtField.adjustsFontSizeToFitWidth = true
                        txtField.textAlignment = .center
                        txtField.font = UIFont.boldSystemFont(ofSize: 10)
                        intarface2Right?.addSubview(txtField)
                        self.addSubview(intarface2Right!)
                    } else {
                        intarface2Right = InterfaceView(frame: CGRect(x: 82, y: 35, width: 30, height: 30), interfaceType: "timing")
                        intarface2Right?.backgroundColor = UIColor.clear
                        intarface2Right?.rotate(deg: 1)
                        intarface2Right?.id = "right2"
                        intarface2Right?.type = "timing"
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
                case "passive":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface3Right = InterfaceView(frame: CGRect(x: 68, y: 70, width: 30, height: 30), interfaceType: "passive")
                    } else {
                        intarface3Right = InterfaceView(frame: CGRect(x: 98, y: 70, width: 30, height: 30), interfaceType: "passive")
                    }
                    intarface3Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface3Right?.id = "right3"
                    intarface3Right?.type = "passive"
                    self.addSubview(intarface3Right!)
                    break
                case "activeIn":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface3Right = InterfaceView(frame: CGRect(x: 68, y: 70, width: 30, height: 30), interfaceType: "activeIn")
                    } else {
                        intarface3Right = InterfaceView(frame: CGRect(x: 98, y: 70, width: 30, height: 30), interfaceType: "activeIn")
                    }
                    intarface3Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface3Right?.id = "right3"
                    intarface3Right?.type = "activeIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface3Right?.addSubview(tech)
                    self.addSubview(intarface3Right!)
                    break
                case "activeOut":
                    if self.type == "Timer"   || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface3Right = InterfaceView(frame: CGRect(x: 68, y: 70, width: 30, height: 30), interfaceType: "activeOut")
                    } else {
                        intarface3Right = InterfaceView(frame: CGRect(x: 98, y: 70, width: 30, height: 30), interfaceType: "activeOut")
                    }
                    intarface3Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface3Right?.id = "right3"
                    intarface3Right?.type = "activeOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "activeOut")
                    tech.backgroundColor = UIColor.clear
                    intarface3Right?.addSubview(tech)
                    self.addSubview(intarface3Right!)
                    break
                case "activeInOut":
                    if self.type == "Timer" || self.type == "Clock" { break }
                    if self.type == "Bus" {
                        intarface3Right = InterfaceView(frame: CGRect(x: 68, y: 70, width: 30, height: 30), interfaceType: "activeInOut")
                    } else {
                        intarface3Right = InterfaceView(frame: CGRect(x: 98, y: 70, width: 30, height: 30), interfaceType: "activeInOut")
                    }
                    intarface3Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface3Right?.id = "right3"
                    intarface3Right?.type = "activeInOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 1, width: 26, height: 26),interfaceType: "activeInOut")
                    tech.backgroundColor = UIColor.clear
                    intarface3Right?.addSubview(tech)
                    self.addSubview(intarface3Right!)
                    break
                case "analogIn":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface3Right = InterfaceView(frame: CGRect(x: 68, y: 70, width: 30, height: 30), interfaceType: "analogIn")
                    } else {
                        intarface3Right = InterfaceView(frame: CGRect(x: 98, y: 70, width: 30, height: 30), interfaceType: "analogIn")
                    }
                    intarface3Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface3Right?.id = "right3"
                    intarface3Right?.type = "analogIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "analogIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface3Right?.addSubview(tech)
                    self.addSubview(intarface3Right!)
                    break
                case "analogOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    if self.type == "Bus" {
                        intarface3Right = InterfaceView(frame: CGRect(x: 68, y: 70, width: 30, height: 30), interfaceType: "analogOut")
                    } else {
                        intarface3Right = InterfaceView(frame: CGRect(x: 98, y: 70, width: 30, height: 30), interfaceType: "analogOut")
                    }
                    intarface3Right?.backgroundColor = UIColor.clear
                    //intarface1Right?.rotate(deg: 1)
                    intarface3Right?.id = "right3"
                    intarface3Right?.type = "analogOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -1, y: 1, width: 30, height: 28),interfaceType: "analogOut")
                    tech.backgroundColor = UIColor.clear
                    intarface3Right?.addSubview(tech)
                    self.addSubview(intarface3Right!)
                    break
                case "timing":
                    break
                default:
                    break
                }
            }
            else if side == "Left" {
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
                case "passive":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface1Left = InterfaceView(frame: CGRect(x: -27, y: 0, width: 30, height: 30), interfaceType: "passive")
                    intarface1Left?.backgroundColor = UIColor.clear
                    intarface1Left?.rotate(deg: 2)
                    intarface1Left?.id = "left1"
                    intarface1Left?.type = "passive"
                    self.addSubview(intarface1Left!)
                    break
                case "activeIn":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface1Left = InterfaceView(frame: CGRect(x: -27, y: 0, width: 30, height: 30), interfaceType: "activeIn")
                    intarface1Left?.backgroundColor = UIColor.clear
                    intarface1Left?.rotate(deg: 2)
                    intarface1Left?.id = "left1"
                    intarface1Left?.type = "activeIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: "activeIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface1Left?.addSubview(tech)
                    self.addSubview(intarface1Left!)
                    break
                case "activeOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface1Left = InterfaceView(frame: CGRect(x: -27, y: 0, width: 30, height: 30), interfaceType: "activeOut")
                    intarface1Left?.backgroundColor = UIColor.clear
                    intarface1Left?.rotate(deg: 2)
                    intarface1Left?.id = "left1"
                    intarface1Left?.type = "activeOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "activeOut")
                    tech.backgroundColor = UIColor.clear
                    intarface1Left?.addSubview(tech)
                    self.addSubview(intarface1Left!)
                    break
                case "activeInOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface1Left = InterfaceView(frame: CGRect(x: -27, y: 0, width: 30, height: 30), interfaceType: "activeInOut")
                    intarface1Left?.backgroundColor = UIColor.clear
                    intarface1Left?.rotate(deg: 2)
                    intarface1Left?.id = "left1"
                    intarface1Left?.type = "activeInOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: "activeInOut")
                    tech.backgroundColor = UIColor.clear
                    intarface1Left?.addSubview(tech)
                    self.addSubview(intarface1Left!)
                    break
                case "analogIn":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface1Left = InterfaceView(frame: CGRect(x: -27, y: 0, width: 30, height: 30), interfaceType: "analogIn")
                    intarface1Left?.backgroundColor = UIColor.clear
                    intarface1Left?.rotate(deg: 2)
                    intarface1Left?.id = "left1"
                    intarface1Left?.type = "analogIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 30),interfaceType: "analogIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface1Left?.addSubview(tech)
                    self.addSubview(intarface1Left!)
                    break
                case "analogOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface1Left = InterfaceView(frame: CGRect(x: -27, y: 0, width: 30, height: 30), interfaceType: "analogOut")
                    intarface1Left?.backgroundColor = UIColor.clear
                    intarface1Left?.rotate(deg: 2)
                    intarface1Left?.id = "left1"
                    intarface1Left?.type = "analogOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "analogOut")
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
                case "passive":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface2Left = InterfaceView(frame: CGRect(x: -27, y: 35, width: 30, height: 30), interfaceType: "passive")
                    intarface2Left?.backgroundColor = UIColor.clear
                    intarface2Left?.rotate(deg: 2)
                    intarface2Left?.id = "left2"
                    intarface2Left?.type = "passive"
                    self.addSubview(intarface2Left!)
                    break
                case "activeIn":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface2Left = InterfaceView(frame: CGRect(x: -27, y: 35, width: 30, height: 30), interfaceType: "activeIn")
                    intarface2Left?.backgroundColor = UIColor.clear
                    intarface2Left?.rotate(deg: 2)
                    intarface2Left?.id = "left2"
                    intarface2Left?.type = "activeIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: "activeIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface2Left?.addSubview(tech)
                    self.addSubview(intarface2Left!)
                    break
                case "activeOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface2Left = InterfaceView(frame: CGRect(x: -27, y: 35, width: 30, height: 30), interfaceType: "activeOut")
                    intarface2Left?.backgroundColor = UIColor.clear
                    intarface2Left?.rotate(deg: 2)
                    intarface2Left?.id = "left2"
                    intarface2Left?.type = "activeOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "activeOut")
                    tech.backgroundColor = UIColor.clear
                    intarface2Left?.addSubview(tech)
                    self.addSubview(intarface2Left!)
                    break
                case "activeInOut":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface2Left = InterfaceView(frame: CGRect(x: -27, y: 35, width: 30, height: 30), interfaceType: "activeInOut")
                    intarface2Left?.backgroundColor = UIColor.clear
                    intarface2Left?.rotate(deg: 2)
                    intarface2Left?.id = "left2"
                    intarface2Left?.type = "activeInOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: "activeInOut")
                    tech.backgroundColor = UIColor.clear
                    intarface2Left?.addSubview(tech)
                    self.addSubview(intarface2Left!)
                    break
                case "analogIn":
                    if self.type == "Timer" || self.type == "Clock"  { break }
                    intarface2Left = InterfaceView(frame: CGRect(x: -27, y: 35, width: 30, height: 30), interfaceType: "analogIn")
                    intarface2Left?.backgroundColor = UIColor.clear
                    intarface2Left?.rotate(deg: 2)
                    intarface2Left?.id = "left2"
                    intarface2Left?.type = "analogIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 30),interfaceType: "analogIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface2Left?.addSubview(tech)
                    self.addSubview(intarface2Left!)
                    break
                case "analogOut":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface2Left = InterfaceView(frame: CGRect(x: -27, y: 35, width: 30, height: 30), interfaceType: "analogOut")
                    intarface2Left?.backgroundColor = UIColor.clear
                    intarface2Left?.rotate(deg: 2)
                    intarface2Left?.id = "left2"
                    intarface2Left?.type = "analogOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "analogOut")
                    tech.backgroundColor = UIColor.clear
                    intarface2Left?.addSubview(tech)
                    self.addSubview(intarface2Left!)
                    break
                case "timing":
                    if self.type == "Timer" || self.type == "Clock"  {
                        intarface2Left = InterfaceView(frame: CGRect(x: -8, y: 20, width: 30, height: 30), interfaceType: "timing")
                        intarface2Left?.backgroundColor = UIColor.clear
                        intarface2Left?.rotate(deg: 3)
                        intarface2Left?.id = "left2"
                        intarface2Left?.type = "timing"
                        let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                        txtField.text = "T"
                        txtField.adjustsFontSizeToFitWidth = true
                        txtField.textAlignment = .center
                        txtField.font = UIFont.boldSystemFont(ofSize: 10)
                        intarface2Left?.addSubview(txtField)
                        self.addSubview(intarface2Left!)
                    } else {
                        intarface2Left = InterfaceView(frame: CGRect(x: -12, y: 35, width: 30, height: 30), interfaceType: "timing")
                        intarface2Left?.backgroundColor = UIColor.clear
                        intarface2Left?.rotate(deg: 3)
                        intarface2Left?.id = "left1"
                        intarface2Left?.type = "timing"
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
                case "passive":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface3Left = InterfaceView(frame: CGRect(x: -27, y: 70, width: 30, height: 30), interfaceType: "passive")
                    intarface3Left?.backgroundColor = UIColor.clear
                    intarface3Left?.rotate(deg: 2)
                    intarface3Left?.id = "left3"
                    intarface3Left?.type = "passive"
                    self.addSubview(intarface3Left!)
                    break
                case "activeIn":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface3Left = InterfaceView(frame: CGRect(x: -27, y: 70, width: 30, height: 30), interfaceType: "activeIn")
                    intarface3Left?.backgroundColor = UIColor.clear
                    intarface3Left?.rotate(deg: 2)
                    intarface3Left?.id = "left3"
                    intarface3Left?.type = "activeIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 28),interfaceType: "activeIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface3Left?.addSubview(tech)
                    self.addSubview(intarface3Left!)
                    break
                case "activeOut":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface3Left = InterfaceView(frame: CGRect(x: -27, y: 70, width: 30, height: 30), interfaceType: "activeOut")
                    intarface3Left?.backgroundColor = UIColor.clear
                    intarface3Left?.rotate(deg: 2)
                    intarface3Left?.id = "left3"
                    intarface3Left?.type = "activeOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "activeOut")
                    tech.backgroundColor = UIColor.clear
                    intarface3Left?.addSubview(tech)
                    self.addSubview(intarface3Left!)
                    break
                case "activeInOut":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface3Left = InterfaceView(frame: CGRect(x: -27, y: 70, width: 30, height: 30), interfaceType: "activeInOut")
                    intarface3Left?.backgroundColor = UIColor.clear
                    intarface3Left?.rotate(deg: 2)
                    intarface3Left?.id = "left3"
                    intarface3Left?.type = "activeInOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: "activeInOut")
                    tech.backgroundColor = UIColor.clear
                    intarface3Left?.addSubview(tech)
                    self.addSubview(intarface3Left!)
                    break
                case "analogIn":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface3Left = InterfaceView(frame: CGRect(x: -27, y: 70, width: 30, height: 30), interfaceType: "analogIn")
                    intarface3Left?.backgroundColor = UIColor.clear
                    intarface3Left?.rotate(deg: 2)
                    intarface3Left?.id = "left3"
                    intarface3Left?.type = "analogIn"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: 0, width: 30, height: 30),interfaceType: "analogIn")
                    tech.backgroundColor = UIColor.clear
                    tech.rotate(deg: 2)
                    intarface3Left?.addSubview(tech)
                    self.addSubview(intarface3Left!)
                    break
                case "analogOut":
                    if self.type == "Timer"  || self.type == "Clock"  { break }
                    intarface3Left = InterfaceView(frame: CGRect(x: -27, y: 70, width: 30, height: 30), interfaceType: "analogOut")
                    intarface3Left?.backgroundColor = UIColor.clear
                    intarface3Left?.rotate(deg: 2)
                    intarface3Left?.id = "left3"
                    intarface3Left?.type = "analogOut"
                    let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "analogOut")
                    tech.backgroundColor = UIColor.clear
                    intarface3Left?.addSubview(tech)
                    self.addSubview(intarface3Left!)
                    break
                case "timing":
                    break
                default:
                    break
                }
            }
            else if side == "Buttom" {
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
                    case "passive":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface1Buttom = InterfaceView(frame: CGRect(x: 0, y: 98, width: 30, height: 30), interfaceType: "passive")
                        intarface1Buttom?.backgroundColor = UIColor.clear
                        intarface1Buttom?.rotate(deg: 1)
                        intarface1Buttom?.id = "buttom1"
                        intarface1Buttom?.type = "passive"
                        self.addSubview(intarface1Buttom!)
                        break
                    case "activeIn":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface1Buttom = InterfaceView(frame: CGRect(x: 0, y: 98, width: 30, height: 30), interfaceType: "activeIn")
                        intarface1Buttom?.backgroundColor = UIColor.clear
                        intarface1Buttom?.rotate(deg: 1)
                        intarface1Buttom?.id = "buttom1"
                        intarface1Buttom?.type = "activeIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface1Buttom?.addSubview(tech)
                        self.addSubview(intarface1Buttom!)
                        break
                    case "activeOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface1Buttom = InterfaceView(frame: CGRect(x: 0, y: 98, width: 30, height: 30), interfaceType: "activeOut")
                        intarface1Buttom?.backgroundColor = UIColor.clear
                        intarface1Buttom?.rotate(deg: 1)
                        intarface1Buttom?.id = "buttom1"
                        intarface1Buttom?.type = "activeOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "activeOut")
                        tech.backgroundColor = UIColor.clear
                        intarface1Buttom?.addSubview(tech)
                        self.addSubview(intarface1Buttom!)
                        break
                    case "activeInOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface1Buttom = InterfaceView(frame: CGRect(x: 0, y: 98, width: 30, height: 30), interfaceType: "activeInOut")
                        intarface1Buttom?.backgroundColor = UIColor.clear
                        intarface1Buttom?.rotate(deg: 1)
                        intarface1Buttom?.id = "buttom1"
                        intarface1Buttom?.type = "activeInOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: "activeInOut")
                        tech.backgroundColor = UIColor.clear
                        intarface1Buttom?.addSubview(tech)
                        self.addSubview(intarface1Buttom!)
                        break
                    case "analogIn":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface1Buttom = InterfaceView(frame: CGRect(x: 0, y: 98, width: 30, height: 30), interfaceType: "analogIn")
                        intarface1Buttom?.backgroundColor = UIColor.clear
                        intarface1Buttom?.rotate(deg: 1)
                        intarface1Buttom?.id = "buttom1"
                        intarface1Buttom?.type = "analogIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -2, width: 30, height: 30),interfaceType: "analogIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface1Buttom?.addSubview(tech)
                        self.addSubview(intarface1Buttom!)
                        break
                    case "analogOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface1Buttom = InterfaceView(frame: CGRect(x: 0, y: 98, width: 30, height: 30), interfaceType: "analogOut")
                        intarface1Buttom?.backgroundColor = UIColor.clear
                        intarface1Buttom?.rotate(deg: 1)
                        intarface1Buttom?.id = "buttom1"
                        intarface1Buttom?.type = "analogOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "analogOut")
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
                    case "passive":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 98, width: 30, height: 30), interfaceType: "passive")
                        intarface2Buttom?.backgroundColor = UIColor.clear
                        intarface2Buttom?.rotate(deg: 1)
                        intarface2Buttom?.id = "buttom2"
                        intarface2Buttom?.type = "passive"
                        self.addSubview(intarface2Buttom!)
                        break
                    case "activeIn":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 98, width: 30, height: 30), interfaceType: "activeIn")
                        intarface2Buttom?.backgroundColor = UIColor.clear
                        intarface2Buttom?.rotate(deg: 1)
                        intarface2Buttom?.id = "buttom2"
                        intarface2Buttom?.type = "activeIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface2Buttom?.addSubview(tech)
                        self.addSubview(intarface2Buttom!)
                        break
                    case "activeOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 98, width: 30, height: 30), interfaceType: "activeOut")
                        intarface2Buttom?.backgroundColor = UIColor.clear
                        intarface2Buttom?.rotate(deg: 1)
                        intarface2Buttom?.id = "buttom2"
                        intarface2Buttom?.type = "activeOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "activeOut")
                        tech.backgroundColor = UIColor.clear
                        intarface2Buttom?.addSubview(tech)
                        self.addSubview(intarface2Buttom!)
                        break
                    case "activeInOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 98, width: 30, height: 30), interfaceType: "activeInOut")
                        intarface2Buttom?.backgroundColor = UIColor.clear
                        intarface2Buttom?.rotate(deg: 1)
                        intarface2Buttom?.id = "buttom2"
                        intarface2Buttom?.type = "activeInOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: "activeInOut")
                        tech.backgroundColor = UIColor.clear
                        intarface2Buttom?.addSubview(tech)
                        self.addSubview(intarface2Buttom!)
                        break
                    case "analogIn":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 98, width: 30, height: 30), interfaceType: "analogIn")
                        intarface2Buttom?.backgroundColor = UIColor.clear
                        intarface2Buttom?.rotate(deg: 1)
                        intarface2Buttom?.id = "buttom2"
                        intarface2Buttom?.type = "analogIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -2, width: 30, height: 30),interfaceType: "analogIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface2Buttom?.addSubview(tech)
                        self.addSubview(intarface2Buttom!)
                        break
                    case "analogOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 98, width: 30, height: 30), interfaceType: "analogOut")
                        intarface2Buttom?.backgroundColor = UIColor.clear
                        intarface2Buttom?.rotate(deg: 1)
                        intarface2Buttom?.id = "buttom2"
                        intarface2Buttom?.type = "analogOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "analogOut")
                        tech.backgroundColor = UIColor.clear
                        intarface2Buttom?.addSubview(tech)
                        self.addSubview(intarface2Buttom!)
                        break
                    case "timing":
                        if self.type == "Timer"  || self.type == "Clock"  {
                            intarface2Buttom = InterfaceView(frame: CGRect(x: 19, y: 48, width: 30, height: 30), interfaceType: "timing")
                            intarface2Buttom?.backgroundColor = UIColor.clear
                            intarface2Buttom?.rotate(deg: 2)
                            intarface2Buttom?.id = "buttom2"
                            intarface2Buttom?.type = "timing"
                            let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 3, width: 30, height: 10));
                            txtField.text = "T"
                            txtField.adjustsFontSizeToFitWidth = true
                            txtField.textAlignment = .center
                            txtField.font = UIFont.boldSystemFont(ofSize: 10)
                            intarface2Buttom?.addSubview(txtField)
                            self.addSubview(intarface2Buttom!)
                        } else {
                            intarface2Buttom = InterfaceView(frame: CGRect(x: 35, y: 82, width: 30, height: 30), interfaceType: "timing")
                            intarface2Buttom?.backgroundColor = UIColor.clear
                            intarface2Buttom?.rotate(deg: 2)
                            intarface2Buttom?.id = "buttom1"
                            intarface2Buttom?.type = "timing"
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
                    case "passive":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface3Buttom = InterfaceView(frame: CGRect(x: 70, y: 98, width: 30, height: 30), interfaceType: "passive")
                        intarface3Buttom?.backgroundColor = UIColor.clear
                        intarface3Buttom?.rotate(deg: 1)
                        intarface3Buttom?.id = "buttom3"
                        intarface3Buttom?.type = "passive"
                        self.addSubview(intarface3Buttom!)
                        break
                    case "activeIn":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface3Buttom = InterfaceView(frame: CGRect(x: 70, y: 98, width: 30, height: 30), interfaceType: "activeIn")
                        intarface3Buttom?.backgroundColor = UIColor.clear
                        intarface3Buttom?.rotate(deg: 1)
                        intarface3Buttom?.id = "buttom3"
                        intarface3Buttom?.type = "activeIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -1, width: 30, height: 28),interfaceType: "activeIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface3Buttom?.addSubview(tech)
                        self.addSubview(intarface3Buttom!)
                        break
                    case "activeOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface3Buttom = InterfaceView(frame: CGRect(x: 70, y: 98, width: 30, height: 30), interfaceType: "activeOut")
                        intarface3Buttom?.backgroundColor = UIColor.clear
                        intarface3Buttom?.rotate(deg: 1)
                        intarface3Buttom?.id = "buttom3"
                        intarface3Buttom?.type = "activeOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "activeOut")
                        tech.backgroundColor = UIColor.clear
                        intarface3Buttom?.addSubview(tech)
                        self.addSubview(intarface3Buttom!)
                        break
                    case "activeInOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface3Buttom = InterfaceView(frame: CGRect(x: 70, y: 98, width: 30, height: 30), interfaceType: "activeInOut")
                        intarface3Buttom?.backgroundColor = UIColor.clear
                        intarface3Buttom?.rotate(deg: 1)
                        intarface3Buttom?.id = "buttom3"
                        intarface3Buttom?.type = "activeInOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 27, height: 27),interfaceType: "activeInOut")
                        tech.backgroundColor = UIColor.clear
                        intarface3Buttom?.addSubview(tech)
                        self.addSubview(intarface3Buttom!)
                        break
                    case "analogIn":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface3Buttom = InterfaceView(frame: CGRect(x: 70, y: 98, width: 30, height: 30), interfaceType: "analogIn")
                        intarface3Buttom?.backgroundColor = UIColor.clear
                        intarface3Buttom?.rotate(deg: 1)
                        intarface3Buttom?.id = "buttom3"
                        intarface3Buttom?.type = "analogIn"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: -15, y: -2, width: 30, height: 30),interfaceType: "analogIn")
                        tech.backgroundColor = UIColor.clear
                        tech.rotate(deg: 2)
                        intarface3Buttom?.addSubview(tech)
                        self.addSubview(intarface3Buttom!)
                        break
                    case "analogOut":
                        if self.type == "Timer"  || self.type == "Clock"  { break }
                        intarface3Buttom = InterfaceView(frame: CGRect(x: 70, y: 98, width: 30, height: 30), interfaceType: "analogOut")
                        intarface3Buttom?.backgroundColor = UIColor.clear
                        intarface3Buttom?.rotate(deg: 1)
                        intarface3Buttom?.id = "buttom3"
                        intarface3Buttom?.type = "analogOut"
                        let tech = InterfaceTechnologieView(frame: CGRect(x: 0, y: 0, width: 30, height: 30),interfaceType: "analogOut")
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
            }
    }
    
    func setupEditPanel() {
        
        editPanel.layer.shadowColor = UIColor.gray.cgColor
        editPanel.layer.shadowOpacity = 1
        editPanel.layer.shadowOffset = CGSize.zero
        editPanel.layer.shadowRadius = 3
        editPanel.backgroundColor = UIColor(hue: 0.1694, saturation: 0.02, brightness: 0.89, alpha: 1.0)
        editPanel.layer.shouldRasterize = true
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 30))
        titleLabel.text = "Name"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
        editPanel.addSubview(titleLabel)
        
        setTitle.frame = (frame: CGRect(x: 0, y: 30, width: 210, height: 30))
        setTitle.backgroundColor = UIColor.white
        setTitle.adjustsFontSizeToFitWidth = true
        setTitle.textAlignment = .center
        setTitle.isUserInteractionEnabled = true;
        setTitle.addTarget(self, action: #selector(setTitleAction), for: .editingDidEnd)
        editPanel.addSubview(setTitle)
        
        let intarfaceTopLabel = UILabel(frame: CGRect(x: 0, y: 60, width: 210, height: 30))
        intarfaceTopLabel.text = "Interface Top"
        intarfaceTopLabel.adjustsFontSizeToFitWidth = true
        intarfaceTopLabel.textAlignment = .center
        intarfaceTopLabel.font = UIFont.boldSystemFont(ofSize: 14)
        intarfaceTopLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
        editPanel.addSubview(intarfaceTopLabel)
        
        let pickerInterfaceTop = InterfacePicker(frame: CGRect(x: 0, y: 90, width: 210, height: 35.0))
        pickerInterfaceTop.type = "InterfaceTop"
        pickerInterfaceTop.delegate = self
        editPanel.addSubview(pickerInterfaceTop)

        let intarfaceRightLabel = UILabel(frame: CGRect(x: 0, y: 120, width: 210, height: 30))
        intarfaceRightLabel.text = "Interface Right"
        intarfaceRightLabel.adjustsFontSizeToFitWidth = true
        intarfaceRightLabel.textAlignment = .center
        intarfaceRightLabel.font = UIFont.boldSystemFont(ofSize: 14)
        intarfaceRightLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
        editPanel.addSubview(intarfaceRightLabel)
        
        let pickerInterfaceRight = InterfacePicker(frame: CGRect(x: 0, y: 150, width: 210, height: 35.0))
        pickerInterfaceRight.type = "InterfaceRight"
        pickerInterfaceRight.delegate = self
        editPanel.addSubview(pickerInterfaceRight)

        let intarfaceLeftLabel = UILabel(frame: CGRect(x: 0, y: 180, width: 210, height: 30))
        intarfaceLeftLabel.text = "Interface Left"
        intarfaceLeftLabel.adjustsFontSizeToFitWidth = true
        intarfaceLeftLabel.textAlignment = .center
        intarfaceLeftLabel.font = UIFont.boldSystemFont(ofSize: 14)
        intarfaceLeftLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
        editPanel.addSubview(intarfaceLeftLabel)
        
        let pickerInterfaceLeft = InterfacePicker(frame: CGRect(x: 0, y: 210, width: 210, height: 35.0))
        pickerInterfaceLeft.type = "InterfaceLeft"
        pickerInterfaceLeft.delegate = self
        editPanel.addSubview(pickerInterfaceLeft)
        
        let intarfaceButtomLabel = UILabel(frame: CGRect(x: 0, y: 240, width: 210, height: 30))
        intarfaceButtomLabel.text = "Interface Buttom"
        intarfaceButtomLabel.adjustsFontSizeToFitWidth = true
        intarfaceButtomLabel.textAlignment = .center
        intarfaceButtomLabel.font = UIFont.boldSystemFont(ofSize: 14)
        intarfaceButtomLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
        editPanel.addSubview(intarfaceButtomLabel)
        
        let pickerInterfaceButtom = InterfacePicker(frame: CGRect(x: 0, y: 270, width: 210, height: 35.0))
        pickerInterfaceButtom.type = "InterfaceButtom"
        pickerInterfaceButtom.delegate = self
        editPanel.addSubview(pickerInterfaceButtom)
        
        let colorLabel = UILabel(frame: CGRect(x: 0, y: 300, width: 210, height: 30))
        colorLabel.text = "Farbe"
        colorLabel.adjustsFontSizeToFitWidth = true
        colorLabel.textAlignment = .center
        colorLabel.font = UIFont.boldSystemFont(ofSize: 14)
        colorLabel.backgroundColor = UIColor(hue: 0.1111, saturation: 0.01, brightness: 0.95, alpha: 1.0)
        editPanel.addSubview(colorLabel)
        
        let setWhiteColorButton = UIButton()
        setWhiteColorButton.frame = (frame: CGRect(x: 5, y: 340, width: 20, height: 20))
        setWhiteColorButton.backgroundColor = UIColor.white
        setWhiteColorButton.addTarget(self, action: #selector(setWhiteColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setWhiteColorButton)
        
        let setGrayColorButton = UIButton()
        setGrayColorButton.frame = (frame: CGRect(x: 30, y: 340, width: 20, height: 20))
        setGrayColorButton.backgroundColor = UIColor.gray
        setGrayColorButton.addTarget(self, action: #selector(setGrayColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setGrayColorButton)
        
        let setOrangeColorButton = UIButton()
        setOrangeColorButton.frame = (frame: CGRect(x: 55, y: 340, width: 20, height: 20))
        setOrangeColorButton.backgroundColor = UIColor.orange
        setOrangeColorButton.addTarget(self, action: #selector(setOrangeColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setOrangeColorButton)
        
        let setGreenColorButton = UIButton()
        setGreenColorButton.frame = (frame: CGRect(x: 80, y: 340, width: 20, height: 20))
        setGreenColorButton.backgroundColor = UIColor.green
        setGreenColorButton.addTarget(self, action: #selector(setGreenColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setGreenColorButton)
        
        let setBlueColorButton = UIButton()
        setBlueColorButton.frame = (frame: CGRect(x: 105, y: 340, width: 20, height: 20))
        setBlueColorButton.backgroundColor = UIColor.blue
        setBlueColorButton.addTarget(self, action: #selector(setBlueColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setBlueColorButton)
        
        let setRedColorButton = UIButton()
        setRedColorButton.frame = (frame: CGRect(x: 130, y: 340, width: 20, height: 20))
        setRedColorButton.backgroundColor = UIColor.red
        setRedColorButton.addTarget(self, action: #selector(setRedColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setRedColorButton)
        
        let setYellowColorButton = UIButton()
        setYellowColorButton.frame = (frame: CGRect(x: 155, y: 340, width: 20, height: 20))
        setYellowColorButton.backgroundColor = UIColor.yellow
        setYellowColorButton.addTarget(self, action: #selector(setYellowColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setYellowColorButton)
        
        let setCyanColorButton = UIButton()
        setCyanColorButton.frame = (frame: CGRect(x: 180, y: 340, width: 20, height: 20))
        setCyanColorButton.backgroundColor = UIColor.cyan
        setCyanColorButton.addTarget(self, action: #selector(setCyanColorButtonAction), for: .touchUpInside)
        editPanel.addSubview(setCyanColorButton)
        
        let deleteButton = UIButton(frame: CGRect(x: 0, y: 370, width: 210, height: 30))
        deleteButton.setTitle("Löschen", for: .normal)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        deleteButton.addTarget(self, action: #selector(remove), for: .touchUpInside)
        editPanel.addSubview(deleteButton)
    }
    
    func setTitleAction(sender: UIButton!) {
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        self.title.text! = self.setTitle.text!
        self.addSubview(title)
    }
    
    func setWhiteColorButtonAction(color: UIColor) { self.fillColor = UIColor.white }
    func setGrayColorButtonAction(color: UIColor) { self.fillColor =  UIColor.gray /*UIColor(hue: 0.2, saturation: 0.8, brightness: 1.0, alpha: 0.8)*/}
    func setOrangeColorButtonAction(color: UIColor) { self.fillColor = UIColor.orange }
    func setGreenColorButtonAction(color: UIColor) { self.fillColor = UIColor.green }
    func setBlueColorButtonAction(color: UIColor) { self.fillColor = UIColor.blue }
    func setRedColorButtonAction(color: UIColor) { self.fillColor = UIColor.red }
    func setYellowColorButtonAction(color: UIColor) { self.fillColor = UIColor.yellow; height = height + 100.0; print(height)}
    func setCyanColorButtonAction(color: UIColor) { self.fillColor = UIColor.cyan; height = height - 100.0; print(height) }
    
    var orient = CGFloat(0.0)
    
    func rotate() {
        orient = orient + CGFloat(M_PI_2)
        self.transform = CGAffineTransform(rotationAngle: orient)
    }
    
    func removeFromNeighborList (){
        for c in componetViewNeighborList {
            if c.id == id {
                componetViewNeighborList.remove(at: id)
            }
        }
    }
    
    func remove(){
        editPanel.removeFromSuperview()
        if self.type == "RoundedMultiRect" {
            self.superview?.removeFromSuperview()
            self.removeFromSuperview()
            delete(component: self)
        } else {
            self.removeFromSuperview()
            delete(component: self)
        }
        removeFromNeighborList()
    }
    
    func initGestureRecognizers() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR: )))
        addGestureRecognizer(tapGR)
        
        if(bDraggable){
            let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR: )))
            addGestureRecognizer(panGR)
        }
    }
    
    
    func didTap(tapGR: UITapGestureRecognizer) {
        if !bSelected {
            bSelected = true
        } else {
            bSelected = false
        }
        if !bOrigin {
            select(component: self)
        }
    }
    
    func didPan(panGR: UIPanGestureRecognizer) {
        
        var translation = panGR.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(CGPoint.zero, in: self)
        
        switch (panGR.state) {
        case .changed:
            bMoved = true
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
                    (self.subviews[0] as! ComponentView).bSelected = false
                    (self.subviews[0] as! ComponentView).bOrigin = false
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
    
    var path2: UIBezierPath!
    var drawSecondPath = false
    
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
        //let insetRect = self.bounds.insetBy(dx: lineWidth,dy: lineWidth)
        //return UIBezierPath(ovalIn: insetRect)
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
}
