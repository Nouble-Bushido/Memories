//
//  HomePageViewController.swift
//  Memories
//
//  Created by Артем Чжен on 04.09.2023.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    //MARK: - GUI Properties
    private lazy var memoriesTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Memories"
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Marker Felt", size: 40)
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Discovery")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var textLabelWelcome: UILabel = {
        let label = UILabel()
        
        label.text = "Welcome to Memories Keeper"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var discriptionTextLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Memories Keeper is your personal vault for treasured moments. Whether it's a thrilling adventure, a heartfelt gathering, or a simple day worth remembering, this app is designed to capture and cherish them all. Relive your experiences, share your stories, and create a digital treasure chest of your most meaningful memories."
        label.textColor = .black
        label.font = UIFont(name: "Noteworthy", size: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: Methods
    // настройка пользовательского интерфейса
    private func setupUI() {
        view.addSubview(memoriesTitle)
        view.addSubview(imageView)
        view.addSubview(textLabelWelcome)
        view.addSubview(discriptionTextLabel)
        view.addSubview(startButton)
        
        view.backgroundColor = .systemCyan
        setupGradientBackground()
        setupConstraints()
    }
    
    // градиентный фон
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.2, green: 0.8, blue: 0.8, alpha: 1.0).cgColor, UIColor(red: 0.0, green: 0.0, blue: 0.4, alpha: 1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.6)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // ограничения для интерфейса
    private func setupConstraints() {
        memoriesTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(memoriesTitle.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        textLabelWelcome.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).inset(5)
            make.leading.equalToSuperview().offset(30)
        }
        
        discriptionTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabelWelcome.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(40)
            make.width.equalTo(300)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(discriptionTextLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    
    //переход на в галлерею
    @objc func getStarted() {
        navigationController?.pushViewController(GalleryTableViewController(), animated: true)
    }
}
