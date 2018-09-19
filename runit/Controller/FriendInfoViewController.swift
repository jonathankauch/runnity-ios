//
//  FriendInfoViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 16/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class FriendInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var picture_profile: UIImageView!
    
    @IBOutlet weak var firstname_field: UILabel!
    @IBOutlet weak var lastname_field: UILabel!
    @IBOutlet weak var email_field: UILabel!
    @IBOutlet weak var weight_field: UILabel!
    @IBOutlet weak var phone_field: UILabel!
    @IBOutlet weak var adress_field: UILabel!
    @IBOutlet weak var average_field: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfoFriend()
        adress_field.adjustsFontSizeToFitWidth = true

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
    
    func displayInfoFriend() {
        /* GET */
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        let id : Int = UserSession.sharedInstance.friend_id
        var myString = String(id)
        
        let url = "https://runitv2.herokuapp.com/api/v1/users/" + myString
        // GET request on events
        Alamofire.request(url,
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let img = json["picture"].string!
                        
                        let url = URL(string: img)
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        self.picture_profile.image = UIImage(data: data!)

                        
                        let user = json["user"]
                        self.firstname_field.text = user["firstname"].string
                        self.lastname_field.text = user["lastname"].string
                        self.email_field.text = user["email"].string
                        self.phone_field.text = user["phone"].string
                        self.adress_field.text = user["address"].string
                        self.average_field.text = user["average"].string
                        self.weight_field.text = user["weight"].string
                        
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
