//
//  HomePageViewController.swift
//  Memories
//
//  Created by Артем Чжен on 04.09.2023.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    //MARK: GUI Properties
    private lazy var topContainer: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var bottomContainer: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
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
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Memories Keeper"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var discriptionLabel: UILabel = {
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
        view.addSubview(topContainer)
        view.addSubview(bottomContainer)
        topContainer.addSubview(titleLabel)
        topContainer.addSubview(imageView)
        bottomContainer.addSubview(welcomeLabel)
        bottomContainer.addSubview(discriptionLabel)
        bottomContainer.addSubview(startButton)
        
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
    
    // ограничения для интерфейса (не нужно использовать констрейнты для элементов в Stack View)
    private func setupConstraints() {
        topContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).dividedBy(2)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(topContainer)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top).offset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
       
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        discriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    //переход в галерею
    @objc func getStarted() {
        navigationController?.pushViewController(GalleryTableViewController(), animated: true)
    }
}
