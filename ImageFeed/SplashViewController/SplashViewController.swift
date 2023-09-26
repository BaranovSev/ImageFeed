//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 07.09.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var imageView: UIImageView = {
        let splashImage = UIImage(named: "Vector")
        let imageView = UIImageView(image: splashImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let token = OAuth2TokenStorage().token else {
            guard let viewController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
                return
            }
            
            viewController.delegate = self
            viewController.modalPresentationStyle = .fullScreen
            
            present(viewController, animated: false)
            return
        }
            self.switchToTabBarController()
            self.fetchProfile(token: token)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureScreen() {
        view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                imageView.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid configuration")
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchAuthToken(code)
        }
    }
    
    func fetchAuthToken(_ code: String) {
        OAuth2Service.shared.fetchAuthToken(code){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.switchToTabBarController()
                self.fetchProfile(token: token.accessToken)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                AlertPresenter(onViewController: self).showAlert(alertError: error)
                assertionFailure(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                self.fetchProfileImageURL(username: profile.username)
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                AlertPresenter(onViewController: self).showAlert(alertError: error)
                assertionFailure(error.localizedDescription)
                break
            }
        }
    }
    
    func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(username: username){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let succes):
                let avatarURL = succes
                //TODO: need to load image
            case .failure(let error):
                AlertPresenter(onViewController: self).showAlert(alertError: error)
                print(error.localizedDescription)
            }
        }
    }
}

