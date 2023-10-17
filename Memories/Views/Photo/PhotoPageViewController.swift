//
//  PhotoPageViewController.swift
//  Memories
//
//  Created by Артем Чжен on 13.10.2023.
//

import UIKit

class PhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    //MARK: Properties
    var viewModel: PhotoPageViewModel = PhotoPageViewModel()
    
    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        setInitialViewController()
    }

    //MARK: Methods
    //создание экземпля
    
   private func setInitialViewController() {
        if let initialPhotoViewController = getPhotoViewController(index: viewModel.selectedPhotoIndex) {
            setViewControllers([initialPhotoViewController], direction: .forward, animated: true)
        }
    }
    
    private func getPhotoViewController(index: Int) -> PhotoViewController? {
        if index >= 0 && index < viewModel.albumImages.count {
            let photoViewController = PhotoViewController()
            photoViewController.image = viewModel.albumImages[index]
            return photoViewController
        }
        return nil
    }

    // MARK: UIPageViewControllerDataSource
    //для получения предыдущего фото
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentPhotoViewController = viewController as? PhotoViewController {
            if let currentIndex = viewModel.albumImages.firstIndex(of: currentPhotoViewController.image ?? UIImage()) {
                let previousIndex = max(currentIndex - 1, 0)
             
                return getPhotoViewController(index: previousIndex)
            }
        }
        return nil
    }

    //для получения следующего фото
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentPhotoViewController = viewController as? PhotoViewController {
            if let currentIndex = viewModel.albumImages.firstIndex(of: currentPhotoViewController.image ?? UIImage()) {
                let nextIndex = min(currentIndex + 1, (viewModel.albumImages.count) - 1)
                return getPhotoViewController(index: nextIndex)
            }
        }
        return nil
    }
}
