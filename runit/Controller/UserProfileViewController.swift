//
//  UserProfileViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 06/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var alertBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var editBtn: MyButton!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        preFillFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = UIReturnKeyType.done
        return true
    }
    
    func sideMenu() {
        if revealViewController != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            alertBtn.target = revealViewController()
            alertBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            alertBtn.isEnabled = false
            alertBtn.tintColor = .clear
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
        addressField.setBottomBorder()
        phoneField.setBottomBorder()
        descriptionField.setBottomBorder()
        weightField.setBottomBorder()
        emailField.setBottomBorder()
        lastnameField.setBottomBorder()
        firstnameField.setBottomBorder()
        
        txtPaddingVw(txt: addressField)
        txtPaddingVw(txt: phoneField)
        txtPaddingVw(txt: descriptionField)
        txtPaddingVw(txt: weightField)
        txtPaddingVw(txt: emailField)
        txtPaddingVw(txt: lastnameField)
        txtPaddingVw(txt: firstnameField)
    }
    
    func preFillFields() {
        emailField.text = UserSession.sharedInstance.email
        firstnameField.text = UserSession.sharedInstance.firstname
        lastnameField.text = UserSession.sharedInstance.lastname
        phoneField.text = UserSession.sharedInstance.phone
        addressField.text = UserSession.sharedInstance.address
        descriptionField.text = UserSession.sharedInstance.description
        weightField.text = String(UserSession.sharedInstance.weight)
    }

    @IBAction func editBtnPressed(_ sender: Any) {
        // Creating and showing loading alert
        /*
        let alert = UIAlertController(title: nil, message: "Veuillez patienter..", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        */

        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let parameters: [String: Any] = [
            "firstname": firstnameField.text!,
            "lastname": lastnameField.text!,
            "email": emailField.text!,
            "address": addressField.text!,
            "phone": phoneField.text!,
            "description": descriptionField.text!,
            "weight": weightField.text!
        ]
        
        print("GROZIZI")
        let url = "http://www.runit.fr/api/v1/users/" + UserSession.sharedInstance.id
        
        // PUT Request on edit profile
        Alamofire.request(url,
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        json = json["user"]
                        UserSession.sharedInstance.firstname = self.firstnameField.text!
                        UserSession.sharedInstance.lastname = self.lastnameField.text!
                        UserSession.sharedInstance.email = self.emailField.text!
                        UserSession.sharedInstance.address = self.addressField.text!
                        UserSession.sharedInstance.phone = self.phoneField.text!
                        UserSession.sharedInstance.description = self.descriptionField.text!
                        UserSession.sharedInstance.weight = Double(self.weightField.text!)!
                        debugPrint(json)
                    }
                    var dmd = "La mise à jour de votre profil a bien été pris en compte."
                    let alert = UIAlertController(title: "Mise à jour du profil", message: dmd, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)

                    
                    //self.dissmissOnResponse(alert: alert, statusCode: statusCode)
                case .failure(let error):
                    var dmd = "La mise à jour de votre profil n'a pas été pris en compte."
                    let alert = UIAlertController(title: "Mise à jour du profil", message: dmd, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)

                    //self.dissmissOnResponse(alert: alert, statusCode: 500)
                }
        }
    }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let checkEmail = UIAlertController(title: "Profil édité", message: "Vos informations ont bien été mises à jour", preferredStyle: UIAlertControllerStyle.alert)
                checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(checkEmail, animated: true, completion: nil)
            } else {
                // Bad password or email alert
                let wrongCredidential = UIAlertController(title: "Un problème est survenu", message: "Erreur de connection", preferredStyle: UIAlertControllerStyle.alert)
                wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(wrongCredidential, animated: true, completion: nil)
            }
        })
    }
}
