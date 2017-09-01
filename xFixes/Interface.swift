//
//  Interface+CoreDataClass.swift
//  xFixes
//
//  Created by Ryad on 27.08.17.
//  Copyright © 2017 Ryad. All rights reserved.
//
//

import Foundation
import CoreData


public class Interface: NSManagedObject {

}

extension Interface {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Interface> {
		return NSFetchRequest<Interface>(entityName: "Interface")
	}
	
	@NSManaged public var position: String?
	@NSManaged public var type: String?
	@NSManaged public var unique: String?
	@NSManaged public var minX: Float
	@NSManaged public var minY: Float
	@NSManaged public var width: Float
	@NSManaged public var height: Float
	@NSManaged public var orient: Float
	@NSManaged public var component: Component?
	
}
