//
//  LoginViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 05/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnPressed(sender: AnyObject) {
        // Creating and showing loading alert
        let alert = UIAlertController(title: nil, message: "Veuillez patienter...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

        // Start login
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        let params: [String:Any] = [
            "email": email,
            "password": password]

        let req = UserRequestFactory.login(parameters: params as [String : AnyObject])

        req.perform(withSuccess: { (res) in
            UserSession.sharedInstanceWith(
                email: res.email,
                token: res.authentication_token,
                id: res.id,
                firstname: res.firstname,
                lastname: res.lastname,
                address: res.address,
                phone: res.phone,
                description: res.description,
                weight: res.weight)
            self.dismiss(animated: false) {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }) { (err) in
            let code = err.response?.statusCode
            guard let err = err.errorModel else { return }

            let wrongCredidential = UIAlertController(title: "La connection a échoué", message: "Erreur dans l'email ou mot de passe", preferredStyle: UIAlertControllerStyle.alert)
            wrongCredidential.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.dismiss(animated: false) {
                self.present(wrongCredidential, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
        super.touchesBegan(touches, with: event)
    }
    
    /// Executed when the 'return' key is pressed when using the emailField.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.returnKeyType = .done
        return true
    }
}
