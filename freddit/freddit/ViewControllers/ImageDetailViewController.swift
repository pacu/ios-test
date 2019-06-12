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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed(_:)))
        
        let save = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(savePressed(_:)))
        save.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = save
        guard let url = imageURL else { return }
        
        imageView.setImage(from: url) { (success) in
            save.isEnabled = success
        }
    }
    
    @objc func donePressed(_ sender: Any) {
        imageView.cancelTask()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func savePressed(_ sender: Any) {
        guard let image = imageView.image else {
            print("❌ error: unable to get image from image view")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image,
                                        self,
                                        #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                        nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            let alertController = UIAlertController(title: "Error saving image", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Image Saved!", message: "The image has been saved to your camera roll", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
}
