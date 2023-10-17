//
//  AlbumViewModel.swift
//  Memories
//
//  Created by Артем Чжен on 21.09.2023.
//

import UIKit

class AlbumViewModel {
    //MARK: Properties
    var album: Album?
    var coverImageHandler: ((UIImage?) -> Void)?
    var albumInfoHandler: ((String?, String?) -> Void)?
    var photosHandler: (([UIImage]) -> Void)?
    let albumEditorViewController = AlbumEditorOrCreatorViewController()
    
    init(album: Album? = nil) {
        self.album = album
    }
    
    // загрузка из альбома
    func loadAlbumData() {
        guard let album = album, let albumPhotos = album.photos as? Set<Photos> else { return }
        
        loadCoverImage(album: album)
        updateAlbumInfo(album: album)
        
        let images = loadPhotos(from: albumPhotos)
        updatePhotos(images: images)
    }
    
    // загрузка обложки
    private func loadCoverImage(album: Album)  {
        guard let imageData = album.cover, let image = UIImage(data: imageData) else { return }
        coverImageHandler?(image)
    }
    
    // загрузка тайтл, описание
    private func updateAlbumInfo(album: Album) {
        albumInfoHandler?(album.title, album.descriptionAlbum)
    }
    
    // загрузка фото
    private func loadPhotos(from albumPhotos: Set<Photos>) -> [UIImage] {
        let photosArray = Array(albumPhotos)
        let images = photosArray.compactMap { (photo: Photos) -> UIImage? in
            guard let photoData = photo.photo, let image = UIImage(data: photoData) else {
                return nil
            }
            return image
        }
        return images
    }
    
    // обновление фото
    private func updatePhotos(images: [UIImage]) {
        photosHandler?(images)
    }
}
