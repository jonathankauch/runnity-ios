//
//  EditDeleteGroupViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 19/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditDeleteGroupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var NameField: UITextField!
    
    @IBOutlet weak var DescriptionField: UITextView!
    
    @IBOutlet weak var switchPrivate: UISwitch!

    @IBAction func SwitchAction(_ sender: Any) {
        switchPrivate.isOn = (switchPrivate.isOn == false ? true : false)
}
    
    @IBAction func EditAction(_ sender: Any) {
        //alamo
        let name = NameField.text
        let description = DescriptionField.text

        var str_private = 0
        if (switchPrivate.isOn == true) {
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
        
        
        let groupid = String(UserSession.sharedInstance.group_id)

        let url = "https://runitv2.herokuapp.com/api/v1/groups/" + groupid
        
        Alamofire.request(url, method: .put,
                          parameters: params, encoding: JSONEncoding.default, headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        self.goBack()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }

    @IBOutlet weak var EditBtn: UIButton!
    
    @IBAction func DeleteAction(_ sender: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        
        let tmp = String(UserSession.sharedInstance.group_id)
        
        let edit_url = "https://runitv2.herokuapp.com/api/v1/groups/" + tmp;

        Alamofire.request(edit_url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Delete Success!")
                    UserSession.sharedInstance.group_id = 0
                    UserSession.sharedInstance.news_content = ""
                    UserSession.sharedInstance.news_user = ""
                    self.goBack()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func goBack() {
        self.performSegue(withIdentifier: "prepareForUnwindGroup", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        if (UserSession.sharedInstance.group_user_id != Int(UserSession.sharedInstance.id)) {
            deleteBtn.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameField.text = UserSession.sharedInstance.group_name
        DescriptionField.text = UserSession.sharedInstance.group_description
        
        switchPrivate.isOn =  UserSession.sharedInstance.group_private_status
        
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
