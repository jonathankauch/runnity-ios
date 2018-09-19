//
//  PublicationViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 06/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CommentCell : UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var user_fullname: UILabel!
}


class PublicationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var PostLabel: UITextView!
    
    struct CommentData {
        let content : String
        let id : Int
        let comment_id : Int
        let user_fullname : String
        let created_at : String
        let user_id : String
    }
    
    var headers = ["COMMENTAIRES"]
    var commentArray = [CommentData]()

    @IBOutlet weak var ComTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commentArray.count
    }

    func getNameOfUserById(u_id : String) -> String {
        for user in ListUsers {
            if (u_id == user.fid) {
                return user.firstname + " " + user.lastname
            }
        }
        return "bite"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentCell
        cell.commentLabel!.text = commentArray[indexPath.row].content
        if (Date.from(string: commentArray[indexPath.row].created_at) != nil) {
            cell.created_at!.text = String.mediumDateShortTime(Date.from(string: commentArray[indexPath.row].created_at)!)
        }
        
        cell.user_fullname!.text = getNameOfUserById(u_id: commentArray[indexPath.row].user_id)
        
        if (commentArray[indexPath.row].user_id == UserSession.sharedInstance.id) {
            cell.accessoryType = .detailDisclosureButton
//            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }

    func GetIDRow(row: Int) -> CommentData  {
        return commentArray[row]
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //Changer de page ici
        print(GetIDRow(row: indexPath.row))
        UserSession.sharedInstance.comment_id = GetIDRow(row: indexPath.row).comment_id
        UserSession.sharedInstance.comment_content = GetIDRow(row: indexPath.row).content
        UserSession.sharedInstance.comment_date = GetIDRow(row: indexPath.row).created_at
        self.performSegue(withIdentifier: "editDeleteCommentSegue", sender: self)
    }
    

    @IBOutlet weak var EditDeleteButton: UIButton!

    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ComTableView.rowHeight = UITableViewAutomaticDimension
        ComTableView.estimatedRowHeight = 44
    }
    @IBOutlet weak var AddCommentButton: UIButton!
    
    @IBAction func GoToAddCommentScene(_ sender: Any) {
        self.performSegue(withIdentifier: "addComment", sender: self)
    }
    
    @IBAction func GoToEditDeleteScene(_ sender: Any) {        self.performSegue(withIdentifier: "modifPoste", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayComment() {
       /* GET */
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]

        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/comments",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["comments"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let content = subJson["content"].stringValue
                            let id = subJson["post_id"].intValue
                            let comment_id = subJson["id"].intValue
                            let user_fullname = subJson["user_fullname"].stringValue
                            let user_id = subJson["user_id"].stringValue
                            let created_at = subJson["created_at"].stringValue
                            let comment = CommentData(content: content, id: id, comment_id: comment_id, user_fullname: user_fullname, created_at: created_at, user_id: user_id)

                            if (UserSession.sharedInstance.news_id == id) {
                                self.commentArray.append(comment)
                            }
                            
                            
                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.ComTableView.reloadData()
        }
    }
    
    struct FUsers {
        let firstname : String
        let lastname : String
        let fid : String
        }
    var ListUsers: [FUsers] = []
    
    func getListUsers() {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        // GET request on events
        Alamofire.request("https://runitv2.herokuapp.com/api/v1/users",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, subJson) in json["users"] {
                            //                                print("Elem[\(key)] \(subJson)")
                            let firstname = subJson["firstname"].stringValue
                            let lastname = subJson["lastname"].stringValue
                            let fid = subJson["id"].stringValue
                            let fusers = FUsers(firstname: firstname, lastname: lastname, fid: fid)
                            self.ListUsers.append(fusers)

                        }
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
                self.ComTableView.reloadData()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        ListUsers.removeAll()
        getListUsers()

        EditDeleteButton.isHidden = false
        if (UserSession.sharedInstance.news_user_id != UserSession.sharedInstance.id) {
            EditDeleteButton.isHidden = true
        }

        super.viewWillAppear(animated)
        PostLabel.text = UserSession.sharedInstance.news_content
        commentArray.removeAll()
        ComTableView.reloadData()
        customView()
        displayComment()
        ComTableView?.backgroundColor = UIColor.clear
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
