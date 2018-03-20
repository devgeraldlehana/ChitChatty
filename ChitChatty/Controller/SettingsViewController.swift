//
//  SettingsViewController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var settingsTable: UITableView!
    var numberOfDataInSection = [[SettingsItems]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let com = [SettingsItems(itemSection: " ", itemTitle: "About Developer"), SettingsItems(itemSection: " ", itemTitle: "Feedback")]
        var res = [SettingsItems]()
        if KeychainService.isBiometricsAvailable() {
            res.append(SettingsItems(itemSection: "Allow:", itemTitle: "Biometric Authentication"))
        }
        res.append(SettingsItems(itemSection: "Allow:", itemTitle: "Image Downoading"))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 { return }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                UIApplication.shared.open(URL(string: "https://www.linkedin.com/in/gerald-lehana-6b682961/")!, options: [:], completionHandler: nil)
            } else {
                generate(email: "iamgeraldlehana@gmail.com", subject: "Feedback")
            }
        } else {
            generate(email: "info@mobileexam.dstv.com", subject: "Password Reset")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsItem = numberOfDataInSection[indexPath.section][indexPath.row]
        if settingsItem.itemSection.contains("Allow") {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellBasicSwitch")
            cell.textLabel?.text = settingsItem.itemTitle
            
            let sv = UISwitch(frame: .zero)
            let udKey:UserDefaultsKeys = settingsItem.itemTitle.contains("Image") ? .ImageDownoading : .BiometricAuthentication
            sv.setOn(UserDefaults.standard.get(key: udKey), animated: false)
            sv.tag = udKey.rawValue
            sv.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.selectionStyle = .none
            cell.accessoryView = sv
            return cell
        } else {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellBasic")
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = settingsItem.itemTitle
            return cell
        }
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        guard let udKey = UserDefaultsKeys(rawValue: sender.tag) else { return }
        UserDefaults.standard.set(value: sender.isOn, forKey: udKey)
    }
    
    func generate(email: String, subject:String) {
        if !MFMailComposeViewController.canSendMail() {
            presentDialog(message: "Your device does not support emails.")
        } else {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject(subject)
            self.present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
