import UIKit

var componentViewId = 0
var editPanelViewId = 0

func generateComponentViewId() -> Int {
    componentViewId += 1
    return componentViewId
}

func generateEditPanelViewId() -> Int {
    editPanelViewId += 1
    return componentViewId
}

class ViewController: UIViewController, ComponentViewDelegate {
    var componentViewList = [ComponentView]()
    var editPanelViewList = [EditPanel]()
    
    @IBOutlet weak var background: UIImageView!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        background = UIImageView(image: UIImage(named: "backgroundGray.jpg"))
        
        
        /*scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = imageView.bounds.size
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        let container = UIView(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: 120))
        container.backgroundColor = UIColor(hue: 210/360, saturation: 0/100, brightness: 97/100, alpha: 1.0)
        view.addSubview(container)
        
        initGestureRecognizers()

        let v1 = ComponentView(frame: CGRect(x: 150.0, y: 80, width: 100.0, height: 100.0),
                               type: "Rect",
                               bDraggable: true,
                               bOrigin: true)
        v1.delegate = self
        v1.id = generateComponentViewId()
        view.addSubview(v1)
        componentViewList.append(v1)
        
        let v2 = ComponentView(frame: CGRect(x: 300.0, y: 80, width: 100.0, height: 100.0),
                               type: "RoundedRect",
                               bDraggable: true,
                               bOrigin: true)
        v2.delegate = self
        v2.id = generateComponentViewId()
        view.addSubview(v2)
        componentViewList.append(v2)
        
        let v3 = ComponentView(frame: CGRect(x: 450.0, y: 80, width: 100.0, height: 100.0),
                               type: "RoundedMultiRect",
                               bDraggable: true,
                               bOrigin: true)
        let v3_1 = ComponentView(frame: CGRect(x: 3.0, y: 3.0, width: 100.0, height: 100.0),
                                 type: "RoundedMultiRect",
                                 bDraggable: false,
                                 bOrigin: true)
        v3.addSubview(v3_1)
        v3.delegate = self
        v3_1.delegate = self
        let tmp = generateComponentViewId()
        v3.id = tmp
        v3_1.id = tmp
        view.addSubview(v3)
        componentViewList.append(v3)
        
        let v4 = ComponentView(frame: CGRect(x: 600.0, y: 80, width: 70.0, height: 100.0),
                               type: "Bus",
                               bDraggable: true,
                               bOrigin: true)
        v4.delegate = self
        v4.id = generateComponentViewId()
        let txtFieldBus: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
        txtFieldBus.text = "Bus"
        txtFieldBus.adjustsFontSizeToFitWidth = true
        txtFieldBus.textAlignment = .center
        txtFieldBus.font = UIFont.boldSystemFont(ofSize: 10)
        v4.addSubview(txtFieldBus)
        view.addSubview(v4)
        componentViewList.append(v4)
        
        let v5 = ComponentView(frame: CGRect(x: 700.0, y: 100, width: 70.0, height: 90.0),
                               type: "Timer",
                               bDraggable: true,
                               bOrigin: true)
        v5.drawSecondPath = true
        v5.delegate = self
        v5.id = generateComponentViewId()
        let txtField: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
        txtField.text = "Timer"
        txtField.adjustsFontSizeToFitWidth = true
        txtField.textAlignment = .center
        txtField.font = UIFont.boldSystemFont(ofSize: 10)
        v5.addSubview(txtField)
        view.addSubview(v5)
        componentViewList.append(v5)
        
        let v6 = ComponentView(frame: CGRect(x: 800.0, y: 100, width: 70.0, height: 90.0),
                               type: "Clock",
                               bDraggable: true,
                               bOrigin: true)
        v6.drawSecondPath = true
        v6.delegate = self
        v6.id = generateComponentViewId()
        let txtField2: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
        txtField2.text = "Clock"
        txtField2.adjustsFontSizeToFitWidth = true
        txtField2.textAlignment = .center
        txtField2.font = UIFont.boldSystemFont(ofSize: 10)
        v6.addSubview(txtField2)
        view.addSubview(v6)
        componentViewList.append(v6)*/
    }
    
    func initGestureRecognizers() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR: )))
        view.addGestureRecognizer(tapGR)
        
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(pinchGR: )))
        view.addGestureRecognizer(pinchGR)
        
    }
    
    func didTap(tapGR: UITapGestureRecognizer) {
        for editPanel in editPanelViewList {
            editPanel.removeFromSuperview()
        }
        
        for cv in componentViewList {
            if cv.type == "RoundedMultiRect" {
                (cv.subviews[0] as! ComponentView).bSelected = false
            }
            cv.bSelected = false
        }
    }
    
    func didPinch(pinchGR: UIPinchGestureRecognizer) {
        
        let scale = pinchGR.scale
        /*for comp in componentViewList {
            if comp.bOrigin == false {
                comp.transform = comp.transform.scaledBy(x: scale, y: scale)
            }
        }*/
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        pinchGR.scale = 1.0
    }
    
    func create(frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool) {
        if type == "RoundedMultiRect" {
            let v1 = ComponentView(frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
            let v1_1 = ComponentView(frame: CGRect(x: 3.0, y: 3.0, width: 100.0, height: 100.0),
                                     type: "RoundedMultiRect",
                                     bDraggable: false,
                                     bOrigin: true)
            v1.addSubview(v1_1)
            v1.delegate = self
            v1_1.delegate = self
            let tmp = generateComponentViewId()
            v1.id = tmp
            v1_1.id = tmp
            self.view.addSubview(v1)
            componentViewList.append(v1)
        } else {
            let v1 = ComponentView(frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
            v1.delegate = self
            v1.id = generateComponentViewId()
            if type == "Timer" {
                v1.drawSecondPath = true
                let txtField: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
                txtField.text = "Timer"
                txtField.adjustsFontSizeToFitWidth = true
                txtField.textAlignment = .center
                txtField.font = UIFont.boldSystemFont(ofSize: 10)
                v1.addSubview(txtField)
            }
            if type == "Clock" {
                v1.drawSecondPath = true
                let txtField: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
                txtField.text = "Clock"
                txtField.adjustsFontSizeToFitWidth = true
                txtField.textAlignment = .center
                txtField.font = UIFont.boldSystemFont(ofSize: 10)
                v1.addSubview(txtField)
            }
            if type == "Bus" {
                let txtFieldBus: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
                txtFieldBus.text = "Bus"
                txtFieldBus.adjustsFontSizeToFitWidth = true
                txtFieldBus.textAlignment = .center
                txtFieldBus.font = UIFont.boldSystemFont(ofSize: 10)
                v1.addSubview(txtFieldBus)
            }
            self.view.addSubview(v1)
            componentViewList.append(v1)
        }
    }
    
    func select(component: ComponentView) {
        if component.bSelected {
            if component.type == "RoundedMultiRect" {
                component.editPanel.frame = CGRect(x: (component.superview?.frame.maxX)! + 30,
                                                   y: (component.superview?.frame.minY)! - 50,
                                                   width: 210, height: 400)
                view.addSubview(component.editPanel)
                editPanelViewList.append(component.editPanel)
            } else {
                component.editPanel.frame = CGRect(x: component.frame.maxX + 30,
                                                   y: component.frame.minY - 50,
                                                   width: 210, height: 400)
                view.addSubview(component.editPanel)
                editPanelViewList.append(component.editPanel)
            }
            
            
            for cv in componentViewList {
                if cv != component {
                    cv.bSelected = false
                    cv.editPanel.removeFromSuperview()
                }
            }

        } else {
            component.editPanel.removeFromSuperview()
        }
    }
    
    func delete(component: ComponentView) {
        print("todo delete ComponentView with id \(component.id) from array ")
    }
    
    func merge(component: ComponentView) {
        
        let firstComponentView = component

            switch firstComponentView.type {
            case "Bus":
                for cv in componentViewList {
                    if( cv != firstComponentView && !cv.bOrigin ) {
                        
                        if (firstComponentView.frame.maxX - cv.frame.minX > -40 && firstComponentView.frame.maxX - cv.frame.minX < -20  ||
                            firstComponentView.frame.maxX - cv.frame.minX > 200 && firstComponentView.frame.maxX - cv.frame.minX < 240) &&
                            firstComponentView.frame.minY - cv.frame.minY > -20 && firstComponentView.frame.minY - cv.frame.minY < 20
                        {
                            if firstComponentView.frame.minX < cv.frame.minX {
                                if firstComponentView.intarface1Right != nil && cv.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && cv.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && cv.intarface3Left != nil
                                {
                                    
                                    cv.frame = CGRect(x: firstComponentView.frame.maxX + 35.0, y: firstComponentView.frame.minY - 2, width: 70, height: 100)
                                    firstComponentView.neighborRight = cv
                                    cv.neighborLeft = firstComponentView
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && cv.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && cv.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && cv.intarface3Right != nil
                                {
                                    firstComponentView.frame = CGRect(x: cv.frame.maxX + 35.0, y: cv.frame.minY - 2, width: 70, height: 100)
                                    firstComponentView.neighborLeft = cv
                                    cv.neighborRight = firstComponentView
                                }
                            }
                        }
                    }
                }
                break
            case "Timer":
                for cv in componentViewList {
                    if( cv != firstComponentView && !cv.bOrigin ) {
                        print("firstComponentView.type: \(firstComponentView.type)")
                        print("cv.type: \(cv.type)")
                        if (firstComponentView.frame.maxX - cv.frame.minX > -16 && firstComponentView.frame.maxX - cv.frame.minX < 16  ||
                            firstComponentView.frame.maxX - cv.frame.minX > 175 && firstComponentView.frame.maxX - cv.frame.minX < 188) &&
                            firstComponentView.frame.minY - cv.frame.minY > -10 && firstComponentView.frame.minY - cv.frame.minY < 40
                        {
                            if firstComponentView.frame.minX < cv.frame.minX {
                                if firstComponentView.intarface1Right != nil && cv.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && cv.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && cv.intarface3Left != nil
                                {
                                    if cv.type != "Timer" && cv.type != "Clock" {
                                        cv.frame = CGRect(x: firstComponentView.frame.maxX + 18, y: firstComponentView.frame.minY - 17 , width: 100, height: 100)
                                        firstComponentView.neighborRight = cv
                                        cv.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && cv.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && cv.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && cv.intarface3Right != nil
                                {
                                    if cv.type != "Timer" && cv.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: cv.frame.maxX + 18, y: cv.frame.minY + 13, width: 70, height: 90)
                                        firstComponentView.neighborLeft = cv
                                        cv.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        print("firstComponentView.frame.maxX - cv.frame.minX: \(firstComponentView.frame.maxX - cv.frame.minX)")
                        print("firstComponentView.frame.minY - cv.frame.minY: \(firstComponentView.frame.minY - cv.frame.minY)")
                        if (firstComponentView.frame.maxX - cv.frame.minX  > 60 && firstComponentView.frame.maxX  - cv.frame.minX < 110) &&
                           (firstComponentView.frame.minY - cv.frame.minY > -85 && firstComponentView.frame.minY - cv.frame.minY < -76  ||
                            firstComponentView.frame.minY - cv.frame.minY > 104 && firstComponentView.frame.minY - cv.frame.minY < 115)
                        {
                            if firstComponentView.frame.minY < cv.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && cv.intarface1Top != nil ||
                                    firstComponentView.intarface2Buttom != nil && cv.intarface2Top != nil ||
                                    firstComponentView.intarface3Buttom != nil && cv.intarface3Top != nil
                                {
                                    if cv.type != "Timer" && cv.type != "Clock" {
                                        cv.frame = CGRect(x: firstComponentView.frame.minX - 14, y: firstComponentView.frame.minY + 87 , width: 100, height: 100)
                                        firstComponentView.neighborButtom = cv
                                        cv.neighborTop = firstComponentView
                                    }
                                }
                                
                            } else {
                                if firstComponentView.intarface1Top != nil && cv.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && cv.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && cv.intarface3Buttom != nil
                                {
                                    if cv.type != "Timer" && cv.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: cv.frame.minX + 16, y: cv.frame.minY + 118, width: 70, height: 90)
                                        cv.neighborTop = firstComponentView
                                        firstComponentView.neighborButtom = cv
                                    }
                                }
                            }
                        }
                    }
                }
                break
            case "Clock":
                break
            default:
                for secondComponentView in componentViewList {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -40  &&
                            firstComponentView.frame.maxX - secondComponentView.frame.minX < -20  ||
                            firstComponentView.frame.maxX - secondComponentView.frame.minX > 200  &&
                            firstComponentView.frame.maxX - secondComponentView.frame.minX < 240) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -20  &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY < 20
                        {
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && secondComponentView.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && secondComponentView.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && secondComponentView.intarface3Left != nil
                                {
                                    
                                    secondComponentView.frame = CGRect(x: firstComponentView.frame.maxX + 35.0, y: firstComponentView.frame.minY - 2, width: 100, height: 100)
                                    firstComponentView.neighborRight = secondComponentView
                                    secondComponentView.neighborLeft = firstComponentView
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && secondComponentView.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && secondComponentView.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && secondComponentView.intarface3Right != nil
                                {
                                    firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 35.0, y: secondComponentView.frame.minY - 2, width: 100, height: 100)
                                    firstComponentView.neighborLeft = secondComponentView
                                    secondComponentView.neighborRight = firstComponentView
                                }
                            }
                        }
                        
                        if firstComponentView.frame.maxX - secondComponentView.frame.maxX > -20 && firstComponentView.frame.maxX - secondComponentView.frame.maxX < 10 &&
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > -230 && firstComponentView.frame.minY - secondComponentView.frame.maxY < -210 ||
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > 20 && firstComponentView.frame.minY - secondComponentView.frame.maxY < 40
                        {
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && secondComponentView.intarface1Top != nil ||
                                    firstComponentView.intarface2Buttom != nil && secondComponentView.intarface2Top != nil ||
                                    firstComponentView.intarface3Buttom != nil && secondComponentView.intarface3Top != nil
                                {
                                    secondComponentView.frame = CGRect(x: firstComponentView.frame.minX + 2, y: firstComponentView.frame.minY + 135, width: 100, height: 100)
                                    firstComponentView.neighborButtom = secondComponentView
                                    secondComponentView.neighborTop = firstComponentView
                                }
                                
                            } else {
                                if firstComponentView.intarface1Top != nil && secondComponentView.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && secondComponentView.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && secondComponentView.intarface3Buttom != nil
                                {
                                    firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 2, y: secondComponentView.frame.minY + 135, width: 100, height: 100)
                                    secondComponentView.neighborTop = firstComponentView
                                    firstComponentView.neighborButtom = secondComponentView
                                }
                            }
                        }
                    }
                }
                break
        }
    }
}



