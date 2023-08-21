//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 13.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        
        let nameLabel = UILabel()
            
        nameLabel.text = "Eкатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        let emailLabel = UILabel()
        
        emailLabel.text = "@ekaterina_nov"
        emailLabel.textColor = UIColor(named: "YP Gray (iOS)")
        emailLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        emailLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        let postLabel = UILabel()
        
        postLabel.text = "Hello, world!"
        postLabel.textColor = .white
        postLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postLabel)
        postLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        postLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        postLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8).isActive = true
        
        let button = UIButton.systemButton(with: UIImage(named: "logout_button")!,
                                           target: self,
                                           action:#selector(Self.didTapLogoutButton)
        )
        
        button.tintColor = UIColor(named: "YP Red (iOS)")
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc private func didTapLogoutButton(_ sender: UIButton) {
        //BTN tapped
    }
}
