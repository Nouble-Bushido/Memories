//
//  GalaryTableViewCell.swift
//  Memories
//
//  Created by Артем Чжен on 05.09.2023.
//

import UIKit
import SnapKit

class GalleryTableViewCell: UITableViewCell {
    //MARK: GUI Properties
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
    lazy var galaryTitleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = . white
        label.textAlignment = .left
        label.font = UIFont(name: "Noteworthy", size: 30)
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
     lazy var lineView: UIView = {
        let line = UIView()
        
        line.backgroundColor = .systemCyan
        
        return line
    }()
    
    //MARK: Lyfe cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    // настройка пользовательского интерфейса
    private func setupUI() {
        addSubview(containerStackView)
        containerStackView.addSubview(coverImageView)
        containerStackView.addSubview(galaryTitleLabel)
        containerStackView.addSubview(lineView)
        
        setupConstraints()
    }
    
    // ограничения для интерфейса
    private func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        galaryTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalTo(lineView.snp.top).offset(-10)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
    }
}
