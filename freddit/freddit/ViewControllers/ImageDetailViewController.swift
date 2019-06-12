//
//  ImageDetailViewController.swift
//  freddit
//
//  Created by Francisco Gindre on 12/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: WebImageView!
    var imageURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBlackBarTheme()
        self.title = "Image Detail"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed(_:)))
        guard let url = imageURL else { return }
        imageView.setImage(from: url)
    }
    
    @objc func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
