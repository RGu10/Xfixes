//
//  XFProjectViewController.swift
//  xFixes
//
//  Created by Ryad on 24.07.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class XFProjectViewController: UICollectionViewController, ProjectViewDelegate {
    
    var projects = [XFProjectView]()
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
            
            let project = XFProjectView(frame: CGRect(x: x_coordinate, y: y_coordinate, width: 180, height: 180))
            collectionView?.addSubview(project)
            project.delegate = self
            projects.append(project)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "XFMainViewController")
            projectsMainviewcontroller.append(controller as! XFMainViewController)
        }
    }
    
    func show(project: XFProjectView) {
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
    
    func delete(project: XFProjectView) {
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
