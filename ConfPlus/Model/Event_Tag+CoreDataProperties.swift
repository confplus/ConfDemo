//
//  Event_Tag+CoreDataProperties.swift
//  
//
//  Created by Matthew Boroczky on 1/05/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event_Tag {

    @NSManaged var tag_name: String?
    @NSManaged var event: Event?

}
