//
//  NewfeedsViewController.swift
//  runit
//
//  Created by Denise NGUYEN on 07/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PostCell : UITableViewCell {
    // IBoutlet one event by cell
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class NewfeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }

    
    struct PostData {
        let content : String
        let user_name : String
        let created_at : String
        let id : Int
        let user_id : String
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var alertBtn: UIBarButtonItem!
    @IBOutlet weak var publishBtn: UIButton!
    
    @IBOutlet weak var postInput: UITextView!

    var postArray = [PostData]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func GetIDRow(row: Int) -> PostData  {
        return postArray[row]
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //Changer de page ici
        UserSession.sharedInstance.news_id = GetIDRow(row: indexPath.row).id
        UserSession.sharedInstance.news_user = GetIDRow(row: indexPath.row).user_name
        UserSession.sharedInstance.news_content = GetIDRow(row: indexPath.row).content
        UserSession.sharedInstance.news_date = GetIDRow(row: indexPath.row).created_at
        UserSession.sharedInstance.news_user_id = GetIDRow(row: indexPath.row).user_id
        self.performSegue(withIdentifier: "newsSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     var cell: PostCell?
        if tableView == self.tableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostCell
            cell!.accessoryType = .detailDisclosureButton

            cell!.nameLabel!.text = postArray[indexPath.row].user_name
            if (Date.from(string: postArray[indexPath.row].created_at) != nil) {
               cell!.dateLabel.text = String.mediumDateShortTime(Date.from(string: postArray[indexPath.row].created_at)!)
            }
            
            cell!.postLabel!.text = postArray[indexPath.row].content
//            cell!.backgroundColor = UIColor.clear
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func sideMenu() {
        if revealViewController() != nil {
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            alertBtn.target = revealViewController()
            alertBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            alertBtn.isEnabled = false
            alertBtn.tintColor = .clear
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func newsBtnPressed(sender: AnyObject) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        let params: [String: Any] =
            [
                "content": postInput.text
        ]
        
        
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/posts", method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                self.postInput.text = ""
                switch response.result {
                case .success:
                     self.tableView?.reloadData()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.tableView?.reloadData()
        })
    }
        
        func displayPost() {
            
            /* GET */
            let headers = [
                "X-User-Email": UserSession.sharedInstance.email,
                "X-User-Token": UserSession.sharedInstance.token,
                ]
            
            // GET request on events
            Alamofire.request("https://runitv2.herokuapp.com/api/v1/posts",
                              method: .get,
                              encoding: JSONEncoding.default,
                              headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            for (key, subJson) in json["posts"] {
//                                print("Elem[\(key)] \(subJson)")
                                let content = subJson["content"].stringValue
                                let user_name = subJson["user"]["full_name"].stringValue
                                let user_id = subJson["user"]["user_id"].stringValue
                                let created_at = subJson["created_at"].stringValue
                                let id = subJson["id"].intValue
                                var post = PostData(content: content, user_name: user_name,
                                                    created_at: created_at, id: id, user_id: user_id)
                                self.postArray.append(post)
                            }
                            //self.tableView?.reloadData()
                        }
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                    }
                    self.tableView?.reloadData()
            }
        }


    func customNavBar() {
        navigationController?.navigationBar.tintColor = RIColors.WHITE
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: RIColors.WHITE]
        navigationController?.navigationBar.barTintColor = RIColors.CYAN
    }
    
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        customNavBar()
        customView()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.backgroundColor = UIColor.clear
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 44
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postArray.removeAll()
        tableView.reloadData()
        displayPost()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
