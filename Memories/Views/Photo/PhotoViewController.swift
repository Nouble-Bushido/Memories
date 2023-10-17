//
//  PhotoViewController2.swift
//  Memories
//
//  Created by Артем Чжен on 13.10.2023.
//

import UIKit
import SnapKit

class PhotoViewController: UIViewController {
    //MARK: Properties
    var image: UIImage?

    //MARK:  GUI Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        return imageView
    }()

    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: Methods
    // настройка пользовательского интерфейса
    private func setupUI() {
        view.addSubview(imageView)
        setupConstraints()
    }
    
    // ограничения для интерфейса
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
