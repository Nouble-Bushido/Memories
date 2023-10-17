//
//  Album+CoreDataProperties.swift
//  Memories
//
//  Created by Артем Чжен on 11.09.2023.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var cover: Data?
    @NSManaged public var descriptionAlbum: String?
    @NSManaged public var title: String?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Album {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension Album : Identifiable {

}
