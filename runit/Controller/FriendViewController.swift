//
//  FriendViewController.swift
//  
//
//  Created by Jean-Paul Saysana on 16/01/2018.
//
import UIKit
import Alamofire
import SwiftyJSON

class FriendCell : UITableViewCell {
    @IBOutlet weak var friendLabel: UILabel!
}

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var FriendTV: UITableView!
    
    struct FriendData {
        let id : Int
        let friend_request_id : Int
        let firstname : String
        let lastname : String
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friends.removeAll()
        FriendTV.reloadData()
        displayFriends()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        FriendTV?.reloadData()
    }
    
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    func sideMenu() {
        if revealViewController != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func GetIDRow(row: Int) -> FriendData  {
        return friends[row]
    }

    var friends = [FriendData]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendCell
        cell.friendLabel!.text = friends[indexPath.row].firstname + " " + friends[indexPath.row].lastname
        cell.accessoryType = .detailDisclosureButton
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //Changer de page ici
        UserSession.sharedInstance.friend_id = GetIDRow(row: indexPath.row).id
        self.performSegue(withIdentifier: "friendInfoSegue", sender: self)
    }

    @IBOutlet weak var friendRequestButton: UIButton!
    
    @IBAction func GoToFriendRequest(_ sender: Any) {
        self.performSegue(withIdentifier: "friendRequestSegue", sender: self)
    }
    
    @IBOutlet weak var searchFriendButton: UIButton!
    
    @IBAction func SearchFriend(_ sender: Any) {
        self.performSegue(withIdentifier: "searchFriendSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        self.navigationController?.isNavigationBarHidden = false
        FriendTV?.dataSource = self
        FriendTV?.delegate = self
        
        FriendTV?.backgroundColor = UIColor.clear
        FriendTV.rowHeight = UITableViewAutomaticDimension
        FriendTV.estimatedRowHeight = 44
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
    
    func displayFriends() {
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
                        for (_, subJson) in json["friends"] {
                            let firstname = subJson["firstname"].stringValue
                            let lastname = subJson["lastname"].stringValue
                            let friend_request_id = subJson["friend_request_id"].intValue
                            let id = subJson["id"].intValue

                            let friend = FriendData(id: id, friend_request_id: friend_request_id, firstname: firstname, lastname: lastname)

                            self.friends.append(friend)
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            self.FriendTV.reloadData()
        }
    }
}
