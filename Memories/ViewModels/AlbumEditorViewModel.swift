//
//  AlbumEditorViewModel.swift
//  Memories
//
//  Created by Артем Чжен on 20.09.2023.
//

import UIKit
import PhotosUI

class AlbumEditorViewModel {
    var album: Album?
    private var currentAction: ActionType?
    
    init(album: Album? = nil) {
        self.album = album
    }
    
    var albumPhotos: [UIImage] {
        if let albumPhotos = album?.photos as? Set<Photos> {
            return albumPhotos.compactMap { UIImage(data: $0.photo ?? Data()) }
        }
        return []
    }
    
    func deletePhoto(at index: Int) {
        if index >= 0 && index < albumPhotos.count {
            if let album = album {
                if let imagesToDelete = album.photos?.allObjects as? [Photos], index < imagesToDelete.count {
                    let imageToDelete = imagesToDelete[index]
                    
                    CoreDataManager.instance.context.delete(imageToDelete)
                    album.removeFromPhotos(imageToDelete)
                    CoreDataManager.instance.saveContext()
                }
            }
        }
    }
}

