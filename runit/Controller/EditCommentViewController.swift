//
//  EditCommentViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 14/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditCommentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var CommentTV: UITextView!
    @IBOutlet weak var commentDateLabel: UILabel!
    
    @IBOutlet weak var DeleteButton: UIButton!
    
    @IBAction func DeleteCommentAction(_ sender: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        let comment_id = String(UserSession.sharedInstance.comment_id)
        let edit_url = "https://runitv2.herokuapp.com/api/v1/comments/" + comment_id;
        
        Alamofire.request(edit_url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Comment deleted!")
                    self.goBack()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    
    @IBOutlet weak var ModifyButton: UIButton!
    
    
    @IBAction func ModifyCommentAction(_ sender: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
        ]
        
  /*
        let params: [String: Any] =
            [
                "comment[content]": CommentTV.text,
                "comment[user_id]" : UserSession.sharedInstance.id,
                "comment[post_id]" : UserSession.sharedInstance.news_id
        ]
*/
        let dict = [
                        "content": CommentTV.text,
                        "user_id": UserSession.sharedInstance.id,
                        "post_id": UserSession.sharedInstance.news_id
            ] as [String : Any]

        let json = JSON(dict)

        let representation = json.rawString([.castNilToNSNull: true])

        let params: [String: Any] =
            [
                "comment": representation
            ]
        let comment_id = String(UserSession.sharedInstance.comment_id)
        let edit_url = "https://runitv2.herokuapp.com/api/v1/comments/" + comment_id;
        
        Alamofire.request(edit_url, method: .put,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Success. Comment edited.")
                    let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.goBack()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayComment()
        // Do any additional setup after loading the view.
    }
    
    func DisplayComment() {
        CommentTV.text = UserSession.sharedInstance.comment_content
        commentDateLabel.text =
            UserSession.sharedInstance.comment_date
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
