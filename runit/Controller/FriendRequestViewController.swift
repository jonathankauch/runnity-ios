//
//  FriendRequestViewController.swift
//  
//
//  Created by Jean-Paul Saysana on 17/01/2018.
//

import UIKit
import Alamofire
import SwiftyJSON

class FriendReqCell: UITableViewCell {
    
    @IBOutlet weak var FriendReqLabel: UILabel!
}

class FriendRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    struct FriendReqData {
        let id : Int
        let requests_id : Int
        let firstname : String
        let lastname : String
    }
    
    var friends = [FriendReqData]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friends.removeAll()
        friendReqTV.reloadData()
        displayFriendsReq()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        friendReqTV?.reloadData()
    }
    
    func GetIDRow(row: Int) -> FriendReqData  {
        return friends[row]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendReqCell
        cell.FriendReqLabel!.text = friends[indexPath.row].firstname + " " + friends[indexPath.row].lastname
        cell.accessoryType = .detailDisclosureButton
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //Changer de page ici
        UserSession.sharedInstance.friend_id = GetIDRow(row: indexPath.row).id
        UserSession.sharedInstance.friend_req_id = GetIDRow(row: indexPath.row).requests_id
        UserSession.sharedInstance.friend_req_name = GetIDRow(row: indexPath.row).firstname + " " + GetIDRow(row: indexPath.row).lastname
        
        GoToAcceptRejectScene()
    }

    func GoToAcceptRejectScene() {
        self.performSegue(withIdentifier: "acceptRejectFriendSegue", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        friendReqTV?.dataSource = self
        friendReqTV?.delegate = self

        friendReqTV?.backgroundColor = UIColor.clear
        friendReqTV?.backgroundColor = UIColor.clear
        friendReqTV?.rowHeight = UITableViewAutomaticDimension
        friendReqTV?.estimatedRowHeight = 44
    }
    @IBOutlet weak var friendReqTV: UITableView!
    
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

    func displayFriendsReq() {
        /* GET */
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        let url = "https://runitv2.herokuapp.com/api/v1/friendships?user_email=" + UserSession.sharedInstance.email + "&user_token=" + UserSession.sharedInstance.token
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
                        for (_, subJson) in json["requests"] {
                            let firstname = subJson["firstname"].stringValue
                            let lastname = subJson["lastname"].stringValue
                            let requests_id = subJson["requests_id"].intValue
                            let id = subJson["id"].intValue
                            
                            let friend = FriendReqData(id: id, requests_id: requests_id, firstname: firstname, lastname: lastname)
                            self.friends.append(friend)
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.friendReqTV.reloadData()
        }
    }
}
