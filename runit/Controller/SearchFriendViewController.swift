//
//  SearchFriendViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 16/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchFriendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var friendEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        customView()
    }
    
    func txtPaddingVw(txt:UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        txt.leftViewMode = .always
        txt.leftView = paddingView
    }
    
    func customView() {
        friendEmail.setBottomBorder()
        txtPaddingVw(txt: friendEmail)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var SearchButton: UIButton!

    @IBAction func GoToFoundFriendScene(_ sender: Any) {
        self.performSegue(withIdentifier: "friendFoundSegue", sender: self)
    }

    @IBAction func SearchAction(_ sender: Any) {
        
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let email = friendEmail.text
        let params: [String: Any] =
            [
                "email" : email ?? "",
            ]
        
        
        let url = "https://runitv2.herokuapp.com/api/v1/friendships?user_email=" +
        UserSession.sharedInstance.email + "&user_token=" +
        UserSession.sharedInstance.token;
        
        Alamofire.request(url, method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Success sent friend request.")
                    if let value = response.result.value {
                        let json = JSON(value)
                        var dmd = "Votre demande d'amitié n'a pas été satisfaite."
                        if (json["status"] == 200) {
                            dmd = "Votre demande d'amitié a bien été faite."
                        }
                        let alert = UIAlertController(title: "Ajout d'ami", message: dmd, preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
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
