//
//  GalaryTableViewModel.swift
//  Memories
//
//  Created by Артем Чжен on 19.09.2023.
//

import UIKit
import CoreData

final class GalaryTableViewModel {
    // Properties
    private let coreDataManager: CoreDataManager
    private let entityName = "Album"
    private let title = "title"
    
    lazy var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        let  sortDescriptor = NSSortDescriptor(key: self.title, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultController
    }()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    // Methdos
    //вызывает performFetch запрос данных к CoreData
    func performFetch() {
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
    // создание и возврат экземлп. альбома AlbumEditorViewController
    func createAlbumEditorViewController() -> UIViewController {
        let albumEditorViewController = AlbumEditorOrCreatorViewController()
        albumEditorViewController.updateAlbumData = { [weak self] in
            self?.performFetch()
        }
        let navigationController = UINavigationController(rootViewController: albumEditorViewController)
        
        return navigationController
    }
    // получает из CoreData Album
    func album(at indexPath: IndexPath) -> Album {
        return fetchResultController.object(at: indexPath) as! Album
    }
    // создание и возврат экземлп. альбома AlbumViewController
    func createAlbumViewController(with album: Album) -> UIViewController {
        let albumViewController = AlbumViewController()
        albumViewController.album = album
        
        return albumViewController
    }
    
    // удаляет альбом
    func deleteAlbum(at indexPath: IndexPath) {
        let album = album(at: indexPath)
        CoreDataManager.instance.context.delete(album)
        CoreDataManager.instance.saveContext()
    }
}
