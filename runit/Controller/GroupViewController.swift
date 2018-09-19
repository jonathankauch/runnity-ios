//
//  GroupViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 18/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class GroupCell  : UITableViewCell {
    @IBOutlet weak var GroupLabel: UILabel!
    
}

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var makeGroupBtn: UIButton!
    
    @IBAction func MakeGroupAction(_ sender: Any) {
        self.performSegue(withIdentifier: "createGroupSegue", sender: self)
    }
    

    @IBAction func prepareForUnwindGroup(segue: UIStoryboardSegue) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupCell
        cell.GroupLabel.text = groupArray[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func GetIDRow(row: Int) -> GroupData  {
        return groupArray[row]
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //Changer de page ici
        UserSession.sharedInstance.group_id = GetIDRow(row: indexPath.row).id
        UserSession.sharedInstance.group_user_id = GetIDRow(row: indexPath.row).user_id
        
        UserSession.sharedInstance.group_private_status = GetIDRow(row: indexPath.row).private_status
        UserSession.sharedInstance.group_is_register = GetIDRow(row: indexPath.row).is_register
        UserSession.sharedInstance.group_name = GetIDRow(row: indexPath.row).name
        UserSession.sharedInstance.group_picture = GetIDRow(row: indexPath.row).picture
        UserSession.sharedInstance.group_description = GetIDRow(row: indexPath.row).description
        UserSession.sharedInstance.group_avatar_file_name = GetIDRow(row: indexPath.row).avatar_file_name
        UserSession.sharedInstance.group_avatar_content_type = GetIDRow(row: indexPath.row).avatar_content_type

        self.performSegue(withIdentifier: "groupDetailSegue", sender: self)

    }

    
    struct GroupData {
        let id : Int
        let user_id : Int
        let private_status: Bool
        let is_register: Bool
        let name: String
        let picture: String
        let description: String
        let avatar_file_name: String
        let avatar_content_type: String
    }

    var groupArray = [GroupData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu()
        customNavBar()
        customView()
        GroupTV?.dataSource = self
        GroupTV?.delegate = self
        GroupTV?.backgroundColor = UIColor.clear
        GroupTV?.backgroundColor = UIColor.clear
        GroupTV?.rowHeight = UITableViewAutomaticDimension
        GroupTV?.estimatedRowHeight = 44

        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }

    @IBOutlet weak var GroupTV: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func listGroup() {
        
        /* GET */
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/groups",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["groups"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let id = subJson["id"].intValue
                            let user_id = subJson["user_id"].intValue
                            let private_status = subJson["private_status"].boolValue
                            let is_register = subJson["is_register"].boolValue
                            let name = subJson["name"].stringValue
                            let picture = subJson["picture"].stringValue
                            let description = subJson["description"].stringValue
                            let avatar_file_name = subJson["avatar_file_name"].stringValue
                            let avatar_content_type = subJson["avatar_content_type"].stringValue
                            
                            let group = GroupData(id: id, user_id: user_id, private_status: private_status, is_register: is_register, name:name, picture:picture, description:description, avatar_file_name: avatar_file_name, avatar_content_type: avatar_content_type)
                            
//                            if (group.private_status == false) {
                                self.groupArray.append(group)
//                            }

                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.GroupTV.reloadData()
        }
        
    }
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupArray.removeAll()
        GroupTV.reloadData()
        listGroup()
    }

    override func viewDidAppear(_ animated: Bool) {
        GroupTV?.reloadData()
    }
    

    func sideMenu() {
        if revealViewController != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
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
