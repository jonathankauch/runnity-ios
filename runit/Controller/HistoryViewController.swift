//
//  HistoryViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 19/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class HistoryCell : UITableViewCell {
    
    @IBOutlet weak var HistoryLabel: UILabel!

    @IBOutlet weak var HistoryTimeLabel: UILabel!
    @IBOutlet weak var HistorySpeedLabel: UILabel!
    @IBOutlet weak var HistoryCaloriesLabel: UILabel!
    @IBOutlet weak var HistoryDateStartLabel: UILabel!
    @IBOutlet weak var HistoryDateEndLabel: UILabel!
}

class HistoryViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var menuBtn: UIBarButtonItem!

    @IBOutlet weak var HistoryTV: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160.0;//Choose your custom row height
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryCell
        
        cell.HistoryLabel.text = "Distance totale:   " + historyArray[indexPath.row].total_distance + " m."

        cell.HistoryTimeLabel.text = "Durée totale:   " + historyArray[indexPath.row].total_time + " sec."

        cell.HistorySpeedLabel.text = "Vitesse maximale:   " + historyArray[indexPath.row].max_speed + " km/h."
        
        cell.HistoryCaloriesLabel.text = "Calories:   " + historyArray[indexPath.row].calories + " cal."
        
        if (Date.from(string: historyArray[indexPath.row].started_at) != nil) {
            cell.HistoryDateStartLabel.text = String.mediumDateShortTime(Date.from(string: historyArray[indexPath.row].started_at)!)
        } else {
            cell.HistoryDateStartLabel.text = "Pas de date spécifiée"
        }
        
        //cell.accessoryType = .detailDisclosureButton
        cell.backgroundColor = UIColor.clear
        return cell

    }
    
    struct HistoryData {
        let id : String
        let total_distance: String
        let total_time: String
        let max_speed: String
        let calories: String
        let started_at: String
    }
    
    var historyArray = [HistoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()
        HistoryTV?.backgroundColor = UIColor.clear
    }

    
    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyArray.removeAll()
        HistoryTV.reloadData()
        displayRuns()
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

    func displayRuns() {
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/runs",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["runs"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let id = subJson["id"].stringValue
                            let total_distance = subJson["total_distance"].stringValue
                            let total_time = subJson["total_time"].stringValue
                            let max_speed = subJson["max_speed"].stringValue
                            let calories = subJson["calories"].stringValue
                            let started_at = subJson["created_at"].stringValue
                            
                            let history = HistoryData(id: id, total_distance: total_distance, total_time: total_time, max_speed: max_speed, calories: calories,
                                started_at: started_at)
                            self.historyArray.append(history)
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.HistoryTV.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        HistoryTV?.reloadData()
    }
}
