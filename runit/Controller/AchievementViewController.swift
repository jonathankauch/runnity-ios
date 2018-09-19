//
//  AchievementViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 03/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AchievementViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    // Page Add-New-Achievement
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var typeField: UIPickerView!
    @IBOutlet weak var valueField: UITextField!

    struct AchievementData {
        let id: Int
        let content: String
        let startDate : String
        let endDate : String
        let type : String
        let value: Int
    }

    var achievementsData = [AchievementData]()
    var achievementsData2 = [AchievementData]()
    var achievementsData3 = [AchievementData]()

    let headers = ["Objectifs en cours", "Objectifs atteints", "Objectifs échoués"]
    let typeDataSource = ["Distance (km)", "Temps (min)", "Poids (kg)"]
    var typeDataSourceValue = ["KILOMETER", "TIME", "WEIGHT"]
    var selectedType = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAchievementList()
        getAchievementDoneList()
        getAchievementFailList()
        tableView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()

        // Supply our data to the tableView
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // Supply our data to the picker
        typeField?.dataSource = self
        typeField?.delegate = self
        typeField?.reloadAllComponents()

        tableView?.register(UINib(nibName: "AchievementTableViewCell", bundle: nil), forCellReuseIdentifier: "achievementCell")
        
        // Custom
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 125
        tableView?.backgroundColor = UIColor.clear
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
    
    @IBAction func addBtnPressed(_ sender: Any) {
        // Creating and showing loading alert
        let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)

        if ( startDateField.date > endDateField.date) {
            var dmd = "La date de fin ne peut pas être antérieur à la date de début."
            let alert = UIAlertController(title: "Erreur date.", message: dmd, preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]

        let parameters: [String: Any] = [
            "content": contentField!.text!,
            "start_date": String.formatDateApi(startDateField.date),
            "due_date": String.formatDateApi(endDateField.date),
            "type":  selectedType,
            "value": valueField.text!
        ]

        let url = "http://www.runit.fr/api/v1/achievements/"

        // POST request for adding a new event
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        self.navigationController?.popViewController(animated: true)
                        self.dissmissOnResponse(alert: alert, statusCode: statusCode, response: json)
                    }

                case .failure(let error):
                    self.dissmissOnResponse(alert: alert, statusCode: 500, response: error)
                }
        }
    }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int, response: Any) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let alert = UIAlertController(title: "Objectif ajouté", message: "L'objectif a été créé avec succès !", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            } else if (statusCode == 422) {
                var error = ""
                for (key, subJson) in response as! JSON {
                    error += "- " + key + ": "
                    for (key, elem) in subJson as! JSON {
                        error += elem.stringValue
                        error += " "
                    }
                    error += "\n"
                }
                print("Error: \(error)")
                let alert = UIAlertController(title: "Impossible de créér l'objectif", message: "Veuillez compléter tous les champs", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                // Bad password or email alert
                let wrongCredidential = UIAlertController(title: "Un problème est survenu", message: "Erreur de connection", preferredStyle: UIAlertControllerStyle.alert)
                wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(wrongCredidential, animated: true, completion: nil)
            }
        })
    }

    func getAchievementList() {
        let headers = [
            "X-User-Email" : UserSession.sharedInstance.email,
            "X-User-Token" : UserSession.sharedInstance.token
        ]

        // GET request on events
        Alamofire.request("http://www.runit.fr/api/v1/achievements",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (key, subJson) in json["achievements"] {
                            let id = subJson["id"].intValue
                            let content = subJson["content"].stringValue
                            let startDate = subJson["start_date"].stringValue
                            let endDate = subJson["due_date"].stringValue
                            let type = subJson["type"].stringValue
                            let value = subJson["value"].intValue

                            var achievement = AchievementData(id: id,
                                                              content: content,
                                                              startDate: startDate,
                                                              endDate: endDate,
                                                              type: type,
                                                              value: value)
                            self.achievementsData.append(achievement)
                        }
                        self.tableView?.reloadData()
                    }
                case .failure(let error):
                    print("La requête a échoué: \(error)")
                }
                self.tableView?.reloadData()
        }
    }

    func getAchievementDoneList() {
        let headers = [
            "X-User-Email" : UserSession.sharedInstance.email,
            "X-User-Token" : UserSession.sharedInstance.token
        ]

        // GET request on events
        Alamofire.request("http://www.runit.fr/api/v1/achievements",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (key, subJson) in json["achievements_done"] {
                            let id = subJson["id"].intValue
                            let content = subJson["content"].stringValue
                            let startDate = subJson["start_date"].stringValue
                            let endDate = subJson["due_date"].stringValue
                            let type = subJson["type"].stringValue
                            let value = subJson["value"].intValue

                            var achievement = AchievementData(id: id,
                                                              content: content,
                                                              startDate: startDate,
                                                              endDate: endDate,
                                                              type: type,
                                                              value: value)
                            self.achievementsData2.append(achievement)
                        }
                        self.tableView?.reloadData()
                    }
                case .failure(let error):
                    print("La requête a échoué: \(error)")
                }
                self.tableView?.reloadData()
        }
    }

    func getAchievementFailList() {
        let headers = [
            "X-User-Email" : UserSession.sharedInstance.email,
            "X-User-Token" : UserSession.sharedInstance.token
        ]

        // GET request on events
        Alamofire.request("http://www.runit.fr/api/v1/achievements",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (key, subJson) in json["achievements_fail"] {
                            let id = subJson["id"].intValue
                            let content = subJson["content"].stringValue
                            let startDate = subJson["start_date"].stringValue
                            let endDate = subJson["due_date"].stringValue
                            let type = subJson["type"].stringValue
                            let value = subJson["value"].intValue

                            var achievement = AchievementData(id: id,
                                                              content: content,
                                                              startDate: startDate,
                                                              endDate: endDate,
                                                              type: type,
                                                              value: value)
                            self.achievementsData3.append(achievement)
                        }
                        self.tableView?.reloadData()
                    }
                case .failure(let error):
                    print("La requête a échoué: \(error)")
                }
                self.tableView?.reloadData()
        }
    }
}

extension AchievementViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return achievementsData.count
        case 1:
            return achievementsData2.count
        case 2:
            return achievementsData3.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var achievementsData: [AchievementData]?

        switch indexPath.section {
        case 0:
            achievementsData = self.achievementsData
        case 1:
            achievementsData = self.achievementsData2
        case 2:
            achievementsData = self.achievementsData3
        default:
            break;
        }

        // Fill the labels with data
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as? AchievementTableViewCell,
            let data = achievementsData else {
                return UITableViewCell()
        }

        cell.contentLabel.text = data[indexPath.row].content
        if (Date.from(string: data[indexPath.row].startDate) != nil) {
            cell.startDateLabel.text = String.mediumDateShortTime(Date.from(string: data[indexPath.row].startDate)!)
        } else {
            cell.startDateLabel.text = "Pas de date spécifiée"
        }
        if (Date.from(string: data[indexPath.row].endDate) != nil) {
            cell.endDateLabel.text = String.mediumDateShortTime(Date.from(string: data[indexPath.row].endDate)!)
        } else {
            cell.endDateLabel.text = "Pas de date spécifiée"
        }
        cell.typeLabel.text = data[indexPath.row].type
        cell.valueLabel.text = String(achievementsData![indexPath.row].value)

        // Fill the hidden data
        cell.id = String(data[indexPath.row].id)
        cell.backgroundColor = UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
}

extension AchievementViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return typeDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = typeDataSourceValue[row]
    }
}
