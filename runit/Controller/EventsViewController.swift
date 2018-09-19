//
//  EventsViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 07/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventCell : UITableViewCell {
    // IBoutlet one event by cell

    var id: String = "";
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var start_dateLabel: UILabel!
    @IBOutlet weak var end_dateLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!

    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var unregisterBtn: MyButton!

    @IBAction func registerBtnPressed(_ sender: Any) {
        // Do API to modify
        // Creating and showing loading alert
        let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)

        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/events/" + String(self.id) + "/like"

        // POST request for adding a new event
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        self.dissmissOnResponseRegister(alert: alert, statusCode: statusCode, response: json)
                        self.registerBtn.isHidden = true
                        self.unregisterBtn.isHidden = false
                    }
                    
                case .failure(let error):
                    self.dissmissOnResponseRegister(alert: alert, statusCode: 500, response: error)
                }
        }
    }
    
    @IBAction func unregisterBtnPressed(_ sender: Any) {
        // Do API to modify
        // Creating and showing loading alert
        let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/events/" + String(self.id) + "/dislike"

        
        // POST request for adding a new event
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        self.dissmissOnResponseRegister(alert: alert, statusCode: statusCode, response: json)
                        self.registerBtn.isHidden = false
                        self.unregisterBtn.isHidden = true
                    }
                    
                case .failure(let error):
                    self.dissmissOnResponseRegister(alert: alert, statusCode: 500, response: error)
                }
        }
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        
//        EventsViewController.performSegue(withIdentifier: "editEventSegue", sender: self)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        // Creating and showing loading alert
        
        /*let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        */

        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/events/" + String(self.id)
        
        // POST request for adding a new event
        Alamofire.request(url,
                          method: .delete,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        //self.dissmissOnResponse(alert: alert, statusCode: statusCode, response: json)
                        let alert = UIAlertController(title: "Suppression de l'événement.", message: "L'événement a bien été supprimé et disparaitra lors du rechargement de la page.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    }
                    
                case .failure(let error):
                    print("Delete fail")
                    //self.dissmissOnResponse(alert: alert, statusCode: 500, response: error)
                }
            }
        }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int, response: Any) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let checkEmail = UIAlertController(title: "Évènement supprimé", message: "L'évènement a été supprimé avec succès !", preferredStyle: UIAlertControllerStyle.alert)
                checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController?.present(checkEmail, animated: true, completion: nil)
            }
            else {
                let wrongCredidential = UIAlertController(title: "Un problème est survenu", message: "Erreur de connection", preferredStyle: UIAlertControllerStyle.alert)
                wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController?.present(wrongCredidential, animated: true, completion: nil)
            }
        })
    }
    
    private func dissmissOnResponseRegister(alert: UIAlertController, statusCode: Int, response: Any) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
