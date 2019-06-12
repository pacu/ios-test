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
    @IBOutlet weak var thumbnail: UIImageView!
    
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
            thumbnail.setPlaceholderImage()
        } else {
            hideAllSubviews()
            authorLabel.text = nil
            titleLabel.text = nil
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
    }

   


}

