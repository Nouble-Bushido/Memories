//
//  GalaryTableViewController.swift
//  Memories
//
//  Created by Артем Чжен on 04.09.2023.
//

import UIKit
import SnapKit
import CoreData

class GalleryTableViewController: UIViewController {
    // MARK: Properties
    private var viewModel: GalaryTableViewModel!
    private let cellName = "GalleryTableViewCell"
    
    //MARK:  GUI Properties
    private lazy var galaryTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Explore Your Collections"
        label.textColor = . black
        label.textAlignment = .center
        label.font = UIFont(name: "Marker Felt", size: 24)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add,
                                     target: self,
                                     action: #selector(buttonTapped))
        
        return button
    }()
    
    private lazy var galaryTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: view.frame.width,
                                                  height: view.frame.height),
                                    style: .plain)
        
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = view.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
   
        viewModel = GalaryTableViewModel(coreDataManager: CoreDataManager.instance)
        viewModel.fetchResultController.delegate = self
        viewModel.performFetch()
        setupUI()
        registerCell()
    }
    
    // MARK: Methods
    // регистрация ячейки
    private func registerCell() {
        galaryTableView.register(GalleryTableViewCell.self,
                                 forCellReuseIdentifier: cellName)
    }
    // настройка пользовательского интерфейса
    private func setupUI() {
        view.addSubview(galaryTitle)
        view.addSubview(galaryTableView)
        navigationItem.rightBarButtonItem = addButton
        
        setupGradientBackground()
        setupContstrains()
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
                                        blue: 0.4,
                                        alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.6)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // ограничения для интерфейса
    private func setupContstrains() {
        galaryTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().offset(10)
        }
        
        galaryTableView.snp.makeConstraints { make in
            make.top.equalTo(galaryTitle.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(20)
        }
    }
    
    //MARK: OBJC Method (нажатие на кнопку)
    @objc func buttonTapped() {
        present(viewModel.createAlbumEditorViewController(),
                animated: true,
                completion: nil)
    }
}

//MARK: - extension UITableViewDataSource
extension GalleryTableViewController: UITableViewDataSource {
    //кол-во секций в талице
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchResultController.sections?.count ?? 0
    }
    // кол-во строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    // создание и настройка таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName,
                                                       for: indexPath) as? GalleryTableViewCell else { return UITableViewCell() }
        let album = viewModel.album(at: indexPath)
        cell.galaryTitleLabel.text = album.title
        if let coverData = album.cover, let coverImage = UIImage(data: coverData) {
            cell.coverImageView.image = coverImage
            cell.coverImageView.contentMode = .scaleAspectFill
            cell.coverImageView.clipsToBounds = true
        } else {
            cell.coverImageView.image = UIImage(named: "default")
        }
        
        return cell
    }
}

//MARK: - Extension UITableViewDelegate
extension GalleryTableViewController: UITableViewDelegate {
    // обработка на нажатие ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = viewModel.album(at: indexPath)
        let albumViewController = viewModel.createAlbumViewController(with: selectedAlbum)
        navigationController?.pushViewController(albumViewController, animated: true)
    }
    // обработка удаления альбома
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteAlbum(at: indexPath)
        }
    }
}

//MARK: - extension NSFetchedResultsControllerDelegate
extension GalleryTableViewController: NSFetchedResultsControllerDelegate {
    // начать анимированные действия(подготавливает таблицу к отображению)
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        galaryTableView.beginUpdates()
    }
    // обработка изменений
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
            //добавляет новый объект
        case .insert:
            if let indexPath = newIndexPath {
                galaryTableView.insertRows(at: [indexPath], with: .automatic)
            }
            // обновляет
        case .update:
            if let indexPath = indexPath {
                let album = viewModel.album(at: indexPath)
                let cell = galaryTableView.cellForRow(at: indexPath) as? GalleryTableViewCell
                cell?.galaryTitleLabel.text = album.title
                if let coverImage = album.cover, let image = UIImage(data: coverImage) {
                    cell?.coverImageView.image = image
                } else {
                    cell?.coverImageView.image = UIImage(named: "default")
                }
            }
            // перемещает(удаляет нужную строку и вставляет ее в новую)
        case .move:
            if let indexPath = indexPath {
                galaryTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let indexPath = newIndexPath {
                galaryTableView.insertRows(at: [indexPath], with: .automatic)
            }
            // удаляет строку
        case .delete:
            if let indexPath = indexPath {
                galaryTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    // завершение обновления таблицы
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        galaryTableView.endUpdates()
    }
}