//                let checkEmail = UIAlertController(title: "Vo", message: "L'évènement a été supprimé avec succès !", preferredStyle: UIAlertControllerStyle.alert)
//                checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
//                UIApplication.shared.keyWindow?.rootViewController?.present(checkEmail, animated: true, completion: nil)
            }
            else {
//                let wrongCredidential = UIAlertController(title: "Un problème est survenu", message: "Erreur de connection", preferredStyle: UIAlertControllerStyle.alert)
//                wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
//                UIApplication.shared.keyWindow?.rootViewController?.present(wrongCredidential, animated: true, completion: nil)
            }
        })
    }
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    // Page Event
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // Page Add-New-Event
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var privateField: UISwitch!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var distanceField: UITextField!

    struct EventData {
        let id: String
        let name : String
        let start_date : String
        let end_date : String
        let distance : Int
        let liked_by : Bool
        let user_id : String
    }
    
    var eventsData = [EventData]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventsData.removeAll()
        getEventList()
        tableView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()
        
        // Supply our data to the tableView
        tableView?.dataSource = self
        // Notify VC class when user interact with tableView
        tableView?.delegate = self
        
        tableView?.backgroundColor = UIColor.clear
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.tableView {
            count = self.eventsData.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:EventCell?
        
        if tableView == self.tableView {
            
            // Fill the labels with data
            cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventCell
            cell!.nameLabel!.text = eventsData[indexPath.row].name
            
            if (Date.from(string: eventsData[indexPath.row].start_date) != nil) {
                cell!.start_dateLabel!.text = String.mediumDateShortTime(Date.from(string: eventsData[indexPath.row].start_date)!)
            } else {
                cell!.start_dateLabel!.text = "Pas de date spécifiée"
            }
            if (Date.from(string: eventsData[indexPath.row].end_date) != nil) {
                cell!.end_dateLabel!.text = String.mediumDateShortTime(Date.from(string: eventsData[indexPath.row].end_date)!)
            } else {
                cell!.end_dateLabel!.text = "Pas de date spécifiée"
            }
            cell!.distanceLabel!.text = String(eventsData[indexPath.row].distance) + " km"
            
            if (eventsData[indexPath.row].liked_by == true) {
                cell!.registerBtn.isHidden = true
                cell!.unregisterBtn.isHidden = false
            }
            
            if (UserSession.sharedInstance.id != eventsData[indexPath.row].user_id) {
                cell!.deleteBtn.isHidden = true
            }
            
            
            // Fill the hidden data
            cell!.id = eventsData[indexPath.row].id
            
            // Style customization
            /*
            let editImg = UIImage(named: "ic_edit")
            let editTintedImg = editImg?.withRenderingMode(.alwaysTemplate)
            cell!.editBtn.setImage(editTintedImg, for: .normal)
            cell!.editBtn.tintColor = RIColors.GREEN
             */
            //cell!.editBtn.addTarget(self, action: "someAction", for: .touchUpInside)
            
            
            let deleteImg = UIImage(named: "ic_delete")
            let deleteTintedImg = deleteImg?.withRenderingMode(.alwaysTemplate)
            cell!.deleteBtn.setImage(deleteTintedImg, for: .normal)
            cell!.deleteBtn.tintColor = RIColors.RED
            cell!.backgroundColor = UIColor.clear
        }
        return cell!
    }
    func someAction() {
        performSegue(withIdentifier: "editEventSegue", sender: self)
    }

    func sideMenu() {
        if self.revealViewController() != nil {
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
    
    func txtPaddingVw(txt:UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        txt.leftViewMode = .always
        txt.leftView = paddingView
    }
    
    func customView() {
        
        nameField?.setBottomBorder()
        cityField?.setBottomBorder()
        descriptionField?.setBottomBorder()
        distanceField?.setBottomBorder()
        
//        txtPaddingVw(txt: nameField)
//        txtPaddingVw(txt: cityField)
//        txtPaddingVw(txt: descriptionField)
//        txtPaddingVw(txt: distanceField)
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

    func getEventList() {
        let headers = [
            "X-User-Email" : UserSession.sharedInstance.email,
            "X-User-Token" : UserSession.sharedInstance.token
        ]
        
        // GET request on events
        Alamofire.request("http://www.runit.fr/api/v1/events",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (key, subJson) in json["events"] {
                            let id = subJson["id"].stringValue
                            let name = subJson["name"].stringValue
                            let distance = subJson["distance"].intValue
                            let start_date = subJson["start_date"].stringValue
                            let end_date = subJson["end_date"].stringValue
                            let user_id = subJson["user_id"].stringValue
                            let licked_by = subJson["liked_by"].arrayValue
                            var liked_by = false

                            for objet in licked_by {
                                if (objet.stringValue == UserSession.sharedInstance.firstname + " " + UserSession.sharedInstance.lastname) {
                                    liked_by = true
                                    print(objet.stringValue)
                                }
                            }

                            /*
                            if (liked_by.contains(UserSession.sharedInstance.lastname)) {
                                if (liked_by.contains(UserSession.sharedInstance.firstname)) {
                                    print("TROUVER = " + name)
                                }
                            }
 */
                            var event = EventData(id: id,
                                                  name: name,
                                                  start_date: start_date,
                                                  end_date: end_date,
                                                  distance: distance,
                                                  liked_by: liked_by,
                                                  user_id: user_id)
                            
                            self.eventsData.append(event)
                        }
                        self.tableView?.reloadData()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.tableView?.reloadData()
        }
    }
    
    
    @IBAction func addBtnPressed(_ sender: Any) {
        // Creating and showing loading alert
        /*
        let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
         */
        
        if ((nameField.text?.isEmpty)! || (cityField.text?.isEmpty)! || (descriptionField.text?.isEmpty)! || (distanceField.text?.isEmpty)!) {
            let alert = UIAlertController(title: "Champs non remplis", message: "Les champs du formulaire doivent être remplis.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        if ((Int(distanceField.text!) == nil)) {
            let alert = UIAlertController(title: "Distance erreur.", message: "La distance ne peut contenir que des chiffres.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }

        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        let parameters: [String: Any] = [
            "name": nameField!.text!,
            "city": cityField.text!,
            "description": descriptionField.text!,
            "distance": distanceField.text!,
            "private_status": privateField.isOn
            ]
        let url = "http://www.runit.fr/api/v1/events/"
        
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
                        //debugPrint(json)
                        //self.dissmissOnResponse(alert: alert, statusCode: statusCode, response: json)
                        //let checkEmail = UIAlertController(title: "Évènement ajouté", message: "L'évènement a été créé avec succès !", preferredStyle: UIAlertControllerStyle.alert)
                        //checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.navigationController?.popViewController(animated: true)
//                        self.dismiss(animated: true, completion: nil)
                        //self.present(checkEmail, animated: true, completion: nil)
                        //print("retour")
                    }

                case .failure(let error):
                    print("fail")
                    //self.dissmissOnResponse(alert: alert, statusCode: 500, response: error)
                }
        }
    }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int, response: Any) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let checkEmail = UIAlertController(title: "Évènement ajouté", message: "L'évènement a été créé avec succès !", preferredStyle: UIAlertControllerStyle.alert)
                checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                //self.present(checkEmail, animated: true, completion: nil)
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
                let alert = UIAlertController(title: "Impossible de créér l'évènement", message: "Veuillez compléter tous les champs", preferredStyle: UIAlertControllerStyle.alert)
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
    
}
