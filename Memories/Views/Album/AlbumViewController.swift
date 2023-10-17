//
//  AlbumViewController.swift
//  Memories
//
//  Created by Артем Чжен on 05.09.2023.
//

import UIKit
import SnapKit

class AlbumViewController: UIViewController, UICollectionViewDelegate {
    //MARK: Properties
    var album: Album?
    var photos: [UIImage]?
    var viewModel: AlbumViewModel!
    private let cellName = "AlbumCollectionViewCell"
    
    //MARK:  GUI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = . black
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 28)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose,
                                     target: self,
                                     action: #selector(editButtonTapped))
        return button
    }()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Noteworthy", size: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - (4 - 1) * 5) / 4
        
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: CGRect(x: 30,
                                                            y: 30,
                                                            width: view.frame.width,
                                                            height: view.frame.height),
                                              collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 10
        collectionView.backgroundColor = view.backgroundColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AlbumViewModel(album: album)
        setupViewModelHandlers()
        viewModel?.loadAlbumData()
        registerCollection()
        setupUI()
    }
    
    //MARK: Methods
    // регистрация ячейки
    private func registerCollection() {
        collectionView.register(AlbumCollectionViewCell.self,
                                     forCellWithReuseIdentifier: cellName)
    }
    
    // настройка пользовательского интерфейса
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(coverImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(collectionView)
        view.backgroundColor = .systemCyan
        
        navigationItem.rightBarButtonItem = editBarButtonItem
        setupContstrains()
        setupGradientBackground()
    }
    
    // градиентный фон
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.2,
                                        green: 0.8,
                                        blue: 0.8,
                                        alpha: 1.0).cgColor, UIColor(red: 0.0,
                                                                     green: 0.0,
                                                                     blue: 0.4,
                                                                     alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.6)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // ограничения для интерфейса
    private func setupContstrains() {
        coverImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().offset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    // обработка обложки, тайтла, фото
    func setupViewModelHandlers() {
        viewModel?.coverImageHandler = { [weak self] image in
            self?.coverImageView.image = image
        }

        viewModel?.albumInfoHandler = { [weak self] title, description in
            self?.titleLabel.text = title
            self?.descriptionLabel.text = description
        }

        viewModel?.photosHandler = { [weak self] photos in
            self?.photos = photos
            self?.collectionView.reloadData()
        }
    }
    
    // редактирование альбома
    @objc func editButtonTapped() {
        let isEditingMode = !isEditing
        setEditing(isEditingMode, animated: true)
        
        viewModel?.albumEditorViewController.album = viewModel?.album
        viewModel?.albumEditorViewController.updateAlbumData = { [weak self] in
            self?.viewModel?.loadAlbumData()
        }
        
        let navigationController = UINavigationController(rootViewController: viewModel?.albumEditorViewController ?? AlbumEditorOrCreatorViewController())
        present(navigationController, animated: true)
    }
}

//MARK: - extension UICollectionViewDataSource
extension AlbumViewController: UICollectionViewDataSource {
    
    //кол-во секций в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.album?.photos?.count ?? 0
    }
    
    // настройка и создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! AlbumCollectionViewCell
        
        if let photos = photos, indexPath.row < photos.count {
            let photo = photos[indexPath.row]
            cell.imageView.image = photo
        }
        
        return cell
    }
    
    // действия при выборе ячейки
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photos = photos, indexPath.row < photos.count {
            let selectedPhotoIndex = indexPath.row
            
            let photoPageViewModel = PhotoPageViewModel()
            photoPageViewModel.albumImages = photos
            photoPageViewModel.selectedPhotoIndex = selectedPhotoIndex
            
            let photoPageVC = PhotoPageViewController()
            photoPageVC.viewModel = photoPageViewModel
            navigationController?.pushViewController(photoPageVC, animated: true)
        }
    }
}
