//
//  Definition+CoreDataProperties.swift
//  MilleMots
//
//  Created by Simon Wintz on 25/03/2024.
//
//

import Foundation
import CoreData


extension Definition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Definition> {
        return NSFetchRequest<Definition>(entityName: "Definition")
    }

    @NSManaged public var enonce: String?
    @NSManaged public var graphies: NSSet?

}

// MARK: Generated accessors for graphies
extension Definition {

    @objc(addGraphiesObject:)
    @NSManaged public func addToGraphies(_ value: Mot)

    @objc(removeGraphiesObject:)
    @NSManaged public func removeFromGraphies(_ value: Mot)

    @objc(addGraphies:)
    @NSManaged public func addToGraphies(_ values: NSSet)

    @objc(removeGraphies:)
    @NSManaged public func removeFromGraphies(_ values: NSSet)

}

extension Definition : Identifiable {

}
