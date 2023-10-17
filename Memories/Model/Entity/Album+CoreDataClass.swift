//
//  Album+CoreDataClass.swift
//  Memories
//
//  Created by Артем Чжен on 11.09.2023.
//
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Album"), insertInto: CoreDataManager.instance.context)
    }
}
