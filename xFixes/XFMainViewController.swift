import UIKit

class XFMainViewController: UIViewController, ComponentViewDelegate, UIScrollViewDelegate {
    
    var componentViewList = [ComponentView]()
    var editPanelViewList = [EditPanel]()
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    var bounds = CGRect()
    var visibleRect = CGRect()
    
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
        imageView.image = UIImage(named:"background.jpg")
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
        
        let container = UIView(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: 120))
        container.backgroundColor = UIColor(hue: 210/360, saturation: 0/100, brightness: 95/100, alpha: 1.0)
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
        view.addSubview(v2)
        componentViewList.append(v2)
        
        
        let v3 = ComponentView(frame: CGRect(x: 450.0, y: 80, width: 100.0, height: 100.0),
                               type: "RoundedMultiRect",
                               bDraggable: true,
                               bOrigin: true)
        v3.delegate = self
        view.addSubview(v3)
        componentViewList.append(v3)
        
        let v4 = ComponentView(frame: CGRect(x: 600.0, y: 80, width: 70.0, height: 100.0),
                               type: "Bus",
                               bDraggable: true,
                               bOrigin: true)
        v4.delegate = self
        let txtFieldBus: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
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
    }
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        for editPanel in editPanelViewList {
            editPanel.removeFromSuperview()
        }
        
        for cv in componentViewList {
            cv.bSelected = false
        }
    }
    
    func create(component: ComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool) {
        let v1 = ComponentView(frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
        v1.delegate = self
        v1.bSelected = false
        self.view.addSubview(v1)
        
        visibleRect = imageView.convert(scrollView.bounds, from: scrollView);
        component.frame =  CGRect(x: component.frame.minX + visibleRect.minX,
                                  y: component.frame.minY + visibleRect.minY,
                                  width: component.frame.width,
                                  height: component.frame.height)
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
            component.frame = CGRect(x: component.frame.minX,
                                     y: component.frame.minY,
                                     width: component.frame.width,
                                     height: component.frame.height)
            let txtFieldBus: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
            txtFieldBus.adjustsFontSizeToFitWidth = true
            txtFieldBus.textAlignment = .center
            txtFieldBus.font = UIFont.boldSystemFont(ofSize: 10)
            v1.addSubview(txtFieldBus)
        }
    }
    
    func interface(component: ComponentView) {
        if ((component.intarface1Top?.type  == "---" || (component.intarface1Top == nil)) &&
            ( component.intarface2Top?.type  == "---" || (component.intarface2Top == nil)) &&
            ( component.intarface3Top?.type  == "---" || (component.intarface3Top == nil))) {
            if component.neighborTop != nil {
                component.neighborTop?.neighborButtom = nil
                component.neighborTop = nil
            }
        }
        
        if (component.intarface1Buttom?.type == "---" || (component.intarface1Buttom == nil) ) &&
            (component.intarface2Buttom?.type == "---" || (component.intarface2Buttom == nil)) &&
            (component.intarface3Buttom?.type == "---" || (component.intarface3Buttom == nil)) {
            if component.neighborButtom != nil {
                component.neighborButtom?.neighborTop = nil
                component.neighborButtom = nil
            }
        }
        
        if (component.intarface1Right?.type == "---" || (component.intarface1Right == nil) ) &&
            (component.intarface2Right?.type == "---" || (component.intarface2Right == nil)) &&
            (component.intarface3Right?.type == "---" || (component.intarface3Right == nil)) {
            if component.neighborRight != nil {
                component.neighborRight?.neighborLeft = nil
                component.neighborRight = nil
            }
        }
        
        if (component.intarface1Left?.type == "---" || (component.intarface1Left == nil) ) &&
            (component.intarface2Left?.type == "---" || (component.intarface2Left == nil)) &&
            (component.intarface3Left?.type == "---" || (component.intarface3Left == nil)) {
            if component.neighborLeft != nil {
                component.neighborLeft?.neighborRight = nil
                component.neighborLeft = nil
            }
        }
    }
    
    func select(component: ComponentView) {
        
        for v in editPanelViewList {
            v.removeFromSuperview()
        }
        
        visibleRect = imageView.convert(scrollView.bounds, from: scrollView)
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
    
    func delete(component: ComponentView) {
        component.removeFromSuperview()
        if component.neighborTop != nil {
            component.neighborTop?.neighborButtom = nil
            component.neighborTop = nil
        }
        if component.neighborButtom != nil {
            component.neighborButtom?.neighborTop = nil
            component.neighborButtom = nil
        }
        if component.neighborRight != nil {
            component.neighborRight?.neighborLeft = nil
            component.neighborRight = nil
        }
        if component.neighborLeft != nil {
            component.neighborLeft?.neighborRight = nil
            component.neighborLeft = nil
        }
    }
    
    var tmp_move = [ComponentView]()
    func trace_move(component: ComponentView!) {
        if component.neighborTop != nil && !tmp_move.contains(component.neighborTop!) && component.neighborTop != self {
            tmp_move.append(component.neighborTop!)
            trace_move(component: component.neighborTop!)
        }
        
        if component.neighborRight != nil && !tmp_move.contains(component.neighborRight!) && component.neighborRight != self {
            tmp_move.append(component.neighborRight!)
            trace_move(component: component.neighborRight!)
        }
        
        if component.neighborButtom != nil && !tmp_move.contains(component.neighborButtom!) && component.neighborButtom != self {
            tmp_move.append(component.neighborButtom!)
            trace_move(component: component.neighborButtom!)
        }
        
        if component.neighborLeft != nil && !tmp_move.contains(component.neighborLeft!) && component.neighborLeft != self {
            tmp_move.append(component.neighborLeft!)
            trace_move(component: component.neighborLeft!)
        }
    }
    
    func merge(component: ComponentView) {
        
        let firstComponentView = component
        let firstComponentView_intarface1Top_convert    = firstComponentView.intarface1Top?.convert((firstComponentView.intarface1Top?.bounds)!, to: self.view)
        let firstComponentView_intarface2Top_convert    = firstComponentView.intarface2Top?.convert((firstComponentView.intarface2Top?.bounds)!, to: self.view)
        let firstComponentView_intarface3Top_convert    = firstComponentView.intarface3Top?.convert((firstComponentView.intarface3Top?.bounds)!, to: self.view)
        let firstComponentView_intarface1Buttom_convert = firstComponentView.intarface1Buttom?.convert((firstComponentView.intarface1Buttom?.bounds)!, to: self.view)
        let firstComponentView_intarface2Buttom_convert = firstComponentView.intarface2Buttom?.convert((firstComponentView.intarface2Buttom?.bounds)!, to: self.view)
        let firstComponentView_intarface3Buttom_convert = firstComponentView.intarface3Buttom?.convert((firstComponentView.intarface3Buttom?.bounds)!, to: self.view)
        let firstComponentView_intarface1Right_convert  = firstComponentView.intarface1Right?.convert((firstComponentView.intarface1Right?.bounds)!, to: self.view)
        let firstComponentView_intarface2Right_convert  = firstComponentView.intarface2Right?.convert((firstComponentView.intarface2Right?.bounds)!, to: self.view)
        let firstComponentView_intarface3Right_convert  = firstComponentView.intarface3Right?.convert((firstComponentView.intarface3Right?.bounds)!, to: self.view)
        let firstComponentView_intarface1Left_convert   = firstComponentView.intarface1Left?.convert((firstComponentView.intarface1Left?.bounds)!, to: self.view)
        let firstComponentView_intarface2Left_convert   = firstComponentView.intarface2Left?.convert((firstComponentView.intarface2Left?.bounds)!, to: self.view)
        let firstComponentView_intarface3Left_convert   = firstComponentView.intarface3Left?.convert((firstComponentView.intarface3Left?.bounds)!, to: self.view)
        
        tmp_move.removeAll()
        trace_move(component: firstComponentView)
        
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
        case "Clock":
            for secondComponentView in componentViewList {
                let secondComponentView_intarface2Top_convert    = secondComponentView.intarface2Top?.convert((secondComponentView.intarface2Top?.bounds)!, to: self.view)
                let secondComponentView_intarface2Buttom_convert = secondComponentView.intarface2Buttom?.convert((secondComponentView.intarface2Buttom?.bounds)!, to: self.view)
                let secondComponentView_intarface2Right_convert  = secondComponentView.intarface2Right?.convert((secondComponentView.intarface2Right?.bounds)!, to: self.view)
                let secondComponentView_intarface2Left_convert   = secondComponentView.intarface2Left?.convert((secondComponentView.intarface2Left?.bounds)!, to: self.view)
                
                if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Top_convert != nil {}
                if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {}
                if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Right_convert != nil {}
                if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Left_convert != nil {}
                
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
                                    firstComponentView.neighborTop = secondComponentView
                                    secondComponentView.neighborButtom = firstComponentView
                                }
                            }
                        }
                    }
                }
            }
        default:
            for secondComponentView in componentViewList {
                if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                    let secondComponentView_intarface1Top_convert    = secondComponentView.intarface1Top?.convert((secondComponentView.intarface1Top?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Top_convert    = secondComponentView.intarface2Top?.convert((secondComponentView.intarface2Top?.bounds)!, to: self.view)
                    let secondComponentView_intarface3Top_convert    = secondComponentView.intarface3Top?.convert((secondComponentView.intarface3Top?.bounds)!, to: self.view)
                    let secondComponentView_intarface1Buttom_convert = secondComponentView.intarface1Buttom?.convert((secondComponentView.intarface1Buttom?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Buttom_convert = secondComponentView.intarface2Buttom?.convert((secondComponentView.intarface2Buttom?.bounds)!, to: self.view)
                    let secondComponentView_intarface3Buttom_convert = secondComponentView.intarface3Buttom?.convert((secondComponentView.intarface3Buttom?.bounds)!, to: self.view)
                    let secondComponentView_intarface1Right_convert  = secondComponentView.intarface1Right?.convert((secondComponentView.intarface1Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Right_convert  = secondComponentView.intarface2Right?.convert((secondComponentView.intarface2Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface3Right_convert  = secondComponentView.intarface3Right?.convert((secondComponentView.intarface3Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface1Left_convert   = secondComponentView.intarface1Left?.convert((secondComponentView.intarface1Left?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Left_convert   = secondComponentView.intarface2Left?.convert((secondComponentView.intarface2Left?.bounds)!, to: self.view)
                    let secondComponentView_intarface3Left_convert   = secondComponentView.intarface3Left?.convert((secondComponentView.intarface3Left?.bounds)!, to: self.view)
                    
                    if firstComponentView_intarface1Top_convert != nil && secondComponentView_intarface1Buttom_convert != nil {
                        if (firstComponentView_intarface1Top_convert?.intersects(secondComponentView_intarface1Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface1Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 15,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Top_convert != nil && secondComponentView_intarface3Buttom_convert != nil {
                        if (firstComponentView_intarface1Top_convert?.intersects(secondComponentView_intarface3Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX - 28,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface1Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface1Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 35,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface3Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface3Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 13,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Top_convert != nil && secondComponentView_intarface1Buttom_convert != nil {
                        if (firstComponentView_intarface3Top_convert?.intersects(secondComponentView_intarface1Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 72,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface3Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 37,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Top_convert != nil && secondComponentView_intarface3Buttom_convert != nil {
                        if (firstComponentView_intarface3Top_convert?.intersects(secondComponentView_intarface3Buttom_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop = secondComponentView
                                secondComponentView.neighborButtom = firstComponentView
                            }
                        }
                    }
                    
                    //
                    if firstComponentView_intarface1Buttom_convert != nil && secondComponentView_intarface1Top_convert != nil {
                        if (firstComponentView_intarface1Buttom_convert?.intersects(secondComponentView_intarface1Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface1Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 15,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Buttom_convert != nil && secondComponentView_intarface3Top_convert != nil {
                        if (firstComponentView_intarface1Buttom_convert?.intersects(secondComponentView_intarface3Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX - 28,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface1Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface1Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 35,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface3Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface3Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 13,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Buttom_convert != nil && secondComponentView_intarface1Top_convert != nil {
                        if (firstComponentView_intarface3Buttom_convert?.intersects(secondComponentView_intarface1Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 72,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface3Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 37,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Buttom_convert != nil && secondComponentView_intarface3Top_convert != nil {
                        if (firstComponentView_intarface3Buttom_convert?.intersects(secondComponentView_intarface3Top_convert!))! {
                            if firstComponentView.neighborTop == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom = secondComponentView
                                secondComponentView.neighborTop = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY + 38,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY + 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY - 37,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY + 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY - 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY - 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight = secondComponentView
                                secondComponentView.neighborLeft = firstComponentView
                            }
                        }
                    }
                    
                    
                    if firstComponentView_intarface1Left_convert != nil && secondComponentView_intarface1Right_convert != nil {
                        if (firstComponentView_intarface1Left_convert?.intersects(secondComponentView_intarface1Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface1Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY + 37,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Left_convert != nil && secondComponentView_intarface3Right_convert != nil {
                        if (firstComponentView_intarface1Left_convert?.intersects(secondComponentView_intarface3Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY + 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface1Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface1Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY - 37,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface3Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface3Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY + 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Left_convert != nil && secondComponentView_intarface1Right_convert != nil {
                        if (firstComponentView_intarface3Left_convert?.intersects(secondComponentView_intarface1Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY - 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface3Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY - 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Left_convert != nil && secondComponentView_intarface3Right_convert != nil {
                        if (firstComponentView_intarface3Left_convert?.intersects(secondComponentView_intarface3Right_convert!))! {
                            if firstComponentView.neighborLeft == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft = secondComponentView
                                secondComponentView.neighborRight = firstComponentView
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
}



