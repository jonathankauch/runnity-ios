//
//  GroupDetailViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 18/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class GroupDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var RequestRegisterLabel: UIButton!
    
    @IBOutlet weak var GroupNameLabel: UILabel!

    @IBOutlet weak var Groupimage: UIImageView!
    
    @IBOutlet weak var GroupPrivatelabel: UILabel!

    @IBOutlet weak var editGroup: UIButton!
    
    @IBAction func EditGroupAction(_ sender: Any) {
        self.performSegue(withIdentifier: "editGroupSegue", sender: self)
    }
    
    @IBOutlet weak var GroupDescriptionText: UITextView!
    
    @IBAction func ActionRequestRegister(_ sender: Any) {
        HttpRegisterGroup()
    }

    func HttpRegisterGroup() {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
        let group_id = String(UserSession.sharedInstance.group_id)
        
        let params: [String: Any] =
            [
                "group_id": group_id
            ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/member_requests/?group_id=" + group_id
        
        Alamofire.request(url, method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                        if let value = response.result.value {
                        let json = JSON(value)
                        if (json["status"] == 200) {
                            let dmd = "Votre demande pour rejoindre le groupe a été envoyée."
                            let alert = UIAlertController(title: "Demande pour rejoindre le groupe", message: dmd, preferredStyle: UIAlertControllerStyle.alert)

                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            }
                        else {
                            var dmd = "Vous avez déjà envoyé une demande pour rejoindre le groupe."
                            let alert = UIAlertController(title: "Erreur d'envoi de demande pour rejoindre ce groupe", message: dmd, preferredStyle: UIAlertControllerStyle.alert)
                            
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            }
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

    @IBOutlet weak var GroupRegisterLabel: UILabel!
    func displayGroupInfo() {
        GroupNameLabel.text = UserSession.sharedInstance.group_name
        GroupPrivatelabel.text = UserSession.sharedInstance.group_private_status == true ? "Groupe privée" : "Groupe public"
        
        
        var register_txt = "Vous n'êtes pas enregitré(e) dans ce groupe"
        if (UserSession.sharedInstance.group_is_register == true) {
            register_txt = "Vous êtes enregistré(e) dans ce groupe"
            RequestRegisterLabel.isHidden = true
        }
        if (UserSession.sharedInstance.group_user_id == Int(UserSession.sharedInstance.id)) {
            register_txt = "Vous êtes administrateur du groupe"
            editGroup.isHidden = false
        }
        GroupRegisterLabel.text = register_txt
        
        if (UserSession.sharedInstance.description.count > 1) {
            GroupDescriptionText.text = UserSession.sharedInstance.description
        } else { GroupDescriptionText.text = "Pas de description." }
        
        
        var img = UserSession.sharedInstance.group_picture
        if img.lowercased().range(of:"http") == nil {
            img = "https://s3-us-west-2.amazonaws.com/runit-storage/users/avatars/default-avatar.png"
        }

        let url = URL(string: img)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        Groupimage.image = UIImage(data: data!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editGroup.isHidden = true
        displayGroupInfo()
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
