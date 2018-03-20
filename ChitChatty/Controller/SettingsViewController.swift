//
//  SettingsViewController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    var numberOfDataInSection = [[SettingsItems]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let com = [SettingsItems(itemSection: " ", itemTitle: "About Developer"), SettingsItems(itemSection: " ", itemTitle: "Feedback")]
        let res = [SettingsItems(itemSection: "Allow:", itemTitle: "Biometric Authentication"), SettingsItems(itemSection: "Allow:", itemTitle: "Image Downoading")]
        let aut = [SettingsItems(itemSection: "  ", itemTitle: "Password Reset")]
        
        numberOfDataInSection.append(com)
        numberOfDataInSection.append(res)
        numberOfDataInSection.append(aut)
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: Tableview
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return numberOfDataInSection[section].first?.itemSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfDataInSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfDataInSection[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsItem = numberOfDataInSection[indexPath.section][indexPath.row]
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = settingsItem.itemTitle
        return cell
    }
    
    
}
