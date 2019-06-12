//
//  DetailViewController.swift
//  freddit
//
//  Created by Francisco Gindre on 11/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: WebImageView!
    
    var detailItem: ListingItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    func configureView() {
        
        if let detail = detailItem {
            showAllSubViews()
            authorLabel.text = detail.author ?? "unknown author"
            titleLabel.text = detail.title ?? "unknown title"
            
            if let imagePath = detail.thumbnail, let url = URL(string: imagePath) {
                thumbnail.setImage(from: url)
            } else {
                thumbnail.setPlaceholderImage()
            }
            
        } else {
            hideAllSubviews()
            authorLabel.text = nil
            titleLabel.text = nil
            thumbnail.setPlaceholderImage()
        }
    }
    
    
    func showAllSubViews() {
        self.view.subviews.forEach({$0.isHidden = false})
    }
    
    func hideAllSubviews() {
        self.view.subviews.forEach({$0.isHidden = true})
    }
    
    // MARK: Life cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBlackBarTheme()
        configureView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage(_:)))
        thumbnail.addGestureRecognizer(tapGesture)
        thumbnail.isUserInteractionEnabled = true
    }

    @objc func didTapImage(_ gesture: UITapGestureRecognizer) {
        guard let detail = detailItem, ListingVisitor.image(for: detail) != nil else {
            print("WARNING: NO FULL SIZE FOR THUMBNAIL")
            return
        }
        
        performSegue(withIdentifier: "ShowImageDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destinationNav = segue.destination as? UINavigationController,
            let destinationVC = destinationNav.viewControllers.first as? ImageDetailViewController,
            let detail = detailItem,
            let imageItem = ListingVisitor.image(for: detail),
            let url = URL(string: imageItem.url) {
            destinationVC.imageURL = url
        }
    }
}

