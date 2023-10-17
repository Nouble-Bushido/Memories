//
//  AlbumEditorOrCreatorViewController.swift
//  Memories
//
//  Created by Артем Чжен on 05.09.2023.
//

import UIKit
import SnapKit
import PhotosUI

enum ActionType {
    case addCover
    case addToCollection
}

final class AlbumEditorOrCreatorViewController: UIViewController, UICollectionViewDelegate, PHPickerViewControllerDelegate {
    //MARK:  Properties
    var album: Album?
    var albumImages = [UIImage]()
    var updateAlbumData: (() -> Void)?
    private var currentActionType: ActionType?
    private var viewModel: AlbumEditorViewModel?
    private let cellName = "AlbumEditorOrCreatorCollectionViewCell"
    
    //MARK:  GUI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Upload and save your memories"
        label.textColor = . black
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 24)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var coverContainer: UIStackView = {
        let stackView = UIStackView()
        
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.backgroundColor = view.backgroundColor
        
        return stackView
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter Title"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .black
        
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter Description"
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .black
        
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var addCoverImageButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("add cover image", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addCoverImage), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var collectionContainer: UIStackView = {
        let stackView = UIStackView()
        
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.backgroundColor = view.backgroundColor
        
        return stackView
    }()
    
    private lazy var addPhotosImageButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("add album images", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addPhotos), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - (4 - 1) * 5) / 4
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: CGRect(x: 30,
                                                            y: 40,
                                                            width: view.frame.width,
                                                            height: view.frame.height),
                                              collectionViewLayout: layout)
        
        collectionView.backgroundColor = .systemFill
        collectionView.layer.cornerRadius = 10
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AlbumEditorViewModel(album: album)
        loadAlbumDataIntoEditor()
        setupNavigationBar()
        registerCell()
        setupUI()
    }
    
    //MARK:  Methods
    
    // регистрация ячейки
    private func registerCell() {
        photoCollectionView.register(AlbumEditorOrCreatorCollectionViewCell.self, forCellWithReuseIdentifier: cellName)
    }
    
    // настройка пользовательского интерфейса
    private func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(coverContainer)
        coverContainer.addSubview(coverImageView)
        coverContainer.addSubview(addCoverImageButton)
        view.addSubview(descriptionTextField)
        view.addSubview(collectionContainer)
        collectionContainer.addSubview(photoCollectionView)
        collectionContainer.addSubview(addPhotosImageButton)
        
        setupGradientBackground()
        setupConstraints()
    }
    
    // градиентный фон
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.2,
                                        green: 0.8,
                                        blue: 0.8,
                                        alpha: 1.0).cgColor,
                                UIColor(red: 0.0,
                                        green: 0.0,
                                        blue: 0.4, alpha: 1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.6)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // ограничения для интерфейса
    private func setupConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        coverContainer.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(coverContainer.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        
        addCoverImageButton.snp.makeConstraints { make in
            make.centerX.equalTo(coverImageView.snp.centerX)
            make.centerY.equalTo(coverImageView.snp.centerY)
        }
        
        collectionContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(280)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addPhotosImageButton.snp.top)
        }
        
        addPhotosImageButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // настройка энавигации бара
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveAlbum))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelEditing))
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    // загрузка данных альбома
    private func  loadAlbumDataIntoEditor() {
        titleTextField.text = viewModel?.album?.title
        descriptionTextField.text = viewModel?.album?.descriptionAlbum
        coverImageView.image = UIImage(data: viewModel?.album?.cover ?? Data ())
        albumImages = viewModel?.album?.photos?.compactMap { (photo) -> UIImage? in
            return UIImage(data: (photo as? Photos)?.photo ?? Data())
        } ?? []
    }
    
    //добавление обложки
    @objc func addCoverImage() {
        addMediaToAlbum(action: .addCover)
    }
    
    //добавление фото
    @objc func addPhotos() {
        addMediaToAlbum(action: .addToCollection)
    }
    
    //выбор фото
    private func addMediaToAlbum(action: ActionType) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = (action == .addCover) ? 1 : 0
        currentActionType = action
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //сохранение альбома
    @objc func saveAlbum() {
        if viewModel?.album == nil {
            viewModel?.album = Album(context: CoreDataManager.instance.context)
        }
        
        saveAlbumData()
        updateAlbumData?()
        CoreDataManager.instance.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    // обновление альбома
    private func saveAlbumData() {
        if let album = viewModel?.album {
            album.title = titleTextField.text
            album.descriptionAlbum = descriptionTextField.text
            
            if let existingPhotos = album.photos {
                album.removeFromPhotos(existingPhotos)
            }
            
            if let selectedImage = coverImageView.image {
                if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                    album.cover = imageData
                }
            }
            
            for image in albumImages {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let photo = Photos(context: CoreDataManager.instance.context)
                    photo.photo = imageData
                    photo.addToAlbum(album)
                }
            }
            CoreDataManager.instance.saveContext()
        }
    }
    
    //отмена редактирования
    @objc func cancelEditing() {
        dismiss(animated: true)
    }
    
    //завершение редактирование
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        switch currentActionType {
        case .addCover:
            if let selectedImage = results.first {
                processCoverImage(selectedImage)
            }
        case .addToCollection:
            processCollectionImages(results)
        case .none:
            break
        }
    }
    
    //обновление обложки
    private func processCoverImage(_ result: PHPickerResult) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let image = image as? UIImage, error == nil else { return print("Error")}
            
            DispatchQueue.main.async {
                self?.coverImageView.image = image
            }
            
            guard let album = self?.viewModel?.album  else { return print("Error") }
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return print("Error")}
            album.cover = imageData
        }
    }
    
    //обновление фото
    private func processCollectionImages(_ results: [PHPickerResult]) {
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                defer {
                    group.leave()
                }
                if let image = image as? UIImage, error == nil {
                    self?.albumImages.append(image)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.photoCollectionView.reloadData()
            if let albumViewController = self.presentedViewController as? AlbumViewController {
                albumViewController.photos = self.albumImages
            }
        }
    }
    
    //удаление фото
    func deletePhoto(at index: Int) {
        viewModel?.deletePhoto(at: index)
        albumImages.remove(at: index)
        CoreDataManager.instance.saveContext()
        photoCollectionView.reloadData()
    }
}

//MARK: - extension UICollectionViewDataSource
extension AlbumEditorOrCreatorViewController: UICollectionViewDataSource {
    
    //кол-во секций в коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumImages.count
    }
    
    // настройка и создание ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as? AlbumEditorOrCreatorCollectionViewCell else { return UICollectionViewCell()}
        cell.imageView.image = albumImages[indexPath.row]
        
        return cell
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? AlbumEditorOrCreatorCollectionViewCell else { return }
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.frame = CGRect(x: cell.bounds.width - 30, y: 5, width: 25, height: 25)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        deleteButton.tag = indexPath.row

        cell.addSubview(deleteButton)
    }
    
    //удаление фото
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        deletePhoto(at: index)
    }
}

//MARK: - extension UITextFieldDelegate
extension AlbumEditorOrCreatorViewController: UITextFieldDelegate {
    
    //скрытие клавиатуры
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
