//
//  XFProjectViewController.swift
//  xFixes
//
//  Created by Ryad on 24.07.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

protocol ProjectViewDelegate: class {
    func show(project: ProjectView)
    func delete(project: ProjectView)
}

class ProjectView : UIView  {
    var delegate: ProjectViewDelegate?
    var projectName: String? { didSet { setNeedsDisplay() } }
    var txtField: UITextField!
    
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
        
        txtField = UITextField(frame: CGRect(x: 0, y: 10, width: 170, height: 50))
        txtField.text = "Project Name"
        txtField.adjustsFontSizeToFitWidth = true
        txtField.textAlignment = .center
        txtField.font = UIFont.boldSystemFont(ofSize: 18)
        txtField.textColor = UIColor.darkText
        txtField.backgroundColor = UIColor.brown
        txtField.tintColor = UIColor.clear
        addSubview(txtField)
    }
    
    func initGestureRecognizers() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR: )))
        addGestureRecognizer(tapGR)
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(LongPressGR: )))
        addGestureRecognizer(longPressGR)
        
    }
    
    func show(project: ProjectView) {
        delegate?.show(project: project)
    }
    
    func delete(project: ProjectView) {
        delegate?.delete(project: project)
    }
    
    func didTap(tapGR: UITapGestureRecognizer) {
        show(project: self)
    }
    
    func didLongPress(LongPressGR: UILongPressGestureRecognizer) {
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

class XFProjectViewController: UICollectionViewController, ProjectViewDelegate {
    
    var projects = [ProjectView]()
    var projectsMainviewcontroller = [XFMainViewController]()
    var x_coordinate = 0
    var y_coordinate = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.backgroundColor = UIColor(hue: 210/360, saturation: 0/100, brightness: 97/100, alpha: 1.0)
        self.view.addSubview(collectionView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("XFProjectViewController - viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("XFProjectViewController - viewWillDisappear")
    }
    
    func getRandomColor() -> UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    @IBAction func addProjectButton(_ sender: UIBarButtonItem) {
        if projects.count < 55 {
            x_coordinate = 5 + (185 * (projects.count % 5))
            y_coordinate = 5 + (185 * (projects.count / 5))
            
            let project = ProjectView(frame: CGRect(x: x_coordinate, y: y_coordinate, width: 180, height: 180))
            collectionView?.addSubview(project)
            project.delegate = self
            projects.append(project)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "XFMainViewController")
            projectsMainviewcontroller.append(controller as! XFMainViewController)
        }
    }
    
    func show(project: ProjectView) {
        var i = 0
        for p in projects {
            if p == project {
                projectsMainviewcontroller[i].title = projects[i].txtField.text
                self.navigationController?.pushViewController(projectsMainviewcontroller[i], animated: true)
                break
            }
            i+=1
        }
    }
    
    func delete(project: ProjectView) {
        var found = false
        let alertController = UIAlertController(title: project.txtField.text,
                                                message: "Möchten Sie das Projekt löschen?",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            project.removeFromSuperview()
            var i = 0
            for p in self.projects {
                if p == project {
                    found = true
                    break
                }
                i+=1
            }
            if found {
                found = false
                
                for j in stride(from: self.projects.count-1, to: i, by: -1) {
                    self.projects[j].frame = self.projects[j-1].frame
                }
                self.projects.remove(at: i)
                self.projectsMainviewcontroller.remove(at: i)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 204
    }
    
    var cellColor = true
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as UICollectionViewCell
        return cell
    }
 
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
