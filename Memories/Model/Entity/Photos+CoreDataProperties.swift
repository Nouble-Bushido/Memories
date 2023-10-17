//
//  Photos+CoreDataProperties.swift
//  Memories
//
//  Created by Артем Чжен on 11.09.2023.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var photo: Data?
    @NSManaged public var album: NSSet?

}

// MARK: Generated accessors for album
extension Photos {

    @objc(addAlbumObject:)
    @NSManaged public func addToAlbum(_ value: Album)

    @objc(removeAlbumObject:)
    @NSManaged public func removeFromAlbum(_ value: Album)

    @objc(addAlbum:)
    @NSManaged public func addToAlbum(_ values: NSSet)

    @objc(removeAlbum:)
    @NSManaged public func removeFromAlbum(_ values: NSSet)

}

extension Photos : Identifiable {

}
