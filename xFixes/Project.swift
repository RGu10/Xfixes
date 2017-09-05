//
//  Project+CoreDataClass.swift
//  xFixes
//
//  Created by Ryad on 03.09.17.
//  Copyright © 2017 Ryad. All rights reserved.
//
//

import Foundation
import CoreData


public class Project: NSManagedObject {

}

extension Project {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
		return NSFetchRequest<Project>(entityName: "Project")
	}
	
	@NSManaged public var tag: Int16
	@NSManaged public var titleField: NSObject?
	@NSManaged public var minX: Float
	@NSManaged public var minY: Float
	
}
