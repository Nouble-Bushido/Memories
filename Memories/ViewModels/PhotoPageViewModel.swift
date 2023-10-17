//
//  PhotoPageViewModel.swift
//  Memories
//
//  Created by Артем Чжен on 13.10.2023.
//

import UIKit

class PhotoPageViewModel {
    //MARK: Properties
    var albumImages: [UIImage] = []
    var selectedPhotoIndex: Int = 0

    //MARK: Methods
    func getPhotoAtIndex(_ index: Int) -> UIImage? {
        if index >= 0 && index < albumImages.count {
            return albumImages[index]
        }
        return nil
    }

    func numberOfPhotos() -> Int {
        return albumImages.count
    }
}
