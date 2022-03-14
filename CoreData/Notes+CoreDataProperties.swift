//
//  Notes+CoreDataProperties.swift
//  NotesSwift
//
//  Created by Александр Джегутанов on 13.03.2022.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var date: Date?
    @NSManaged public var descriptionNotes: String?
    @NSManaged public var imageNotes: NSObject?
    @NSManaged public var tittelNotes: String?

}

extension Notes : Identifiable {

}
