//
//  GroupCreateViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 18/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupCreateViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var SwitchBtn: UISwitch!
    @IBOutlet weak var DescriptionField: UITextView!
    
    @IBAction func SwitchAction(_ sender: Any) {
        SwitchBtn.isOn = (SwitchBtn.isOn == false ? true : false)
    }
    
    @IBAction func RegisterAction(_ sender: Any) {
        //alamo
        let name = NameField.text
        let description = DescriptionField.text
        
        var str_private = 0
        if (SwitchBtn.isOn == true) {
            str_private = 1
        }
        
        let private_status = String(str_private)

        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let params: [String: Any] =
            [
                "name": name,
                "description": description,
                "private_status": private_status
                
        ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/groups/"
        
        Alamofire.request(url, method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        let dmd = "Le groupe " + self.NameField.text! + " a bien été crée."
                        
                        /*
                        let alert = UIAlertController(title: "Groupe créer", message: dmd, preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
 */
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
