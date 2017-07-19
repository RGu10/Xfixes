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

let scrollView = UIScrollView()
let imageView = UIImageView()
var bounds = CGRect()
var visibleRect = CGRect()

class ViewController: UIViewController, ComponentViewDelegate, UIScrollViewDelegate {
    var componentViewList = [ComponentView]()
    var editPanelViewList = [EditPanel]()

    
    @IBAction func resetZoomButton(_ sender: UIBarButtonItem) {
        scrollView.zoomScale = 1.0
    }
    
    @IBAction func RemovAllButton(_ sender: UIBarButtonItem) {
        
        for v in componentViewList {
            if v.bOrigin == false {
                v.removeFromSuperview()
            }
        }
        for v in editPanelViewList {
            v.removeFromSuperview()
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bounds = UIScreen.main.bounds
        imageView.image = UIImage(named:"backgroundGray.jpg")
        imageView.frame = CGRect(x: 0, y: 0, width: (bounds.size.width * 2), height: (bounds.size.height * 2))
        imageView.isUserInteractionEnabled = true
        imageView.tag = Int(1)
        scrollView.frame = view.bounds
        scrollView.contentSize = imageView.bounds.size
        scrollView.addSubview(imageView)
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 1.3
        scrollView.bouncesZoom = false
        view.addSubview(scrollView)
        
        let container = UIView(frame: CGRect(x: 120, y: 70, width: (view.bounds.width - 255), height: 120))
        container.backgroundColor = UIColor(hue: 210/360, saturation: 0/100, brightness: 97/100, alpha: 1.0)
        view.addSubview(container)
        
        initGestureRecognizers()

        let v1 = ComponentView(frame: CGRect(x: 150.0, y: 80, width: 100.0, height: 100.0),
                               type: "Rect",
                               bDraggable: true,
                               bOrigin: true)
        v1.delegate = self
        v1.bSelected = false
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
        componentViewList.append(v6)
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
        /*let scale = pinchGR.scale
        for comp in imageView.subviews {
            if comp.tag != 1 {
                comp.transform = comp.transform.scaledBy(x: scale, y: scale)
            }
        }
        pinchGR.scale = 1.0*/
    }
    
    func create(component: ComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool) {
        if type == "RoundedMultiRect" {
            let v1 = ComponentView(frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
            let v1_1 = ComponentView(frame: CGRect(x: 3.0, y: 3.0, width: 100.0, height: 100.0),
                                     type: "RoundedMultiRect",
                                     bDraggable: false,
                                     bOrigin: true)
            v1.addSubview(v1_1)
            v1.delegate = self
            v1_1.delegate = self
            v1.id = generateComponentViewId()
            v1_1.id = generateComponentViewId()
            self.view.addSubview(v1)
            visibleRect = imageView.convert(scrollView.bounds, from: scrollView)
            component.frame =  CGRect(x: component.frame.minX + visibleRect.minX, y: component.frame.minY + visibleRect.minY,
                                      width: component.frame.width, height: component.frame.height)
            imageView.addSubview(component)
            componentViewList.append(v1)
        } else {
            let v1 = ComponentView(frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
            v1.delegate = self
            v1.bSelected = false
            self.view.addSubview(v1)
            
            visibleRect = imageView.convert(scrollView.bounds, from: scrollView);
            component.frame =  CGRect(x: component.frame.minX + visibleRect.minX, y: component.frame.minY + visibleRect.minY,
                                      width: component.frame.width, height: component.frame.height)
            imageView.addSubview(component)
            componentViewList.append(v1)
            
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
        }
    }
    
    func select(component: ComponentView) {

        for v in editPanelViewList {
            v.removeFromSuperview()
        }
    
        visibleRect = imageView.convert(scrollView.bounds, from: scrollView)
        if component.type == "RoundedMultiRect" {
            if ( ((component.superview?.frame.minY)! - visibleRect.minY) < 400 && ( visibleRect.maxY - (component.superview?.frame.minY)! > 400) ){
                if ((visibleRect.maxX - (component.superview?.frame.maxX)!) < 210 ){
                    component.editPanel.frame = CGRect(x: (component.superview?.frame.minX)! - 210,
                                                       y: (component.superview?.frame.minY)!,
                                                       width: 210, height: 400)
                } else {
                    component.editPanel.frame = CGRect(x: (component.superview?.frame.maxX)!,
                                                       y: (component.superview?.frame.minY)!,
                                                       width: 210, height: 400)
                }
                
            } else if ( visibleRect.maxY - (component.superview?.frame.minY)! < 400 && ((component.superview?.frame.maxY)! - visibleRect.minY > 600)) {
                
                if ((visibleRect.maxX - (component.superview?.frame.maxX)!) < 210 ){
                    component.editPanel.frame = CGRect(x: (component.superview?.frame.minX)! - 210,
                                                       y: (component.superview?.frame.maxY)! - 400,
                                                       width: 210, height: 400)
                } else {
                    component.editPanel.frame = CGRect(x: (component.superview?.frame.maxX)!,
                                                       y: (component.superview?.frame.maxY)! - 400,
                                                       width: 210, height: 400)
                }
                
                
            } else {
                
                if ((visibleRect.maxX - (component.superview?.frame.maxX)!) < 210 ){
                    component.editPanel.frame = CGRect(x: (component.superview?.frame.minX)! - 210,
                                                       y: (component.superview?.frame.maxY)! - 250,
                                                       width: 210, height: 400)
                } else {
                    component.editPanel.frame = CGRect(x: (component.superview?.frame.maxX)!,
                                                       y: (component.superview?.frame.maxY)! - 250,
                                                       width: 210, height: 400)
                }
            }
            
            imageView.addSubview(component.editPanel)
            editPanelViewList.append(component.editPanel)
        } else {
            if ( (component.frame.minY - visibleRect.minY) < 400 && ( visibleRect.maxY - component.frame.minY > 400) ){
                if ((visibleRect.maxX - component.frame.maxX) < 210 ){
                    component.editPanel.frame = CGRect(x: component.frame.minX - 210,
                                                       y: component.frame.minY,
                                                       width: 210, height: 400)
                } else {
                    component.editPanel.frame = CGRect(x: component.frame.maxX,
                                                       y: component.frame.minY,
                                                       width: 210, height: 400)
                }
                
            } else if ( visibleRect.maxY - component.frame.minY < 400 && (component.frame.maxY - visibleRect.minY > 600)) {
                
                if ((visibleRect.maxX - component.frame.maxX) < 210 ){
                    component.editPanel.frame = CGRect(x: component.frame.minX - 210,
                                                       y: component.frame.maxY - 400,
                                                       width: 210, height: 400)
                } else {
                    component.editPanel.frame = CGRect(x: component.frame.maxX,
                                                       y: component.frame.maxY - 400,
                                                       width: 210, height: 400)
                }
                
                
            } else {
                
                if ((visibleRect.maxX - component.frame.maxX) < 210 ){
                    component.editPanel.frame = CGRect(x: component.frame.minX - 210,
                                                       y: component.frame.maxY - 250,
                                                       width: 210, height: 400)
                } else {
                    component.editPanel.frame = CGRect(x: component.frame.maxX,
                                                       y: component.frame.maxY - 250,
                                                       width: 210, height: 400)
                }
            }
            
            imageView.addSubview(component.editPanel)
            editPanelViewList.append(component.editPanel)
        }
    }
    
    func delete(component: ComponentView) {}
    
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
        case "Timer":
            for secondComponentView in componentViewList {
                if secondComponentView.type == "RoundedMultiRect" {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -16 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 16  ||
                            firstComponentView.frame.maxX - secondComponentView.frame.minX > 175 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 188) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -10 && firstComponentView.frame.minY - secondComponentView.frame.minY < 40
                        {
                            let sc2 = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && sc2?.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && sc2?.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && sc2?.intarface3Left != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 84, y: secondComponentView.frame.minY + 20 , width: 70, height: 90)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && sc2?.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && sc2?.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && sc2?.intarface3Right != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 20, y: secondComponentView.frame.minY + 16, width: 70, height: 90)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX  > 60 && firstComponentView.frame.maxX  - secondComponentView.frame.minX < 110) &&
                            (firstComponentView.frame.minY - secondComponentView.frame.minY > -85 && firstComponentView.frame.minY - secondComponentView.frame.minY < -76  ||
                                firstComponentView.frame.minY - secondComponentView.frame.minY > 104 && firstComponentView.frame.minY - secondComponentView.frame.minY < 115)
                        {
                            let sc2 = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && sc2?.intarface1Top != nil ||
                                    firstComponentView.intarface2Buttom != nil && sc2?.intarface2Top != nil ||
                                    firstComponentView.intarface3Buttom != nil && sc2?.intarface3Top != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 17, y: secondComponentView.frame.minY - 82 , width: 70, height: 90)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Top != nil && sc2?.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && sc2?.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && sc2?.intarface3Buttom != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 19, y: secondComponentView.frame.minY + 120, width: 70, height: 90)
                                        secondComponentView.neighborTop = firstComponentView
                                        firstComponentView.neighborButtom = secondComponentView
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -16 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 16  ||
                            firstComponentView.frame.maxX - secondComponentView.frame.minX > 175 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 188) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -10 && firstComponentView.frame.minY - secondComponentView.frame.minY < 40
                        {
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && secondComponentView.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && secondComponentView.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && secondComponentView.intarface3Left != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 88, y: secondComponentView.frame.minY + 17 , width: 70, height: 90)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && secondComponentView.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && secondComponentView.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && secondComponentView.intarface3Right != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 18, y: secondComponentView.frame.minY + 13, width: 70, height: 90)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX  > 60 && firstComponentView.frame.maxX  - secondComponentView.frame.minX < 110) &&
                            (firstComponentView.frame.minY - secondComponentView.frame.minY > -85 && firstComponentView.frame.minY - secondComponentView.frame.minY < -76  ||
                                firstComponentView.frame.minY - secondComponentView.frame.minY > 104 && firstComponentView.frame.minY - secondComponentView.frame.minY < 115)
                        {
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && secondComponentView.intarface1Top != nil ||
                                    firstComponentView.intarface2Buttom != nil && secondComponentView.intarface2Top != nil ||
                                    firstComponentView.intarface3Buttom != nil && secondComponentView.intarface3Top != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 14, y: secondComponentView.frame.minY - 87 , width: 70, height: 90)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Top != nil && secondComponentView.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && secondComponentView.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && secondComponentView.intarface3Buttom != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 16, y: secondComponentView.frame.minY + 118, width: 70, height: 90)
                                        secondComponentView.neighborTop = firstComponentView
                                        firstComponentView.neighborButtom = secondComponentView
                                    }
                                }
                            }
                        }
                    }
                }
            }
        case "Clock":
            for secondComponentView in componentViewList {
                if secondComponentView.type == "RoundedMultiRect" {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -16 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 16  ||
                            firstComponentView.frame.maxX - secondComponentView.frame.minX > 175 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 188) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -10 && firstComponentView.frame.minY - secondComponentView.frame.minY < 40
                        {
                            let sc2 = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && sc2?.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && sc2?.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && sc2?.intarface3Left != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 84, y: secondComponentView.frame.minY + 20 , width: 70, height: 90)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && sc2?.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && sc2?.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && sc2?.intarface3Right != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 20, y: secondComponentView.frame.minY + 16, width: 70, height: 90)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX  > 60 && firstComponentView.frame.maxX  - secondComponentView.frame.minX < 110) &&
                            (firstComponentView.frame.minY - secondComponentView.frame.minY > -85 && firstComponentView.frame.minY - secondComponentView.frame.minY < -76  ||
                                firstComponentView.frame.minY - secondComponentView.frame.minY > 104 && firstComponentView.frame.minY - secondComponentView.frame.minY < 115)
                        {
                            let sc2 = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && sc2?.intarface1Top != nil ||
                                    firstComponentView.intarface2Buttom != nil && sc2?.intarface2Top != nil ||
                                    firstComponentView.intarface3Buttom != nil && sc2?.intarface3Top != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 17, y: secondComponentView.frame.minY - 82 , width: 70, height: 90)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Top != nil && sc2?.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && sc2?.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && sc2?.intarface3Buttom != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 19, y: secondComponentView.frame.minY + 120, width: 70, height: 90)
                                        secondComponentView.neighborTop = firstComponentView
                                        firstComponentView.neighborButtom = secondComponentView
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -16 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 16  ||
                            firstComponentView.frame.maxX - secondComponentView.frame.minX > 175 && firstComponentView.frame.maxX - secondComponentView.frame.minX < 188) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -10 && firstComponentView.frame.minY - secondComponentView.frame.minY < 40
                        {
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && secondComponentView.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && secondComponentView.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && secondComponentView.intarface3Left != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 88, y: secondComponentView.frame.minY + 17 , width: 70, height: 90)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && secondComponentView.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && secondComponentView.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && secondComponentView.intarface3Right != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 18, y: secondComponentView.frame.minY + 13, width: 70, height: 90)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX  > 60 && firstComponentView.frame.maxX  - secondComponentView.frame.minX < 110) &&
                            (firstComponentView.frame.minY - secondComponentView.frame.minY > -85 && firstComponentView.frame.minY - secondComponentView.frame.minY < -76  ||
                                firstComponentView.frame.minY - secondComponentView.frame.minY > 104 && firstComponentView.frame.minY - secondComponentView.frame.minY < 115)
                        {
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && secondComponentView.intarface1Top != nil ||
                                    firstComponentView.intarface2Buttom != nil && secondComponentView.intarface2Top != nil ||
                                    firstComponentView.intarface3Buttom != nil && secondComponentView.intarface3Top != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 14, y: secondComponentView.frame.minY - 87 , width: 70, height: 90)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Top != nil && secondComponentView.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && secondComponentView.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && secondComponentView.intarface3Buttom != nil
                                {
                                    if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 16, y: secondComponentView.frame.minY + 118, width: 70, height: 90)
                                        secondComponentView.neighborTop = firstComponentView
                                        firstComponentView.neighborButtom = secondComponentView
                                    }
                                }
                            }
                        }
                    }
                }
            }
        case "RoundedMultiRect":
            for secondComponentView in componentViewList {
                if secondComponentView.type == "RoundedMultiRect" {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -40  && firstComponentView.frame.maxX - secondComponentView.frame.minX < -20
                            || firstComponentView.frame.maxX - secondComponentView.frame.minX > 200  &&
                            firstComponentView.frame.maxX - secondComponentView.frame.minX < 240) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -20  &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY < 20
                        {
                            let sc1 = firstComponentView.subviews[0] as? ComponentView
                            let sc2 = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if sc1?.intarface1Right != nil && sc2?.intarface1Left != nil ||
                                   sc1?.intarface2Right != nil && sc2?.intarface2Left != nil ||
                                   sc1?.intarface3Right != nil && sc2?.intarface3Left != nil
                                {
                                    if sc1?.neighborRight == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 135, y: secondComponentView.frame.minY + 3, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if sc1?.intarface1Left != nil && sc2?.intarface1Right != nil ||
                                   sc1?.intarface2Left != nil && sc2?.intarface2Right != nil ||
                                   sc1?.intarface3Left != nil && sc2?.intarface3Right != nil
                                {
                                    if sc1?.neighborLeft == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 135, y: secondComponentView.frame.minY - 2, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if firstComponentView.frame.maxX - secondComponentView.frame.maxX > -20 && firstComponentView.frame.maxX - secondComponentView.frame.maxX < 10 &&
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > -230 && firstComponentView.frame.minY - secondComponentView.frame.maxY < -210 ||
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > 20 && firstComponentView.frame.minY - secondComponentView.frame.maxY < 40
                        {
                            let sc1 = firstComponentView.subviews[0] as? ComponentView
                            let sc2 = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if sc1?.intarface1Buttom != nil && sc2?.intarface1Top != nil ||
                                    sc1?.intarface2Buttom != nil && sc2?.intarface2Top != nil ||
                                    sc1?.intarface3Buttom != nil && sc2?.intarface3Top != nil
                                {
                                    if sc1?.neighborButtom == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 2, y: secondComponentView.frame.minY - 134, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                            } else {
                                if sc1?.intarface1Top != nil && sc2?.intarface1Buttom != nil ||
                                    sc1?.intarface2Top != nil && sc2?.intarface2Buttom != nil ||
                                    sc1?.intarface3Top != nil && sc2?.intarface3Buttom != nil
                                {
                                    if sc1?.neighborTop == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 2, y: secondComponentView.frame.minY + 136, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborTop = secondComponentView
                                        secondComponentView.neighborButtom = firstComponentView
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -40  && firstComponentView.frame.maxX - secondComponentView.frame.minX < -20
                            || firstComponentView.frame.maxX - secondComponentView.frame.minX > 200  &&
                            firstComponentView.frame.maxX - secondComponentView.frame.minX < 240) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -20  &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY < 20
                        {
                            let fc = firstComponentView.subviews[0] as? ComponentView
                            if (fc?.superview?.frame.minX)! < secondComponentView.frame.minX {
                                if fc?.intarface1Right != nil && secondComponentView.intarface1Left != nil ||
                                    fc?.intarface2Right != nil && secondComponentView.intarface2Left != nil ||
                                    fc?.intarface3Right != nil && secondComponentView.intarface3Left != nil
                                {
                                    if fc?.neighborRight == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 137, y: secondComponentView.frame.minY + 0, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = fc
                                    }
                                }
                            } else {
                                if fc?.intarface1Left != nil && secondComponentView.intarface1Right != nil ||
                                    fc?.intarface2Left != nil && secondComponentView.intarface2Right != nil ||
                                    fc?.intarface3Left != nil && secondComponentView.intarface3Right != nil
                                {
                                    if fc?.neighborLeft == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 133, y: secondComponentView.frame.minY - 6, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if firstComponentView.frame.maxX - secondComponentView.frame.maxX > -20 && firstComponentView.frame.maxX - secondComponentView.frame.maxX < 10 &&
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > -230 && firstComponentView.frame.minY - secondComponentView.frame.maxY < -210 ||
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > 20 && firstComponentView.frame.minY - secondComponentView.frame.maxY < 40
                        {
                            let fc = firstComponentView.subviews[0] as? ComponentView
                            if (fc?.superview?.frame.minY)! < secondComponentView.frame.minY {
                                if fc?.intarface1Buttom != nil && secondComponentView.intarface1Top != nil ||
                                    fc?.intarface2Buttom != nil && secondComponentView.intarface2Top != nil ||
                                    fc?.intarface3Buttom != nil && secondComponentView.intarface3Top != nil
                                {
                                    if fc?.neighborButtom == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 5, y: secondComponentView.frame.minY - 138, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                                
                            } else {
                                if fc?.intarface1Top != nil && secondComponentView.intarface1Buttom != nil ||
                                    fc?.intarface2Top != nil && secondComponentView.intarface2Buttom != nil ||
                                    fc?.intarface3Top != nil && secondComponentView.intarface3Buttom != nil
                                {
                                    if fc?.neighborTop == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 1, y: secondComponentView.frame.minY + 133, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborTop = secondComponentView
                                        secondComponentView.neighborButtom = firstComponentView
                                    }
                                }
                            }
                        }
                    }
                }
            }
        default:
            for secondComponentView in componentViewList {
                if secondComponentView.type == "RoundedMultiRect" {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -40  && firstComponentView.frame.maxX - secondComponentView.frame.minX < -20
                            || firstComponentView.frame.maxX - secondComponentView.frame.minX > 200  &&
                            firstComponentView.frame.maxX - secondComponentView.frame.minX < 240) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -20  &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY < 20
                        {
                            let sc = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && sc?.intarface1Left != nil ||
                                   firstComponentView.intarface2Right != nil && sc?.intarface2Left != nil ||
                                   firstComponentView.intarface3Right != nil && sc?.intarface3Left != nil
                                {
                                    if firstComponentView.neighborRight == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 133, y: secondComponentView.frame.minY + 5, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && sc?.intarface1Right != nil ||
                                   firstComponentView.intarface2Left != nil && sc?.intarface2Right != nil ||
                                   firstComponentView.intarface3Left != nil && sc?.intarface3Right != nil
                                {
                                    if firstComponentView.neighborLeft == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 137, y: secondComponentView.frame.minY - 0, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
                                }
                            }
                        }
                        
                        if firstComponentView.frame.maxX - secondComponentView.frame.maxX > -20 && firstComponentView.frame.maxX - secondComponentView.frame.maxX < 10 &&
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > -230 && firstComponentView.frame.minY - secondComponentView.frame.maxY < -210 ||
                            firstComponentView.frame.minY - secondComponentView.frame.maxY > 20 && firstComponentView.frame.minY - secondComponentView.frame.maxY < 40
                        {
                            let sc = secondComponentView.subviews[0] as? ComponentView
                            if firstComponentView.frame.minY < secondComponentView.frame.minY {
                                if firstComponentView.intarface1Buttom != nil && sc?.intarface1Top != nil ||
                                   firstComponentView.intarface2Buttom != nil && sc?.intarface2Top != nil ||
                                   firstComponentView.intarface3Buttom != nil && sc?.intarface3Top != nil
                                {
                                    if firstComponentView.neighborButtom == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 1, y: secondComponentView.frame.minY - 132, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                            } else {
                                let sc = secondComponentView.subviews[0] as? ComponentView
                                if firstComponentView.intarface1Top != nil && sc?.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && sc?.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && sc?.intarface3Buttom != nil
                                {
                                    if firstComponentView.neighborTop == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 6, y: secondComponentView.frame.minY + 138, width: 100, height: 100)
                                        //secondComponentView.addSubview(firstComponentView)
                                        firstComponentView.neighborTop = secondComponentView
                                        secondComponentView.neighborButtom = firstComponentView
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                        if (firstComponentView.frame.maxX - secondComponentView.frame.minX > -40  && firstComponentView.frame.maxX - secondComponentView.frame.minX < -20
                            || firstComponentView.frame.maxX - secondComponentView.frame.minX > 200  &&
                            firstComponentView.frame.maxX - secondComponentView.frame.minX < 240) &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY > -20  &&
                            firstComponentView.frame.minY - secondComponentView.frame.minY < 20
                        {
                            if firstComponentView.frame.minX < secondComponentView.frame.minX {
                                if firstComponentView.intarface1Right != nil && secondComponentView.intarface1Left != nil ||
                                    firstComponentView.intarface2Right != nil && secondComponentView.intarface2Left != nil ||
                                    firstComponentView.intarface3Right != nil && secondComponentView.intarface3Left != nil
                                {
                                    if firstComponentView.neighborRight == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 135, y: secondComponentView.frame.minY + 3, width: 100, height: 100)
                                        firstComponentView.neighborRight = secondComponentView
                                        secondComponentView.neighborLeft = firstComponentView
                                    }
                                }
                            } else {
                                if firstComponentView.intarface1Left != nil && secondComponentView.intarface1Right != nil ||
                                    firstComponentView.intarface2Left != nil && secondComponentView.intarface2Right != nil ||
                                    firstComponentView.intarface3Left != nil && secondComponentView.intarface3Right != nil
                                {
                                    if firstComponentView.neighborLeft == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 135, y: secondComponentView.frame.minY - 2, width: 100, height: 100)
                                        firstComponentView.neighborLeft = secondComponentView
                                        secondComponentView.neighborRight = firstComponentView
                                    }
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
                                    if firstComponentView.neighborButtom == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 2, y: secondComponentView.frame.minY - 135, width: 100, height: 100)
                                        firstComponentView.neighborButtom = secondComponentView
                                        secondComponentView.neighborTop = firstComponentView
                                    }
                                }
                                
                            } else {
                                if firstComponentView.intarface1Top != nil && secondComponentView.intarface1Buttom != nil ||
                                    firstComponentView.intarface2Top != nil && secondComponentView.intarface2Buttom != nil ||
                                    firstComponentView.intarface3Top != nil && secondComponentView.intarface3Buttom != nil
                                {
                                    if firstComponentView.neighborTop == nil {
                                        firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 2, y: secondComponentView.frame.minY + 135, width: 100, height: 100)
                                        firstComponentView.neighborTop = secondComponentView
                                        secondComponentView.neighborButtom = firstComponentView
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}



