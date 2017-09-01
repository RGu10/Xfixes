//
//  XFDataBase.swift
//  xFixes
//
//  Created by Ryad on 24.08.17.
//  Copyright © 2017 Ryad. All rights reserved.
//

import Foundation
import CoreData

class XFDataBaseManager {
	
	let managedContext: NSManagedObjectContext?
	var componentList: [Component] = []
	let fetchRequest: NSFetchRequest<Component>?
	var idListCoreData: [NSManagedObject] = []
	let fetchRequestIdList: NSFetchRequest<NSManagedObject>?
	
	init(appDelegate: AppDelegate) {
		if #available(iOS 10.0, *) {
			managedContext = appDelegate.persistentContainer.viewContext
		} else {
			managedContext = appDelegate.managedObjectContext
		}
	    fetchRequest = NSFetchRequest<Component>(entityName: "Component")
		fetchRequestIdList = NSFetchRequest<NSManagedObject>(entityName: "IdList")
		
		do {
			componentList = (try managedContext?.fetch(fetchRequest!))!
			idListCoreData = (try managedContext?.fetch(fetchRequestIdList!))!
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
	}
	
	func saveContext(){
		do {
			try managedContext?.save()
		} catch let error as NSError {
			print("Could not save. \(error), \(error.userInfo)")
		}
	}
	
	func contains(id: Int64) -> Bool{
		for e in idListCoreData {
			let idInCoreData = e.value(forKey: "id") as? Int64
			if idInCoreData == id {
			   return true
			}
		}
		return false
	}
	
	private func InsertId(id: Int64){
		let entity = NSEntityDescription.entity(forEntityName: "IdList", in: managedContext!)!
		let v = NSManagedObject(entity: entity, insertInto: managedContext)
		v.setValue(id , forKeyPath: "id")
		if !idListCoreData.contains(v) {
			idListCoreData.append(v)
		}
		saveContext()
	}
	
	private func DeleteId(id: Int64){
		for e in idListCoreData {
			let idInCoreData = e.value(forKey: "id") as? Int64
			if idInCoreData == id {
				managedContext?.delete(e)
			}
			saveContext()
		}
	}
		
	func Select(component: XFComponentView) -> Component? {
		for tmpComponent in componentList {
			if tmpComponent.tag == component.tag {
				return tmpComponent
			}
		}
		return nil
	}
	
	func Update(component: XFComponentView, key: String) {
			for v in componentList {
				let tmp = v.value(forKey: "tag") as? Int
				if tmp != nil {
					if tmp! == component.tag {
						switch key {
						case "title":
							v.title = component.titleField.text
							saveContext()
						case "color":
							v.color = component.fillColor
							saveContext()
						case "position":
							v.minX = Float(component.frame.minX)
							v.minY = Float(component.frame.minY)
							saveContext()
						case "interface":
							//v.interfaces
							saveContext()
						default:
							break
						}
					}
				}
			}
	}
	
	func Delete(component: XFComponentView){
		for v in componentList {
			let tmp = v.value(forKey: "tag") as? Int
			if (tmp == component.tag) {
				managedContext?.delete(v)
				DeleteId(id: Int64(component.tag))
			}
				
			saveContext()
		}
	}
	
	func resetDatabase(){
		for v in componentList {
			managedContext!.delete(v)
		}
		for v in idListCoreData {
			managedContext!.delete(v)
		}
		saveContext()
	}
	
	func printDataBaseSatatistics(){
		for v in componentList {
			print(v)
		}
	}
	
}
