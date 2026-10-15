//
//  Mot+CoreDataProperties.swift
//  MilleMots
//
//  Created by Simon Wintz on 25/03/2024.
//
//

import Foundation
import CoreData


extension Mot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mot> {
        return NSFetchRequest<Mot>(entityName: "Mot")
    }

    @NSManaged public var baseActive: Bool
    @NSManaged public var graphie: String?
    @NSManaged public var motMort: Bool
    @NSManaged public var nChrono: Int32
    @NSManaged public var nEchec: Int16
    @NSManaged public var nEssai: Int16
    @NSManaged public var nSession: Int16
    @NSManaged public var sqSucces: Int16
    @NSManaged public var txErr: Float
    @NSManaged public var definition: Definition?

}
