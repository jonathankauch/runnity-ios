//
//  ViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: RIAlert.OK,
                                      style: .default,
                                      handler: { (action) in
                                        alert.dismiss(animated: true,
                                                      completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func assignBackground() {
        let background = UIImage(named: RIAsset.BACKGROUND)
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
}
