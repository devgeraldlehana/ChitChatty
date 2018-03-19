//
//  FriendsViewController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

class FriendsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cache = NSCache<NSString, UIImage>()
    
    var guid:String?
    var lastname:String?
    var friends = [Friends]()
    @IBOutlet weak var friendsTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableview.tableFooterView = UIView(frame: .zero)
        guard let gd = guid else { return }
        guard let ln = lastname else { return }
        showBusyIndicator(withTitle: "Loading Friends...")
        NetworkController.retrieveFriends(withGUID: gd, andLastname: ln) { friends in
            if let status = friends?.result {
                if !status {
                    if let message = friends?.error {
                        self.presentDialog(message: message)
                    }
                } else {
                    if let flist = friends?.friends{
                        self.friends = flist
                        self.friendsTableview.reloadData()
                    }                }
            } else {
                self.presentDialog(message: "Unexpected data received.")
            }
        }
        dismissBusyIndicator()
    }
    
    //MARK: Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        let alias = friend.alias
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.textColor = UIColor.chitChattyBlack
        cell.textLabel?.text = "\(friend.firstName) \(friend.lastName)"
        cell.detailTextLabel?.textColor = UIColor.chitChattyBlue
        cell.detailTextLabel?.text = "\(alias)"
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(named: "placeholder")?.resizeImage(targetSize: CGSize(width: 40, height: 40))
        let cacheKey: NSString = NSString(string: alias)
        if let cachedImage = self.cache.object(forKey: cacheKey) {
            cell.imageView?.image =  cachedImage
        } else {
            NetworkController.image(fromUrl: friend.imageURL, completion: { image in
                guard let img = image?.resizeImage(targetSize: CGSize(width: 40, height: 40)) else { return }
                cell.imageView?.image = img
                self.cache.setObject(img, forKey: cacheKey)
            })
        }
        return cell
    }
}
