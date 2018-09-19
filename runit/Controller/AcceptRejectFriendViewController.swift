//
//  AcceptRejectFriendViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 17/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AcceptRejectFriendViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var AcceptButton: UIButton!

    @IBOutlet weak var FriendLabel: UILabel!
    
    @IBOutlet weak var RejectButton: UIButton!
    
    @IBAction func AcceptFriend(_ sender: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        let friend_id = UserSession.sharedInstance.friend_id
        let request_id = String(UserSession.sharedInstance.friend_req_id)

        let params: [String: Any] =
            [
                "user_id" : friend_id
            ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/friendships/" + request_id + "/accept"

        Alamofire.request(url, method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Successfully added that guy!")
                    self.goBack()
                    case .failure(_):
                        print("Fail")
                }
        }
        
    }

    @IBAction func RejectFriend(_ sender: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        let friend_id = UserSession.sharedInstance.friend_id
        let request_id = String(UserSession.sharedInstance.friend_req_id)
        
        let params: [String: Any] =
            [
                "user_id" : friend_id
        ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/friendships/" + request_id + "/reject"
        
        Alamofire.request(url, method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Successfully rejected that guy!")
                    self.goBack()
                    case .failure(_):
                        print("Fail")
                }
        }
        
    }

    func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendLabel.text = UserSession.sharedInstance.friend_req_name
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
