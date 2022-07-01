//
//  BlindViewController.swift
//  MapExplorer
//
//  Created by Ilya on 01.07.2022.
//

import UIKit

class BlindViewController: UIViewController {

    /// Информативная картинка
    private let mainImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "topsecret.jpg"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mainImage)
    }
    
    override func viewDidLayoutSubviews() {
        mainImage.frame = self.view.bounds
    }
    
}
