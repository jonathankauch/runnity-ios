//
//  StatsViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 16/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class StatsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    @IBOutlet weak var kilometersLabel: UILabel!
    @IBOutlet weak var nbStepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var totalTimeRunLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStatList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu() {
        if revealViewController() != nil {
            menuBtn?.target = revealViewController()
            menuBtn?.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
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
    
    func preFillFields() {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .done
        return true
    }
    
    func getStatList() {
        let headers = [
            "X-User-Email" : UserSession.sharedInstance.email,
            "X-User-Token" : UserSession.sharedInstance.token
        ]

        // GET request on stats
        Alamofire.request("http://www.runit.fr/api/v1/stats",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)

                        debugPrint("Json vaut: ", json)
                        self.kilometersLabel.text = json["kms"].stringValue
                        self.nbStepsLabel.text = json["nb_steps"].stringValue
                        self.caloriesLabel.text = json["calories"].stringValue
                        self.maxSpeedLabel.text = json["max_speed"].stringValue
                        self.avgSpeedLabel.text = json["average_speed"].stringValue
                        self.totalTimeRunLabel.text = json["total_time_run"].stringValue
                    }
                case .failure(let error):
                    print("La requête a échoué: \(error)")
                }
        }
    }
}
