//
//  FriendsDetailsViewController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

class FriendsDetailsViewController: BaseViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusTxt: UILabel!
    
    var friend:Friends?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let frnd = friend else {
            presentDialog(message: "Unexpected error.")
            return
        }
        self.title = frnd.alias
        setImage(view: image, usingAlias: frnd.alias, orUrl: frnd.imageURL, size: CGSize(width: 100, height: 100))
        fullname.text = "\(frnd.firstName) \(frnd.lastName)"
        username.text = frnd.alias
        dob.text = frnd.dateOfBirth
        if frnd.status.elementsEqual("Busy") {
            statusImg.image = UIImage(named: "busy")
            statusTxt.text = frnd.status
        } else if frnd.status.elementsEqual("Away") {
            statusImg.image = UIImage(named: "away")
            statusTxt.text = frnd.status
        }
    }
}
