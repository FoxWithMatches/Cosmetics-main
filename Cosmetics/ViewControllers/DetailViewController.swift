//
//  DetailViewController.swift
//  Cosmetics
//
//  Created by Alisa Ts on 30.11.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var makeUpDescriptionLabel: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var dataMakeUp: MakeUpElement!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        guard let brand = dataMakeUp?.brand?.capitalized else { return }
        guard let name = dataMakeUp?.name else { return }
        navigationItem.title = brand
        brandLabel.text = name
        
        guard let price = dataMakeUp?.price else { return }
        priceLabel.text = "\(price)$"
        
        guard let description = dataMakeUp?.makeUpDescription else { return }
        makeUpDescriptionLabel.text = description
        
        DispatchQueue.global().async {
            guard let imageData = ImageManager.shared.fetchImage(from: self.dataMakeUp.imageLink) else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
