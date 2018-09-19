//
//  EditPostViewController.swift
//  runit
//
//  Created by Jean-Paul Saysana on 14/12/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

    
class EditPostViewController: UIViewController   {
    
    @IBOutlet weak var editBtn: UIButton!

    @IBOutlet weak var deleteBtn: UIButton!

    @IBOutlet weak var editInput: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func customView() {
        //self.view.backgroundColor = RIColors.LIGHTGRAY
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserSession.sharedInstance.news_content != "") {
                editInput.text = UserSession.sharedInstance.news_content
            }
        if (UserSession.sharedInstance.news_date != "") {
            dateLabel.text = UserSession.sharedInstance.news_date
        }
        customView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Actions

    @IBAction func EditClicked(_: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        let params: [String: Any] =
            [
                "content": editInput.text
            ]
        
        
        let tmp = String(UserSession.sharedInstance.news_id)
        
        let edit_url = "https://runitv2.herokuapp.com/api/v1/posts/" + tmp;
        
        Alamofire.request(edit_url, method: .put,
                          parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Success edit!")
                    self.goBack()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func goBack() {
        self.performSegue(withIdentifier: "prepareForUnwind", sender: self)
    }
    
    @IBAction func DeleteClicked(_ _: Any) {
        let headers = [
            "X-User-Email": UserSession.sharedInstance.email,
            "X-User-Token": UserSession.sharedInstance.token,
            ]
        
        
        let tmp = String(UserSession.sharedInstance.news_id)
        
        let edit_url = "https://runitv2.herokuapp.com/api/v1/posts/" + tmp;
        
        Alamofire.request(edit_url, method: .delete, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("Delete Success!")
                    UserSession.sharedInstance.news_id = 0
                    UserSession.sharedInstance.news_content = ""
                    UserSession.sharedInstance.news_user = ""
                        self.goBack()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
}
