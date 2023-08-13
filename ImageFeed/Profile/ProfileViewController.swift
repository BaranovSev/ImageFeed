//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 13.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak private var avararImage: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var logoutButton: UIButton!
    
    // MARK: - @IBActions
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
        //BTN tapped
    }
}
