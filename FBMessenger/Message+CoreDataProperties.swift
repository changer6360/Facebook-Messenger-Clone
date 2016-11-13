//
//  Message+CoreDataProperties.swift
//  FBMessenger
//
//  Created by Tihomir Videnov on 11/13/16.
//  Copyright © 2016 Tihomir Videnov. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var friend: Friend?

}
