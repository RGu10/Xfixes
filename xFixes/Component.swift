//
//  Component+CoreDataClass.swift
//  xFixes
//
//  Created by Ryad on 27.08.17.
//  Copyright © 2017 Ryad. All rights reserved.
//
//

import Foundation
import CoreData

public class Component: NSManagedObject {

}

extension Component {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Component> {
		return NSFetchRequest<Component>(entityName: "Component")
	}
	
	@NSManaged public var color: NSObject?
	@NSManaged public var height: Float
	@NSManaged public var minX: Float
	@NSManaged public var minY: Float
	@NSManaged public var tag: Int64
	@NSManaged public var title: String?
	@NSManaged public var type: String?
	@NSManaged public var width: Float
	@NSManaged public var interfaces: NSSet?
	@NSManaged public var components: NSSet?
	
}

// MARK: Generated accessors for interfaces
extension Component {
	
	@objc(addInterfacesObject:)
	@NSManaged public func addToInterfaces(_ value: Interface)
	
	@objc(removeInterfacesObject:)
	@NSManaged public func removeFromInterfaces(_ value: Interface)
	
	@objc(addInterfaces:)
	@NSManaged public func addToInterfaces(_ values: NSSet)
	
	@objc(removeInterfaces:)
	@NSManaged public func removeFromInterfaces(_ values: NSSet)
	
}

// MARK: Generated accessors for components
extension Component {
	
	@objc(addComponentsObject:)
	@NSManaged public func addToComponents(_ value: Component)
	
	@objc(removeComponentsObject:)
	@NSManaged public func removeFromComponents(_ value: Component)
	
	@objc(addComponents:)
	@NSManaged public func addToComponents(_ values: NSSet)
	
	@objc(removeComponents:)
	@NSManaged public func removeFromComponents(_ values: NSSet)
	
}

