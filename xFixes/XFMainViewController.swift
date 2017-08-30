import UIKit
import CoreData

class XFModell{
	private var componentViewList = [XFComponentView]()
	
	func add(componentView: XFComponentView) {
		componentViewList.append(componentView)
	}
	
	func GetComponentViewList() -> [XFComponentView] {
		return componentViewList
	}
	
	
}

class XFMainViewController: UIViewController, ComponentViewDelegate, UIScrollViewDelegate {
	
	var modell = XFModell()
    var editPanelViewList = [XFEditPanel]()
	var dataBaseManager = XFDataBaseManager(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    var bounds = CGRect()
    var visibleRect = CGRect()
	
	func generateViewId() -> UInt32 {
		let lower : UInt32 = 1
		let upper : UInt32 = 10000
		let randomNumber = arc4random_uniform(upper - lower) + lower
		return randomNumber
	}

    @IBAction func resetZoomButton(_ sender: UIBarButtonItem) {
        scrollView.zoomScale = 1.0
    }
    
    @IBAction func RemovAllButton(_ sender: UIBarButtonItem) {
        for v in modell.GetComponentViewList() {
            if v.bOrigin == false {
                v.removeFromSuperview()
            }
        }
        for v in editPanelViewList {
            v.removeFromSuperview()
        }
		dataBaseManager.resetDatabase()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
	
    func loadCompoenentViewsFromDatabaseAndUpdateUI(){
		do {
			let tmpList = (try dataBaseManager.managedContext?.fetch(dataBaseManager.fetchRequest!))!
		for v in tmpList {
			let v1 = XFComponentView(frame: CGRect(x: CGFloat(v.minX), y: CGFloat(v.minY), width: CGFloat(v.width), height: CGFloat(v.height)),
			                         type: v.type!,
			                         bDraggable: true,
			                         bOrigin: false)
			v1.tag = Int(v.tag)
			v1.title.text = v.title
			v1.setTitle.text = v.title
			v1.setTitleAction()
			//v1.fillColor = v.color as! UIColor
			switch (v.color as! UIColor) {
				case UIColor.white:
					v1.setWhiteColorButtonAction()
				case UIColor.gray:
					v1.setGrayColorButtonAction()
				case UIColor.orange:
					v1.setOrangeColorButtonAction()
				case UIColor.green:
					v1.setGreenColorButtonAction()
				case UIColor.blue:
					v1.setBlueColorButtonAction()
				case UIColor.red:
					v1.setRedColorButtonAction()
				case UIColor.yellow:
					v1.setYellowColorButtonAction()
				case UIColor.cyan:
					v1.setCyanColorButtonAction()
				default:
					break
			}
			v1.delegate = self
			v1.bSelected = false
			modell.add(componentView: v1)
			imageView.addSubview(v1)
		}
		} catch let error as NSError {
				print("Could not fetch. \(error), \(error.userInfo)")
		}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		initGestureRecognizers()
        loadCompoenentViewsFromDatabaseAndUpdateUI()

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

        let v1 = XFComponentView(frame: CGRect(x: 150.0, y: 80, width: 100.0, height: 100.0),
                               type: "Rect",
                               bDraggable: true,
                               bOrigin: true)
        v1.delegate = self
        v1.bSelected = false
        view.addSubview(v1)
        modell.add(componentView: v1)
        
        let v2 = XFComponentView(frame: CGRect(x: 300.0, y: 80, width: 100.0, height: 100.0),
                               type: "RoundedRect",
                               bDraggable: true,
                               bOrigin: true)
        v2.delegate = self
		v2.bSelected = false
        view.addSubview(v2)
        modell.add(componentView: v2)
        
        let v3 = XFComponentView(frame: CGRect(x: 450.0, y: 80, width: 100.0, height: 100.0),
                               type: "RoundedMultiRect",
                               bDraggable: true,
                               bOrigin: true)
        v3.delegate = self
		v3.bSelected = false
        view.addSubview(v3)
        modell.add(componentView: v3)
        
        let v4 = XFComponentView(frame: CGRect(x: 600.0, y: 80, width: 70.0, height: 100.0),
                               type: "Bus",
                               bDraggable: true,
                               bOrigin: true)
        v4.delegate = self
		v4.bSelected = false
        let txtFieldBus: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
        txtFieldBus.adjustsFontSizeToFitWidth = true
        txtFieldBus.textAlignment = .center
        txtFieldBus.font = UIFont.boldSystemFont(ofSize: 10)
        v4.addSubview(txtFieldBus)
        view.addSubview(v4)
        modell.add(componentView: v4)
        
        let v5 = XFComponentView(frame: CGRect(x: 700.0, y: 100, width: 70.0, height: 90.0),
                               type: "Timer",
                               bDraggable: true,
                               bOrigin: true)
        v5.drawSecondPath = true
        v5.delegate = self
		v5.bSelected = false
        let txtField: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
        txtField.text = "Timer"
        txtField.adjustsFontSizeToFitWidth = true
        txtField.textAlignment = .center
        txtField.font = UIFont.boldSystemFont(ofSize: 10)
        v5.addSubview(txtField)
        view.addSubview(v5)
        modell.add(componentView: v5)
        
        let v6 = XFComponentView(frame: CGRect(x: 800.0, y: 100, width: 70.0, height: 90.0),
                               type: "Clock",
                               bDraggable: true,
                               bOrigin: true)
        v6.drawSecondPath = true
        v6.delegate = self
		v6.bSelected = false
        let txtField2: UITextField = UITextField(frame: CGRect(x: 5, y: 25, width: 60, height: 10));
        txtField2.text = "Clock"
        txtField2.adjustsFontSizeToFitWidth = true
        txtField2.textAlignment = .center
        txtField2.font = UIFont.boldSystemFont(ofSize: 10)
        v6.addSubview(txtField2)
        view.addSubview(v6)
        modell.add(componentView: v6)
        
    }
    
    func initGestureRecognizers() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR: )))
        view.addGestureRecognizer(tapGR)
    }
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        for editPanel in editPanelViewList {
            editPanel.removeFromSuperview()
        }
        
        for cv in modell.GetComponentViewList() {
            cv.bSelected = false
        }
    }
	
	func updateTitle(component: XFComponentView) {
		dataBaseManager.Update(component: component, key: "title")
	}
	
    func updateColor(component: XFComponentView) {
		dataBaseManager.Update(component: component, key: "color")
    }
	
	func updatePosition(){
		for v in modell.GetComponentViewList() {
			dataBaseManager.Update(component: v, key: "position")
		}
	}
	
    func create(component: XFComponentView, frame: CGRect, type: String, bDraggable: Bool, bOrigin: Bool) {
        let v1 = XFComponentView(frame: frame, type: type, bDraggable: bDraggable, bOrigin: bOrigin)
        v1.delegate = self
        v1.bSelected = false
        self.view.addSubview(v1)
		
        var id = generateViewId()
		while dataBaseManager.contains(id: Int64(id)) {
			id = generateViewId()
		}
		component.tag = Int(id)

        visibleRect = imageView.convert(scrollView.bounds, from: scrollView);
        component.frame =  CGRect(x: component.frame.minX + visibleRect.minX,
                                  y: component.frame.minY + visibleRect.minY,
                                  width: component.frame.width,
                                  height: component.frame.height)
        imageView.addSubview(component)
        modell.add(componentView: v1)
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
		
		let component_coredata = Component(entity: NSEntityDescription.entity(forEntityName: "Component", in: dataBaseManager.managedContext!)!,
									       insertInto: dataBaseManager.managedContext)
		component_coredata.tag    = Int64(component.tag)
		component_coredata.type   = component.type
		component_coredata.minX   = Float(component.frame.minX)
		component_coredata.minY   = Float(component.frame.minY)
		component_coredata.width  = Float(component.frame.width)
		component_coredata.height = Float(component.frame.height)
		component_coredata.color  = component.fillColor
		
		if component.intarface1Top != nil {
			let interface_coredata = Interface(entity: NSEntityDescription.entity(forEntityName: "Interface", in: dataBaseManager.managedContext!)!,
			                                   insertInto: dataBaseManager.managedContext)
			interface_coredata.id = "top1"
			interface_coredata.type = component.intarface1Top?.type
			interface_coredata.orient = Float((component.intarface1Top?.orient)!)
			interface_coredata.minX = Float((component.intarface1Top?.frame.minX)!)
			interface_coredata.minY = Float((component.intarface1Top?.frame.minY)!)
			interface_coredata.width = Float((component.intarface1Top?.frame.width)!)
			interface_coredata.height = Float((component.intarface1Top?.frame.height)!)
			component_coredata.addToInterfaces(interface_coredata)
		}
		
		dataBaseManager.componentList.append(component_coredata)
		dataBaseManager.saveContext()
    }
    
    func interface(component: XFComponentView) {
        if component.intarface1Top?.type  == "---" || component.intarface1Top == nil {
            if component.neighborTop1 != nil {
                if component.neighborTop1?.neighborInterfaceNameButtom1 == "neighborTop1" {
                   component.neighborTop1?.neighborButtom1 = nil
                   component.neighborTop1?.neighborInterfaceNameButtom1 = ""
                }
                else if component.neighborTop1?.neighborInterfaceNameButtom2 == "neighborTop1" {
                    component.neighborTop1?.neighborButtom2 = nil
                    component.neighborTop1?.neighborInterfaceNameButtom2 = ""
                }
                else if component.neighborTop1?.neighborInterfaceNameButtom3 == "neighborTop1" {
                    component.neighborTop1?.neighborButtom3 = nil
                    component.neighborTop1?.neighborInterfaceNameButtom3 = ""
                }
                component.neighborTop1 = nil
            }
        }
        if component.intarface2Top?.type  == "---" || component.intarface2Top == nil {
            if component.neighborTop2 != nil {
                if component.neighborTop2?.neighborInterfaceNameButtom1 == "neighborTop2" {
                    component.neighborTop2?.neighborButtom1 = nil
                    component.neighborTop2?.neighborInterfaceNameButtom1 = ""
                }
                else if component.neighborTop2?.neighborInterfaceNameButtom2 == "neighborTop2" {
                    component.neighborTop2?.neighborButtom2 = nil
                    component.neighborTop2?.neighborInterfaceNameButtom2 = ""
                }
                else if component.neighborTop2?.neighborInterfaceNameButtom3 == "neighborTop2" {
                    component.neighborTop2?.neighborButtom3 = nil
                    component.neighborTop2?.neighborInterfaceNameButtom3 = ""
                }
                component.neighborTop2 = nil
            }
        }
        if component.intarface3Top?.type  == "---" || component.intarface3Top == nil {
            if component.neighborTop3 != nil {
                if component.neighborTop3?.neighborInterfaceNameButtom1 == "neighborTop3" {
                    component.neighborTop3?.neighborButtom1 = nil
                    component.neighborTop3?.neighborInterfaceNameButtom1 = ""
                }
                else if component.neighborTop3?.neighborInterfaceNameButtom2 == "neighborTop3" {
                    component.neighborTop3?.neighborButtom2 = nil
                    component.neighborTop3?.neighborInterfaceNameButtom2 = ""
                }
                else if component.neighborTop3?.neighborInterfaceNameButtom3 == "neighborTop3" {
                    component.neighborTop3?.neighborButtom3 = nil
                    component.neighborTop3?.neighborInterfaceNameButtom3 = ""
                }
                component.neighborTop3 = nil
            }
        }
        
        if component.intarface1Buttom?.type == "---" || component.intarface1Buttom == nil {
            if component.neighborButtom1 != nil {
                if component.neighborButtom1?.neighborInterfaceNameTop1 == "neighborButtom1" {
                    component.neighborButtom1?.neighborTop1 = nil
                    component.neighborButtom1?.neighborInterfaceNameTop1 = ""
                }
                else if component.neighborButtom1?.neighborInterfaceNameTop2 == "neighborButtom1" {
                    component.neighborButtom1?.neighborTop2 = nil
                    component.neighborButtom1?.neighborInterfaceNameTop2 = ""
                }
                else if component.neighborButtom1?.neighborInterfaceNameTop3 == "neighborButtom1" {
                    component.neighborButtom1?.neighborTop3 = nil
                    component.neighborButtom1?.neighborInterfaceNameTop3 = ""
                }
                component.neighborButtom1 = nil
            }
        }
        if component.intarface2Buttom?.type == "---" || component.intarface2Buttom == nil {
            if component.neighborButtom2 != nil {
                if component.neighborButtom2?.neighborInterfaceNameTop1 == "neighborButtom2" {
                    component.neighborButtom2?.neighborTop1 = nil
                    component.neighborButtom2?.neighborInterfaceNameTop1 = ""
                }
                else if component.neighborButtom2?.neighborInterfaceNameTop2 == "neighborButtom2" {
                    component.neighborButtom2?.neighborTop2 = nil
                    component.neighborButtom2?.neighborInterfaceNameTop2 = ""
                }
                else if component.neighborButtom2?.neighborInterfaceNameTop3 == "neighborButtom2" {
                    component.neighborButtom2?.neighborTop3 = nil
                    component.neighborButtom2?.neighborInterfaceNameTop3 = ""
                }
                component.neighborButtom2 = nil
            }
        }
        if component.intarface3Buttom?.type == "---" || component.intarface3Buttom == nil {
            if component.neighborButtom3 != nil {
                if component.neighborButtom3?.neighborInterfaceNameTop1 == "neighborButtom3" {
                    component.neighborButtom3?.neighborTop1 = nil
                    component.neighborButtom3?.neighborInterfaceNameTop1 = ""
                }
                else if component.neighborButtom3?.neighborInterfaceNameTop2 == "neighborButtom3" {
                    component.neighborButtom3?.neighborTop2 = nil
                    component.neighborButtom3?.neighborInterfaceNameTop2 = ""
                }
                else if component.neighborButtom3?.neighborInterfaceNameTop3 == "neighborButtom3" {
                    component.neighborButtom3?.neighborTop3 = nil
                    component.neighborButtom3?.neighborInterfaceNameTop3 = ""
                }
                component.neighborButtom3 = nil
            }
        }
        
        if component.intarface1Right?.type == "---" || component.intarface1Right == nil {
            if component.neighborRight1 != nil {
                if component.neighborRight1?.neighborInterfaceNameLeft1 == "neighborRight1" {
                    component.neighborRight1?.neighborLeft1 = nil
                    component.neighborRight1?.neighborInterfaceNameLeft1 = ""
                }
                else if component.neighborRight1?.neighborInterfaceNameLeft2 == "neighborRight1" {
                    component.neighborRight1?.neighborLeft2 = nil
                    component.neighborRight1?.neighborInterfaceNameLeft2 = ""
                }
                else if component.neighborRight1?.neighborInterfaceNameLeft3 == "neighborRight1" {
                    component.neighborRight1?.neighborLeft3 = nil
                    component.neighborRight1?.neighborInterfaceNameLeft3 = ""
                }
                component.neighborRight1 = nil
            }
        }
        
        if component.intarface2Right?.type == "---" || component.intarface2Right == nil {
            if component.neighborRight2 != nil {
                if component.neighborRight2?.neighborInterfaceNameLeft1 == "neighborRight2" {
                    component.neighborRight2?.neighborLeft1 = nil
                    component.neighborRight2?.neighborInterfaceNameLeft1 = ""
                }
                else if component.neighborRight2?.neighborInterfaceNameLeft2 == "neighborRight2" {
                    component.neighborRight2?.neighborLeft2 = nil
                    component.neighborRight2?.neighborInterfaceNameLeft2 = ""
                }
                else if component.neighborRight2?.neighborInterfaceNameLeft3 == "neighborRight2" {
                    component.neighborRight2?.neighborLeft3 = nil
                    component.neighborRight2?.neighborInterfaceNameLeft3 = ""
                }
                component.neighborRight2 = nil
            }
        }
            
        if component.intarface3Right?.type == "---" || component.intarface3Right == nil {
            if component.neighborRight3 != nil {
                if component.neighborRight3?.neighborInterfaceNameLeft1 == "neighborRight3" {
                    component.neighborRight3?.neighborLeft1 = nil
                    component.neighborRight3?.neighborInterfaceNameLeft1 = ""
                }
                else if component.neighborRight3?.neighborInterfaceNameLeft2 == "neighborRight3" {
                    component.neighborRight3?.neighborLeft2 = nil
                    component.neighborRight3?.neighborInterfaceNameLeft2 = ""
                }
                else if component.neighborRight3?.neighborInterfaceNameLeft3 == "neighborRight3" {
                    component.neighborRight3?.neighborLeft3 = nil
                    component.neighborRight3?.neighborInterfaceNameLeft3 = ""
                }
                component.neighborRight3 = nil
            }
        }

        if component.intarface1Left?.type == "---" || component.intarface1Left == nil {
            if component.neighborLeft1 != nil {
                if component.neighborLeft1?.neighborInterfaceNameRight1 == "neighborLeft1" {
                    component.neighborLeft1?.neighborRight1 = nil
                    component.neighborLeft1?.neighborInterfaceNameRight1 = ""
                }
                else if component.neighborLeft1?.neighborInterfaceNameRight2 == "neighborLeft1" {
                    component.neighborLeft1?.neighborRight2 = nil
                    component.neighborLeft1?.neighborInterfaceNameRight2 = ""
                }
                else if component.neighborLeft1?.neighborInterfaceNameRight3 == "neighborLeft1" {
                    component.neighborLeft1?.neighborRight3 = nil
                    component.neighborLeft1?.neighborInterfaceNameRight3 = ""
                }
                component.neighborLeft1 = nil
            }
        }
        if component.intarface2Left?.type == "---" || component.intarface2Left == nil {
            if component.neighborLeft2 != nil {
                if component.neighborLeft2?.neighborInterfaceNameRight1 == "neighborLeft2" {
                    component.neighborLeft2?.neighborRight1 = nil
                    component.neighborLeft2?.neighborInterfaceNameRight1 = ""
                }
                else if component.neighborLeft2?.neighborInterfaceNameRight2 == "neighborLeft2" {
                    component.neighborLeft2?.neighborRight2 = nil
                    component.neighborLeft2?.neighborInterfaceNameRight2 = ""
                }
                else if component.neighborLeft2?.neighborInterfaceNameRight3 == "neighborLeft2" {
                    component.neighborLeft2?.neighborRight3 = nil
                    component.neighborLeft2?.neighborInterfaceNameRight3 = ""
                }
                component.neighborLeft2 = nil
            }
        }
        if component.intarface3Left?.type == "---" || component.intarface3Left == nil {
            if component.neighborLeft3 != nil {
                if component.neighborLeft3?.neighborInterfaceNameRight1 == "neighborLeft3" {
                    component.neighborLeft3?.neighborRight1 = nil
                    component.neighborLeft3?.neighborInterfaceNameRight1 = ""
                }
                else if component.neighborLeft3?.neighborInterfaceNameRight2 == "neighborLeft3" {
                    component.neighborLeft3?.neighborRight2 = nil
                    component.neighborLeft3?.neighborInterfaceNameRight2 = ""
                }
                else if component.neighborLeft3?.neighborInterfaceNameRight3 == "neighborLeft3" {
                    component.neighborLeft3?.neighborRight3 = nil
                    component.neighborLeft3?.neighborInterfaceNameRight3 = ""
                }
                component.neighborLeft3 = nil
            }
        }
		
		//dataBaseManager.Update(component: component, key: "interface")
    }
    
    func select(component: XFComponentView) {
        
        for v in editPanelViewList {
            v.removeFromSuperview()
        }
        var h = CGFloat(400)
        if component.type == "Bus" {
            h = 275
        } else if component.type == "Timer" || component.type == "Clock"{
            h = 145
        }
        visibleRect = imageView.convert(scrollView.bounds, from: scrollView)
        if ( (component.frame.minY - visibleRect.minY) < 400 && ( visibleRect.maxY - component.frame.minY > 400) ){
            if ((visibleRect.maxX - component.frame.maxX) < 210 ){
                component.editPanel.frame = CGRect(x: component.frame.minX - 250,
                                                   y: component.frame.minY,
                                                   width: 210, height: h)
            } else {
                component.editPanel.frame = CGRect(x: component.frame.maxX + 40,
                                                   y: component.frame.minY,
                                                   width: 210, height: h)
            }
            
        } else if ( visibleRect.maxY - component.frame.minY < 400 && (component.frame.maxY - visibleRect.minY > 600)) {
            
            if ((visibleRect.maxX - component.frame.maxX) < 210 ){
                component.editPanel.frame = CGRect(x: component.frame.minX - 250,
                                                   y: component.frame.maxY - 400,
                                                   width: 210, height: h)
            } else {
                component.editPanel.frame = CGRect(x: component.frame.maxX + 40,
                                                   y: component.frame.maxY - 400,
                                                   width: 210, height: h)
            }
            
            
        } else {
            
            if ((visibleRect.maxX - component.frame.maxX) < 210 ){
                component.editPanel.frame = CGRect(x: component.frame.minX - 250,
                                                   y: component.frame.maxY - 250,
                                                   width: 210, height: h)
            } else {
                component.editPanel.frame = CGRect(x: component.frame.maxX + 40,
                                                   y: component.frame.maxY - 250,
                                                   width: 210, height: h)
            }
        }
        
        imageView.addSubview(component.editPanel)
        editPanelViewList.append(component.editPanel)
    }
    
    func delete(component: XFComponentView) {
        if component.neighborTop1 != nil {
            if component.neighborTop1?.neighborInterfaceNameButtom1 == "neighborTop1" {
                component.neighborTop1?.neighborButtom1 = nil
                component.neighborTop1?.neighborInterfaceNameButtom1 = ""
            }
            else if component.neighborTop1?.neighborInterfaceNameButtom2 == "neighborTop1" {
                component.neighborTop1?.neighborButtom2 = nil
                component.neighborTop1?.neighborInterfaceNameButtom2 = ""
            }
            else if component.neighborTop1?.neighborInterfaceNameButtom3 == "neighborTop1" {
                component.neighborTop1?.neighborButtom3 = nil
                component.neighborTop1?.neighborInterfaceNameButtom3 = ""
            }
            component.neighborTop1 = nil
        }
        if component.neighborTop2 != nil {
            if component.neighborTop2?.neighborInterfaceNameButtom1 == "neighborTop2" {
                component.neighborTop2?.neighborButtom1 = nil
                component.neighborTop2?.neighborInterfaceNameButtom1 = ""
            }
            else if component.neighborTop2?.neighborInterfaceNameButtom2 == "neighborTop2" {
                component.neighborTop2?.neighborButtom2 = nil
                component.neighborTop2?.neighborInterfaceNameButtom2 = ""
            }
            else if component.neighborTop2?.neighborInterfaceNameButtom3 == "neighborTop2" {
                component.neighborTop2?.neighborButtom3 = nil
                component.neighborTop2?.neighborInterfaceNameButtom3 = ""
            }
            component.neighborTop2 = nil
        }
        if component.neighborTop3 != nil {
            if component.neighborTop3?.neighborInterfaceNameButtom1 == "neighborTop3" {
                component.neighborTop3?.neighborButtom1 = nil
                component.neighborTop3?.neighborInterfaceNameButtom1 = ""
            }
            else if component.neighborTop3?.neighborInterfaceNameButtom2 == "neighborTop3" {
                component.neighborTop3?.neighborButtom2 = nil
                component.neighborTop3?.neighborInterfaceNameButtom2 = ""
            }
            else if component.neighborTop3?.neighborInterfaceNameButtom3 == "neighborTop3" {
                component.neighborTop3?.neighborButtom3 = nil
                component.neighborTop3?.neighborInterfaceNameButtom3 = ""
            }
            component.neighborTop3 = nil
        }
        
        if component.neighborButtom1 != nil {
            if component.neighborButtom1?.neighborInterfaceNameTop1 == "neighborButtom1" {
                component.neighborButtom1?.neighborTop1 = nil
                component.neighborButtom1?.neighborInterfaceNameTop1 = ""
            }
            else if component.neighborButtom1?.neighborInterfaceNameTop2 == "neighborButtom1" {
                component.neighborButtom1?.neighborTop2 = nil
                component.neighborButtom1?.neighborInterfaceNameTop2 = ""
            }
            else if component.neighborButtom1?.neighborInterfaceNameTop3 == "neighborButtom1" {
                component.neighborButtom1?.neighborTop3 = nil
                component.neighborButtom1?.neighborInterfaceNameTop3 = ""
            }
            component.neighborButtom1 = nil
        }
        if component.neighborButtom2 != nil {
            if component.neighborButtom2?.neighborInterfaceNameTop1 == "neighborButtom2" {
                component.neighborButtom2?.neighborTop1 = nil
                component.neighborButtom2?.neighborInterfaceNameTop1 = ""
            }
            else if component.neighborButtom2?.neighborInterfaceNameTop2 == "neighborButtom2" {
                component.neighborButtom2?.neighborTop2 = nil
                component.neighborButtom2?.neighborInterfaceNameTop2 = ""
            }
            else if component.neighborButtom2?.neighborInterfaceNameTop3 == "neighborButtom2" {
                component.neighborButtom2?.neighborTop3 = nil
                component.neighborButtom2?.neighborInterfaceNameTop3 = ""
            }
            component.neighborButtom2 = nil
        }
        if component.neighborButtom3 != nil {
            if component.neighborButtom3?.neighborInterfaceNameTop1 == "neighborButtom3" {
                component.neighborButtom3?.neighborTop1 = nil
                component.neighborButtom3?.neighborInterfaceNameTop1 = ""
            }
            else if component.neighborButtom3?.neighborInterfaceNameTop2 == "neighborButtom3" {
                component.neighborButtom3?.neighborTop2 = nil
                component.neighborButtom3?.neighborInterfaceNameTop2 = ""
            }
            else if component.neighborButtom3?.neighborInterfaceNameTop3 == "neighborButtom3" {
                component.neighborButtom3?.neighborTop3 = nil
                component.neighborButtom3?.neighborInterfaceNameTop3 = ""
            }
            component.neighborButtom3 = nil
        }
        
        if component.neighborRight1 != nil {
            if component.neighborRight1?.neighborInterfaceNameLeft1 == "neighborRight1" {
                component.neighborRight1?.neighborLeft1 = nil
                component.neighborRight1?.neighborInterfaceNameLeft1 = ""
            }
            else if component.neighborRight1?.neighborInterfaceNameLeft2 == "neighborRight1" {
                component.neighborRight1?.neighborLeft2 = nil
                component.neighborRight1?.neighborInterfaceNameLeft2 = ""
            }
            else if component.neighborRight1?.neighborInterfaceNameLeft3 == "neighborRight1" {
                component.neighborRight1?.neighborLeft3 = nil
                component.neighborRight1?.neighborInterfaceNameLeft3 = ""
            }
            component.neighborRight1 = nil
        }
        if component.neighborRight2 != nil {
            if component.neighborRight2?.neighborInterfaceNameLeft1 == "neighborRight2" {
                component.neighborRight2?.neighborLeft1 = nil
                component.neighborRight2?.neighborInterfaceNameLeft1 = ""
            }
            else if component.neighborRight2?.neighborInterfaceNameLeft2 == "neighborRight2" {
                component.neighborRight2?.neighborLeft2 = nil
                component.neighborRight2?.neighborInterfaceNameLeft2 = ""
            }
            else if component.neighborRight2?.neighborInterfaceNameLeft3 == "neighborRight2" {
                component.neighborRight2?.neighborLeft3 = nil
                component.neighborRight2?.neighborInterfaceNameLeft3 = ""
            }
            component.neighborRight2 = nil
        }
        if component.neighborRight3 != nil {
            if component.neighborRight3?.neighborInterfaceNameLeft1 == "neighborRight3" {
                component.neighborRight3?.neighborLeft1 = nil
                component.neighborRight3?.neighborInterfaceNameLeft1 = ""
            }
            else if component.neighborRight3?.neighborInterfaceNameLeft2 == "neighborRight3" {
                component.neighborRight3?.neighborLeft2 = nil
                component.neighborRight3?.neighborInterfaceNameLeft2 = ""
            }
            else if component.neighborRight3?.neighborInterfaceNameLeft3 == "neighborRight3" {
                component.neighborRight3?.neighborLeft3 = nil
                component.neighborRight3?.neighborInterfaceNameLeft3 = ""
            }
            component.neighborRight3 = nil
        }
        
        if component.neighborLeft1 != nil {
            if component.neighborLeft1?.neighborInterfaceNameRight1 == "neighborLeft1" {
                component.neighborLeft1?.neighborRight1 = nil
                component.neighborLeft1?.neighborInterfaceNameRight1 = ""
            }
            else if component.neighborLeft1?.neighborInterfaceNameRight2 == "neighborLeft1" {
                component.neighborLeft1?.neighborRight2 = nil
                component.neighborLeft1?.neighborInterfaceNameRight2 = ""
            }
            else if component.neighborLeft1?.neighborInterfaceNameRight3 == "neighborLeft1" {
                component.neighborLeft1?.neighborRight3 = nil
                component.neighborLeft1?.neighborInterfaceNameRight3 = ""
            }
            component.neighborLeft1 = nil
        }
        if component.neighborLeft2 != nil {
            if component.neighborLeft2 != nil {
                if component.neighborLeft2?.neighborInterfaceNameRight1 == "neighborLeft2" {
                    component.neighborLeft2?.neighborRight1 = nil
                    component.neighborLeft2?.neighborInterfaceNameRight1 = ""
                }
                else if component.neighborLeft2?.neighborInterfaceNameRight2 == "neighborLeft2" {
                    component.neighborLeft2?.neighborRight2 = nil
                    component.neighborLeft2?.neighborInterfaceNameRight2 = ""
                }
                else if component.neighborLeft2?.neighborInterfaceNameRight3 == "neighborLeft2" {
                    component.neighborLeft2?.neighborRight3 = nil
                    component.neighborLeft2?.neighborInterfaceNameRight3 = ""
                }
                component.neighborLeft2 = nil
            }
            component.neighborLeft2 = nil
        }
        if component.neighborLeft3 != nil {
            if component.neighborLeft3?.neighborInterfaceNameRight1 == "neighborLeft3" {
                component.neighborLeft3?.neighborRight1 = nil
                component.neighborLeft3?.neighborInterfaceNameRight1 = ""
            }
            else if component.neighborLeft3?.neighborInterfaceNameRight2 == "neighborLeft3" {
                component.neighborLeft3?.neighborRight2 = nil
                component.neighborLeft3?.neighborInterfaceNameRight2 = ""
            }
            else if component.neighborLeft3?.neighborInterfaceNameRight3 == "neighborLeft3" {
                component.neighborLeft3?.neighborRight3 = nil
                component.neighborLeft3?.neighborInterfaceNameRight3 = ""
            }
            component.neighborLeft3 = nil
        }
        
		dataBaseManager.Delete(component: component)
        component.removeFromSuperview()
    }
    
    var tmp_move = [XFComponentView]()
    func trace_move(component: XFComponentView!) {
        if component.neighborTop1 != nil && !tmp_move.contains(component.neighborTop1!) && component.neighborTop1 != self {
            tmp_move.append(component.neighborTop1!)
            trace_move(component: component.neighborTop1!)
        }
        if component.neighborTop2 != nil && !tmp_move.contains(component.neighborTop2!) && component.neighborTop2 != self {
            tmp_move.append(component.neighborTop2!)
            trace_move(component: component.neighborTop2!)
        }
        if component.neighborTop3 != nil && !tmp_move.contains(component.neighborTop3!) && component.neighborTop3 != self {
            tmp_move.append(component.neighborTop3!)
            trace_move(component: component.neighborTop3!)
        }
        
        if component.neighborRight1 != nil && !tmp_move.contains(component.neighborRight1!) && component.neighborRight1 != self {
            tmp_move.append(component.neighborRight1!)
            trace_move(component: component.neighborRight1!)
        }
        if component.neighborRight2 != nil && !tmp_move.contains(component.neighborRight2!) && component.neighborRight2 != self {
            tmp_move.append(component.neighborRight2!)
            trace_move(component: component.neighborRight2!)
        }
        if component.neighborRight3 != nil && !tmp_move.contains(component.neighborRight3!) && component.neighborRight3 != self {
            tmp_move.append(component.neighborRight3!)
            trace_move(component: component.neighborRight3!)
        }
        
        if component.neighborButtom1 != nil && !tmp_move.contains(component.neighborButtom1!) && component.neighborButtom1 != self {
            tmp_move.append(component.neighborButtom1!)
            trace_move(component: component.neighborButtom1!)
        }
        if component.neighborButtom2 != nil && !tmp_move.contains(component.neighborButtom2!) && component.neighborButtom2 != self {
            tmp_move.append(component.neighborButtom2!)
            trace_move(component: component.neighborButtom2!)
        }
        if component.neighborButtom3 != nil && !tmp_move.contains(component.neighborButtom3!) && component.neighborButtom3 != self {
            tmp_move.append(component.neighborButtom3!)
            trace_move(component: component.neighborButtom3!)
        }
        
        if component.neighborLeft1 != nil && !tmp_move.contains(component.neighborLeft1!) && component.neighborLeft1 != self {
            tmp_move.append(component.neighborLeft1!)
            trace_move(component: component.neighborLeft1!)
        }
        if component.neighborLeft2 != nil && !tmp_move.contains(component.neighborLeft2!) && component.neighborLeft2 != self {
            tmp_move.append(component.neighborLeft2!)
            trace_move(component: component.neighborLeft2!)
        }
        if component.neighborLeft3 != nil && !tmp_move.contains(component.neighborLeft3!) && component.neighborLeft3 != self {
            tmp_move.append(component.neighborLeft3!)
            trace_move(component: component.neighborLeft3!)
        }
    }
    
    func merge(component: XFComponentView) {
		
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
            for secondComponentView in modell.GetComponentViewList() {
                if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                    let secondComponentView_intarface1Right_convert  = secondComponentView.intarface1Right?.convert((secondComponentView.intarface1Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Right_convert  = secondComponentView.intarface2Right?.convert((secondComponentView.intarface2Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface3Right_convert  = secondComponentView.intarface3Right?.convert((secondComponentView.intarface3Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface1Left_convert   = secondComponentView.intarface1Left?.convert((secondComponentView.intarface1Left?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Left_convert   = secondComponentView.intarface2Left?.convert((secondComponentView.intarface2Left?.bounds)!, to: self.view)
                    let secondComponentView_intarface3Left_convert   = secondComponentView.intarface3Left?.convert((secondComponentView.intarface3Left?.bounds)!, to: self.view)
                    
                    if secondComponentView_intarface1Right_convert != nil && firstComponentView_intarface1Left_convert != nil {
                        if (secondComponentView_intarface1Right_convert?.intersects(firstComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborLeft1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft1 = secondComponentView
                                secondComponentView.neighborRight1 = firstComponentView
                            }
                        }
                    }
                    if secondComponentView_intarface1Right_convert != nil && firstComponentView_intarface2Left_convert != nil {
                        if (secondComponentView_intarface1Right_convert?.intersects(firstComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY - 37,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight1 = firstComponentView
                            }
                        }
                    }
                    if secondComponentView_intarface1Right_convert != nil && firstComponentView_intarface3Left_convert != nil {
                        if (secondComponentView_intarface1Right_convert?.intersects(firstComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborLeft3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY - 72,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft3 = secondComponentView
                                secondComponentView.neighborRight1 = firstComponentView
                            }
                        }
                    }
                    
                    if secondComponentView_intarface2Right_convert != nil && firstComponentView_intarface1Left_convert != nil {
                        if (secondComponentView_intarface2Right_convert?.intersects(firstComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborLeft1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY + 37,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft1 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                            }
                        }
                    }
                    if secondComponentView_intarface2Right_convert != nil && firstComponentView_intarface2Left_convert != nil {
                        if (secondComponentView_intarface2Right_convert?.intersects(firstComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                            }
                        }
                    }
                    if secondComponentView_intarface2Right_convert != nil && firstComponentView_intarface3Left_convert != nil {
                        if (secondComponentView_intarface2Right_convert?.intersects(firstComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborLeft3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY - 35,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft3 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                            }
                        }
                    }
                    
                    if secondComponentView_intarface3Right_convert != nil && firstComponentView_intarface1Left_convert != nil {
                        if (secondComponentView_intarface3Right_convert?.intersects(firstComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborLeft1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY + 72,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft1 = secondComponentView
                                secondComponentView.neighborRight3 = firstComponentView
                            }
                        }
                    }
                    if secondComponentView_intarface3Right_convert != nil && firstComponentView_intarface2Left_convert != nil {
                        if (secondComponentView_intarface3Right_convert?.intersects(firstComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY + 35,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight3 = firstComponentView
                            }
                        }
                    }
                    if secondComponentView_intarface3Right_convert != nil && firstComponentView_intarface3Left_convert != nil {
                        if (secondComponentView_intarface3Right_convert?.intersects(firstComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborLeft3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborLeft3 = secondComponentView
                                secondComponentView.neighborRight3 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight1 = secondComponentView
                                secondComponentView.neighborLeft1 = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY + 37,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight1 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY + 72,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight1 = secondComponentView
                                secondComponentView.neighborLeft3 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY - 37,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft1 = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY + 35,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft3 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY - 72,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight3 = secondComponentView
                                secondComponentView.neighborLeft1 = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY - 35,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight3 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                            }
                        }
                    }
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 102,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 70, height: 100)
                                firstComponentView.neighborRight3 = secondComponentView
                                secondComponentView.neighborLeft3 = firstComponentView
                            }
                        }
                    }
                }
            }
        case "Timer":
            for secondComponentView in modell.GetComponentViewList() {
                if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" && secondComponentView.type != "Bus" {
                    let secondComponentView_intarface2Top_convert    = secondComponentView.intarface2Top?.convert((secondComponentView.intarface2Top?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Buttom_convert = secondComponentView.intarface2Buttom?.convert((secondComponentView.intarface2Buttom?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Right_convert  = secondComponentView.intarface2Right?.convert((secondComponentView.intarface2Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Left_convert   = secondComponentView.intarface2Left?.convert((secondComponentView.intarface2Left?.bounds)!, to: self.view)
                    
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 16,
                                                                  y: secondComponentView.frame.maxY + 16,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborTop2 = secondComponentView
                                secondComponentView.neighborButtom2 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborButtom2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 14,
                                                                  y: secondComponentView.frame.minY - 86,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborButtom2 = secondComponentView
                                secondComponentView.neighborTop2 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 88,
                                                                  y: secondComponentView.frame.minY + 17,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 17,
                                                                  y: secondComponentView.frame.minY + 13,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                            }
                        }
                    }
                }
            }
        case "Clock":
            for secondComponentView in modell.GetComponentViewList() {
                if secondComponentView.type != "Timer" && secondComponentView.type != "Clock" && secondComponentView.type != "Bus" {
                    let secondComponentView_intarface2Top_convert    = secondComponentView.intarface2Top?.convert((secondComponentView.intarface2Top?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Buttom_convert = secondComponentView.intarface2Buttom?.convert((secondComponentView.intarface2Buttom?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Right_convert  = secondComponentView.intarface2Right?.convert((secondComponentView.intarface2Right?.bounds)!, to: self.view)
                    let secondComponentView_intarface2Left_convert   = secondComponentView.intarface2Left?.convert((secondComponentView.intarface2Left?.bounds)!, to: self.view)
                    
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 16,
                                                                  y: secondComponentView.frame.maxY + 16,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborTop2 = secondComponentView
                                secondComponentView.neighborButtom2 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborButtom2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 14,
                                                                  y: secondComponentView.frame.minY - 86,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborButtom2 = secondComponentView
                                secondComponentView.neighborTop2 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 88,
                                                                  y: secondComponentView.frame.minY + 17,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX + 17,
                                                                  y: secondComponentView.frame.minY + 13,
                                                                  width: 70, height: 90)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                            }
                        }
                    }
                }
            }
        default:
            for secondComponentView in modell.GetComponentViewList() {
                if( secondComponentView != firstComponentView && !secondComponentView.bOrigin ) {
                    
                    var w_bus = CGFloat(0)
                    var x_timer_top = CGFloat(0)
                    var y_timer_top = CGFloat(0)
                    var x_timer_buttom = CGFloat(0)
                    var y_timer_buttom = CGFloat(0)
                    var x_timer_right = CGFloat(0)
                    var y_timer_right = CGFloat(0)
                    var x_timer_left = CGFloat(0)
                    var y_timer_left = CGFloat(0)
                    if secondComponentView.type == "Bus" {
                        w_bus = 30
                    } else if secondComponentView.type == "Timer" || secondComponentView.type == "Clock" {
                        x_timer_top = 14
                        y_timer_top = 45
                        
                        x_timer_buttom = -16
                        y_timer_buttom = 15
                        
                        x_timer_right = 14
                        y_timer_right = -13
                        
                        x_timer_left = -45
                        y_timer_left = -17
                    }
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
                            if firstComponentView.neighborTop1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop1 = secondComponentView
                                secondComponentView.neighborButtom1 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop1 = "neighborButtom1"
                                secondComponentView.neighborInterfaceNameButtom1 = "neighborTop1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface1Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 15,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop1 = secondComponentView
                                secondComponentView.neighborButtom2 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop1 = "neighborButtom2"
                                secondComponentView.neighborInterfaceNameButtom2 = "neighborTop1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Top_convert != nil && secondComponentView_intarface3Buttom_convert != nil {
                        if (firstComponentView_intarface1Top_convert?.intersects(secondComponentView_intarface3Buttom_convert!))! {
                            if firstComponentView.neighborTop1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX - 28,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop1 = secondComponentView
                                secondComponentView.neighborButtom3 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop1 = "neighborButtom3"
                                secondComponentView.neighborInterfaceNameButtom3 = "neighborTop1"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface1Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface1Buttom_convert!))! {
                            if firstComponentView.neighborTop2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 35,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop2 = secondComponentView
                                secondComponentView.neighborButtom1 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop2 = "neighborButtom1"
                                secondComponentView.neighborInterfaceNameButtom1 = "neighborTop2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - x_timer_top,
                                                                  y: secondComponentView.frame.minY + 132 - y_timer_top,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop2 = secondComponentView
                                secondComponentView.neighborButtom2 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop2 = "neighborButtom2"
                                secondComponentView.neighborInterfaceNameButtom2 = "neighborTop2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Top_convert != nil && secondComponentView_intarface3Buttom_convert != nil {
                        if (firstComponentView_intarface2Top_convert?.intersects(secondComponentView_intarface3Buttom_convert!))! {
                            if firstComponentView.neighborTop2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 13,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop2 = secondComponentView
                                secondComponentView.neighborButtom3 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop2 = "neighborButtom3"
                                secondComponentView.neighborInterfaceNameButtom3 = "neighborTop2"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Top_convert != nil && secondComponentView_intarface1Buttom_convert != nil {
                        if (firstComponentView_intarface3Top_convert?.intersects(secondComponentView_intarface1Buttom_convert!))! {
                            if firstComponentView.neighborTop3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 72,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop3 = secondComponentView
                                secondComponentView.neighborButtom1 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop3 = "neighborButtom1"
                                secondComponentView.neighborInterfaceNameButtom1 = "neighborTop3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Top_convert != nil && secondComponentView_intarface2Buttom_convert != nil {
                        if (firstComponentView_intarface3Top_convert?.intersects(secondComponentView_intarface2Buttom_convert!))! {
                            if firstComponentView.neighborTop3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 37,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop3 = secondComponentView
                                secondComponentView.neighborButtom2 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop3 = "neighborButtom2"
                                secondComponentView.neighborInterfaceNameButtom2 = "neighborTop3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Top_convert != nil && secondComponentView_intarface3Buttom_convert != nil {
                        if (firstComponentView_intarface3Top_convert?.intersects(secondComponentView_intarface3Buttom_convert!))! {
                            if firstComponentView.neighborTop3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY + 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborTop3 = secondComponentView
                                secondComponentView.neighborButtom3 = firstComponentView
                                firstComponentView.neighborInterfaceNameTop3 = "neighborButtom3"
                                secondComponentView.neighborInterfaceNameButtom3 = "neighborTop3"
                            }
                        }
                    }
                    
                    //
                    if firstComponentView_intarface1Buttom_convert != nil && secondComponentView_intarface1Top_convert != nil {
                        if (firstComponentView_intarface1Buttom_convert?.intersects(secondComponentView_intarface1Top_convert!))! {
                            if firstComponentView.neighborButtom1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom1 = secondComponentView
                                secondComponentView.neighborTop1 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom1 = "neighborTop1"
                                secondComponentView.neighborInterfaceNameTop1 = "neighborButtom1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface1Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborButtom1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 15,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom1 = secondComponentView
                                secondComponentView.neighborTop2 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom1 = "neighborTop2"
                                secondComponentView.neighborInterfaceNameTop2 = "neighborButtom1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Buttom_convert != nil && secondComponentView_intarface3Top_convert != nil {
                        if (firstComponentView_intarface1Buttom_convert?.intersects(secondComponentView_intarface3Top_convert!))! {
                            if firstComponentView.neighborButtom1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.maxX - 28,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom1 = secondComponentView
                                secondComponentView.neighborTop3 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom1 = "neighborTop3"
                                secondComponentView.neighborInterfaceNameTop3 = "neighborButtom1"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface1Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface1Top_convert!))! {
                            if firstComponentView.neighborButtom2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 35,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom2 = secondComponentView
                                secondComponentView.neighborTop1 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom2 = "neighborTop1"
                                secondComponentView.neighborInterfaceNameTop1 = "neighborButtom2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborButtom2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + x_timer_buttom,
                                                                  y: secondComponentView.frame.minY - 132 + y_timer_buttom,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom2 = secondComponentView
                                secondComponentView.neighborTop2 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom2 = "neighborTop2"
                                secondComponentView.neighborInterfaceNameTop2 = "neighborButtom2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Buttom_convert != nil && secondComponentView_intarface3Top_convert != nil {
                        if (firstComponentView_intarface2Buttom_convert?.intersects(secondComponentView_intarface3Top_convert!))! {
                            if firstComponentView.neighborButtom2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.midX - 13,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom2 = secondComponentView
                                secondComponentView.neighborTop3 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom2 = "neighborTop3"
                                secondComponentView.neighborInterfaceNameTop3 = "neighborButtom2"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Buttom_convert != nil && secondComponentView_intarface1Top_convert != nil {
                        if (firstComponentView_intarface3Buttom_convert?.intersects(secondComponentView_intarface1Top_convert!))! {
                            if firstComponentView.neighborButtom3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 72,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom3 = secondComponentView
                                secondComponentView.neighborTop1 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom3 = "neighborTop1"
                                secondComponentView.neighborInterfaceNameTop1 = "neighborButtom3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Buttom_convert != nil && secondComponentView_intarface2Top_convert != nil {
                        if (firstComponentView_intarface3Buttom_convert?.intersects(secondComponentView_intarface2Top_convert!))! {
                            if firstComponentView.neighborButtom3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 37,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom3 = secondComponentView
                                secondComponentView.neighborTop2 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom3 = "neighborTop2"
                                secondComponentView.neighborInterfaceNameTop2 = "neighborButtom3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Buttom_convert != nil && secondComponentView_intarface3Top_convert != nil {
                        if (firstComponentView_intarface3Buttom_convert?.intersects(secondComponentView_intarface3Top_convert!))! {
                            if firstComponentView.neighborButtom3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX,
                                                                  y: secondComponentView.frame.minY - 132,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborButtom3 = secondComponentView
                                secondComponentView.neighborTop3 = firstComponentView
                                firstComponentView.neighborInterfaceNameButtom3 = "neighborTop3"
                                secondComponentView.neighborInterfaceNameTop3 = "neighborButtom3"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight1 = secondComponentView
                                secondComponentView.neighborLeft1 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight1 = "neighborLeft1"
                                secondComponentView.neighborInterfaceNameLeft1 = "neighborRight1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY + 38,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight1 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight1 = "neighborLeft2"
                                secondComponentView.neighborInterfaceNameLeft2 = "neighborRight1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface1Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY + 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight1 = secondComponentView
                                secondComponentView.neighborLeft3 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight1 = "neighborLeft3"
                                secondComponentView.neighborInterfaceNameLeft3 = "neighborRight1"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY - 37,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft1 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight2 = "neighborLeft1"
                                secondComponentView.neighborInterfaceNameLeft1 = "neighborRight2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132 + x_timer_right,
                                                                  y: secondComponentView.frame.minY + y_timer_right,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight2 = "neighborLeft2"
                                secondComponentView.neighborInterfaceNameLeft2 = "neighborRight2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface2Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY + 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight2 = secondComponentView
                                secondComponentView.neighborLeft3 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight2 = "neighborLeft3"
                                secondComponentView.neighborInterfaceNameLeft3 = "neighborRight2"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface1Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface1Left_convert!))! {
                            if firstComponentView.neighborRight3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY - 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight3 = secondComponentView
                                secondComponentView.neighborLeft1 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight3 = "neighborLeft1"
                                secondComponentView.neighborInterfaceNameLeft1 = "neighborRight3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface2Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface2Left_convert!))! {
                            if firstComponentView.neighborRight3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY - 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight3 = secondComponentView
                                secondComponentView.neighborLeft2 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight3 = "neighborLeft2"
                                secondComponentView.neighborInterfaceNameLeft2 = "neighborRight3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Right_convert != nil && secondComponentView_intarface3Left_convert != nil {
                        if (firstComponentView_intarface3Right_convert?.intersects(secondComponentView_intarface3Left_convert!))! {
                            if firstComponentView.neighborRight3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX - 132,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborRight3 = secondComponentView
                                secondComponentView.neighborLeft3 = firstComponentView
                                firstComponentView.neighborInterfaceNameRight3 = "neighborLeft3"
                                secondComponentView.neighborInterfaceNameLeft3 = "neighborRight3"
                            }
                        }
                    }
                    
                    
                    if firstComponentView_intarface1Left_convert != nil && secondComponentView_intarface1Right_convert != nil {
                        if (firstComponentView_intarface1Left_convert?.intersects(secondComponentView_intarface1Right_convert!))! {
                            if firstComponentView.neighborLeft1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft1 = secondComponentView
                                secondComponentView.neighborRight1 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft1 = "neighborRight1"
                                secondComponentView.neighborInterfaceNameRight1 = "neighborLeft1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface1Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY + 37,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft1 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft1 = "neighborRight2"
                                secondComponentView.neighborInterfaceNameRight2 = "neighborLeft1"
                            }
                        }
                    }
                    if firstComponentView_intarface1Left_convert != nil && secondComponentView_intarface3Right_convert != nil {
                        if (firstComponentView_intarface1Left_convert?.intersects(secondComponentView_intarface3Right_convert!))! {
                            if firstComponentView.neighborLeft1 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY + 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft1 = secondComponentView
                                secondComponentView.neighborRight3 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft1 = "neighborRight3"
                                secondComponentView.neighborInterfaceNameRight3 = "neighborLeft1"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface1Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface1Right_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY - 37,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight1 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft2 = "neighborRight1"
                                secondComponentView.neighborInterfaceNameRight1 = "neighborLeft2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus + x_timer_left,
                                                                  y: secondComponentView.frame.minY + y_timer_left,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft2 = "neighborRight2"
                                secondComponentView.neighborInterfaceNameRight2 = "neighborLeft2"
                            }
                        }
                    }
                    if firstComponentView_intarface2Left_convert != nil && secondComponentView_intarface3Right_convert != nil {
                        if (firstComponentView_intarface2Left_convert?.intersects(secondComponentView_intarface3Right_convert!))! {
                            if firstComponentView.neighborLeft2 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY + 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft2 = secondComponentView
                                secondComponentView.neighborRight3 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft2 = "neighborRight3"
                                secondComponentView.neighborInterfaceNameRight3 = "neighborLeft2"
                            }
                        }
                    }
                    
                    if firstComponentView_intarface3Left_convert != nil && secondComponentView_intarface1Right_convert != nil {
                        if (firstComponentView_intarface3Left_convert?.intersects(secondComponentView_intarface1Right_convert!))! {
                            if firstComponentView.neighborLeft3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY - 72,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft3 = secondComponentView
                                secondComponentView.neighborRight1 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft3 = "neighborRight1"
                                secondComponentView.neighborInterfaceNameRight1 = "neighborLeft3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Left_convert != nil && secondComponentView_intarface2Right_convert != nil {
                        if (firstComponentView_intarface3Left_convert?.intersects(secondComponentView_intarface2Right_convert!))! {
                            if firstComponentView.neighborLeft3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY - 35,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft3 = secondComponentView
                                secondComponentView.neighborRight2 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft3 = "neighborRight2"
                                secondComponentView.neighborInterfaceNameRight2 = "neighborLeft3"
                            }
                        }
                    }
                    if firstComponentView_intarface3Left_convert != nil && secondComponentView_intarface3Right_convert != nil {
                        if (firstComponentView_intarface3Left_convert?.intersects(secondComponentView_intarface3Right_convert!))! {
                            if firstComponentView.neighborLeft3 == nil {
                                firstComponentView.frame = CGRect(x: secondComponentView.frame.minX + 132 - w_bus,
                                                                  y: secondComponentView.frame.minY,
                                                                  width: 100, height: 100)
                                firstComponentView.neighborLeft3 = secondComponentView
                                secondComponentView.neighborRight3 = firstComponentView
                                firstComponentView.neighborInterfaceNameLeft3 = "neighborRight3"
                                secondComponentView.neighborInterfaceNameRight3 = "neighborLeft3"
                            }
                        }
                    }
                    
                }
				updatePosition()
            }
        }
    }
}



