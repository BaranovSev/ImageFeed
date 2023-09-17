//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 13.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var imageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Eкатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "@ekaterina_nov"
        emailLabel.textColor = UIColor(named: "YP Gray (iOS)")
        emailLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        return emailLabel
    }()
    
    private var postLabel: UILabel = {
        let postLabel = UILabel()
        postLabel.text = "Hello, world!"
        postLabel.textColor = .white
        postLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        return postLabel
    }()
    
    private var button: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "logout_button") ?? UIImage(),
                                           target: ProfileViewController.self,
                                           action:#selector(Self.didTapLogoutButton)
        )
        
        button.tintColor = UIColor(named: "YP Red (iOS)")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ProfileViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        applyConstraints()
        
        guard let profile = profileService.profile else {
            print("empty profile")
            return
        }
        
        updateProfileDetails(profile: profile)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Methods
    private func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(postLabel)
        view.addSubview(button)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            emailLabel.heightAnchor.constraint(equalToConstant: 18),
            emailLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            postLabel.heightAnchor.constraint(equalToConstant: 18),
            postLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            postLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),

            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    @objc private func didTapLogoutButton(_ sender: UIButton) {
        //BTN tapped
    }
    
    private func updateProfileDetails(profile: Profile) {
        // TODO: self.imageView.image =
        self.nameLabel.text = profile.name
        self.emailLabel.text = profile.loginName
        self.postLabel.text = profile.bio
    }
}
