//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Stepan Baranov on 15.08.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
