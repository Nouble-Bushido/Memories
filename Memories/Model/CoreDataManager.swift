//
//  CoreDataManager.swift
//  Memories
//
//  Created by Артем Чжен on 06.09.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    
    // MARK:  Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Memories")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK:  Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
