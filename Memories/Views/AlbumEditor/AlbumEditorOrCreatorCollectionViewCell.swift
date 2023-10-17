//
//  AlbumEditorCollectionViewCell.swift
//  Memories
//
//  Created by Артем Чжен on 05.09.2023.
//

import UIKit
import SnapKit

final class AlbumEditorOrCreatorCollectionViewCell: UICollectionViewCell {
    //MARK:  GUI Properties
      var imageView: UIImageView = {
       let image = UIImageView()
        
        return image
    }()
    
    //MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    // настройка пользовательского интерфейса
    private func setupUI(){
        addSubview(imageView)
        setupConstraints()
    }
    
    // ограничения для интерфейса
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
