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
	@NSManaged public var components: NSSet?
	@NSManaged public var interfaces: NSSet?
	@NSManaged public var neighborsTags : [Int64]
	@NSManaged public var setTimerTop: Bool
	@NSManaged public var setTimerButtom: Bool
	@NSManaged public var setTimerRight: Bool
	@NSManaged public var setTimerLeft: Bool
	@NSManaged public var neighborRight1: Component?
	@NSManaged public var neighborRight2: Component?
	@NSManaged public var neighborRight3: Component?
	@NSManaged public var neighborLeft1: Component?
	@NSManaged public var neighborLeft2: Component?
	@NSManaged public var neighborLeft3: Component?
	@NSManaged public var neighborTop1: Component?
	@NSManaged public var neighborTop2: Component?
	@NSManaged public var neighborTop3: Component?
	@NSManaged public var neighborButtom1: Component?
	@NSManaged public var neighborButtom2: Component?
	@NSManaged public var neighborButtom3: Component?
	@NSManaged public var neighborInterfaceNameTop1: String?
	@NSManaged public var neighborInterfaceNameTop3: String?
	@NSManaged public var neighborInterfaceNameTop2: String?
	@NSManaged public var neighborInterfaceNameButtom1: String?
	@NSManaged public var neighborInterfaceNameButtom2: String?
	@NSManaged public var neighborInterfaceNameButtom3: String?
	@NSManaged public var neighborInterfaceNameRight1: String?
	@NSManaged public var neighborInterfaceNameRight2: String?
	@NSManaged public var neighborInterfaceNameRight3: String?
	@NSManaged public var neighborInterfaceNameLeft1: String?
	@NSManaged public var neighborInterfaceNameLeft3: String?
	@NSManaged public var neighborInterfaceNameLeft2: String?
	
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
