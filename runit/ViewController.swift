//
//  ViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 29/10/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var alertBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideMenu()
        customNavBar()
        customView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu() {
        if revealViewController != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            alertBtn.target = revealViewController()
            alertBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            alertBtn.isEnabled = false
            alertBtn.tintColor = .clear
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }
    
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }
}

