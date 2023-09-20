//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 20.09.2023.
//

import UIKit

class AlertPresenter {
    weak var onViewController: UIViewController?
    
    func showAlert(alertError result: Error) {
        var title = "Error"
        var message = result.localizedDescription
        if result is NetworkError {
            title = "Что-то пошло не так("
            message = "Не удалось войти в систему"
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(action)
        onViewController?.present(alert, animated: true, completion: nil)
    }
    
    init(onViewController: UIViewController) {
        self.onViewController = onViewController
    }
}
