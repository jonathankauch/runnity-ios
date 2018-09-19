//
//  RankingViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 19/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class SpeedCell : UITableViewCell {
    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var SpeedWeight: UILabel!
    @IBOutlet weak var SpeedSpeed: UILabel!
}

class RankingViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var SpeedTV: UITableView!
    
    struct SpeedData {
        let firstname : String
        let lastname : String
        let weight : String
        let average_speed : String
    }
    
    var speedArray = [SpeedData]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return speedArray.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0; //Choose your custom row height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let speedcell = tableView.dequeueReusableCell(withIdentifier: "speedcell", for: indexPath) as! SpeedCell
        
        speedcell.SpeedLabel.text = String(indexPath.row + 1) + ". "
            + speedArray[indexPath.row].firstname + " "
            + speedArray[indexPath.row].lastname
        
        speedcell.SpeedWeight.text = "Poids : " + speedArray[indexPath.row].weight + " kg"
        
        speedcell.SpeedSpeed.text = "Vitesse : " + speedArray[indexPath.row].average_speed + " km/h"

        speedcell.backgroundColor = UIColor.clear
        return speedcell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()
        self.navigationController?.isNavigationBarHidden = false

        displaySpeed()
        //displayKilometer()
        //displayCalorie()
        
        SpeedTV?.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displaySpeed() {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/ranking/?filter=speed",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["users"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let firstname = subJson["firstname"].stringValue
                            let lastname = subJson["lastname"].stringValue
                            let weight = subJson["weight"].stringValue
                            let average_speed = subJson["average_speed"].stringValue
                            
                            let speed = SpeedData(firstname: firstname, lastname:lastname, weight:weight, average_speed:average_speed)
                            print(firstname)
                            self.speedArray.append(speed)
                            
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.SpeedTV.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SpeedTV?.reloadData()
    }
    
    
    func sideMenu() {
        if revealViewController != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }

    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }

    func displayKilometer() {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/ranking/?filter=kilometer",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["users"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let firstname = subJson["firstname"].stringValue
                            let lastname = subJson["lastname"].stringValue
                            let weight = subJson["weight"].stringValue
                            let average_speed = subJson["average_speed"].stringValue
                            
                            let speed = SpeedData(firstname: firstname, lastname:lastname, weight:weight, average_speed:average_speed)
                            print(firstname)
                            self.speedArray.append(speed)
                            
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.SpeedTV.reloadData()
        }
    }
    
    
    func displayCalorie() {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/ranking/?filter=calorie",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["users"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let firstname = subJson["firstname"].stringValue
                            let lastname = subJson["lastname"].stringValue
                            let weight = subJson["weight"].stringValue
                            let average_speed = subJson["average_speed"].stringValue
                            
                            let speed = SpeedData(firstname: firstname, lastname:lastname, weight:weight, average_speed:average_speed)
                            print(firstname)
                            self.speedArray.append(speed)
                            
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.SpeedTV.reloadData()
        }
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
}
