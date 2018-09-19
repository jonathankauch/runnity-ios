//
//  AddCommentViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 14/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddCommentViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var addCommentTV: UITextView!

    @IBOutlet weak var addComment: MyButton!
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }

    @IBAction func ActionAdd(_ sender: Any) {
        PushNewComment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView()
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
    
    func PushNewComment() {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token
            ]
        
        let params: [String: Any] =
            [
                "content": addCommentTV.text,
                "user_token": UserSession.sharedInstance.token,
                "user_id" : UserSession.sharedInstance.id,
                "post_id" : UserSession.sharedInstance.news_id,
                "user_email" : UserSession.sharedInstance.email
                ]
        
        
        let tmp = String(UserSession.sharedInstance.news_id)
        
        let edit_url = "https://runitv2.herokuapp.com/api/v1/comments?/" + tmp;
        
        Alamofire.request(edit_url, method: .post,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Success add new comment!")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
