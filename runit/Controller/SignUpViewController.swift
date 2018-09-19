//
//  SignUpViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 01/12/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backToLoginBtn: UIButton!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var signUpBtn: MyButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Executed when the 'return' key is pressed when using a field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .done
        return true
    }

    @IBAction func signUpBtnPressed(_ sender: Any) {
        // Creating and showing loading alert
        /*
         let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        */
        
        if (self.firstnameField.text!.isEmpty || self.lastnameField.text!.isEmpty || self.passwordField.text!.isEmpty) {
            let alert = UIAlertController(title: "Inscription échouée", message: "L'inscription a échoué. Veuillez remplir les champs contenant une *.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ((self.passwordField.text?.count)! < 6) {
            let alert = UIAlertController(title: "Inscription échouée", message: "Veuillez rentrer un mot de passe contenant plus de 6 caractères.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        let params: [String: Any] = [
            "firstname": self.firstnameField.text!,
            "lastname": self.lastnameField.text!,
            "password": self.passwordField.text!,
            "email": self.emailField.text!
        ]

        // POST Request on Sign up
        Alamofire.request("http://www.runit.fr/api/v1/sign_up",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let statusCode = (response.response?.statusCode)!
                    if let value = response.result.value {
                        var json = JSON(value)
                        let alert = UIAlertController(title: "Inscription réussie !", message: "L'inscription a pu être effectuée.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)

                        //self.dissmissOnResponse(alert: alert, statusCode: statusCode, response: json)
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Inscription échouée", message: "L'inscription n'a pas pu être effectuée.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    //self.dissmissOnResponse(alert: alert, statusCode: 500, response: error)
                }
        }
    }
    
    private func dissmissOnResponse(alert: UIAlertController, statusCode: Int, response: Any) {
        alert.dismiss(animated: false, completion: {
            if (statusCode == 200) {
                let checkEmail = UIAlertController(title: "Email de confirmation", message: "Pour finaliser l'inscription, veuillez valider le lien de confirmation envoyé par email.", preferredStyle: UIAlertControllerStyle.alert)
                checkEmail.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(checkEmail, animated: true, completion: nil)
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
                print("error: \(error)")
                let alert = UIAlertController(title: "Échec de l'inscription", message: error, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            } else {
                //
                let alert = UIAlertController(title: "Échec de l'inscription", message: "Avez vous bien rempli tous les champs obligatoires (*) ?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
