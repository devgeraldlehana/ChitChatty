//
//  LoginViewController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    var guid:String?
    var lastname:String?
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = login.frame.height - 20
        let ui = UIImage(named: "username")?.resizeImage(targetSize: CGSize(width: size, height: size))
        let pi = UIImage(named: "password")?.resizeImage(targetSize: CGSize(width: size, height: size))
        username.addPaddingLeftIcon(ui!, padding: 10.0)
        password.addPaddingLeftIcon(pi!, padding: 10.0)
        
        username.text = "user"
        password.text = "1234"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if KeychainService.isBiometricsAvailable() {
            guard let ksUsername = KeychainService.retrieveDefault() else { return }
            KeychainService.biometricValidation(withReason: "Show me your 👍🏽 bro!!!!!", completion: { result in
                DispatchQueue.main.async {
                    if result {
                        guard let ksPassword = KeychainService.loadPassword(account: ksUsername) else { return }
                        self.username.text = ksUsername
                        self.password.text = ksPassword
                        self.login(animated)
                    } else {
                        self.presentDialog(message: "Biometric validation failed, please enter your credentials manually.")
                    }
                }
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segTabs" {
            guard let tc = segue.destination as? UITabBarController else { return }
            guard let nc = tc.viewControllers![0] as? UINavigationController else { return }
            guard let vc = nc.viewControllers[0] as? FriendsViewController else { return }
            vc.guid = guid
            vc.lastname = lastname
        }
    }
    
    // MARK: - Actions
    @IBAction func login(_ sender: Any) {
        if username.isEmpty {
            presentDialog(message: "Please enter a username before proceeding.")
        } else if password.isEmpty {
            presentDialog(message: "Please enter a password before proceeding.")
        } else {
            guard let utext = username.text else { return }
            guard let ptext = password.text else { return }
            makeNetworkRequest(withUsername: utext, andPassword: ptext)
        }
    }
    
    // MARK: - Webservices
    func makeNetworkRequest(withUsername u:String, andPassword p:String){
        let busyIndicator = UIViewController.displaySpinner(onView: self.view, title: "Logging in.")
        NetworkController.login(withUsername: u, andPassword: p) { logInfo in
            if let status = logInfo?.result {
                if !status {
                    if let message = logInfo?.error {
                        self.presentDialog(message: message)
                    }
                } else {
                    self.guid = logInfo?.guid
                    self.lastname = logInfo?.lastName
                    self.manage(username: u, andPassword: p)
                }
            } else {
                self.presentDialog(message: "Unexpected data received.")
            }
        }
        UIViewController.removeSpinner(spinner: busyIndicator)
    }
    
    // MARK: - Authentication
    func manage(username:String, andPassword password:String){
        if KeychainService.isBiometricsAvailable() {
            if let ksUsername = KeychainService.retrieveDefault() {
                if ksUsername.elementsEqual(username){
                    guard let ksPassword = KeychainService.loadPassword(account: ksUsername) else { return }
                    if !ksPassword.elementsEqual(password){
                        KeychainService.updatePassword(account: ksUsername, data: password)
                    }
                } else {
                    KeychainService.removePassword(account: ksUsername)
                    KeychainService.saveDefault(username: username, password: password)
                }
            } else {
                KeychainService.saveDefault(username: username, password: password)
            }
        }
        self.performSegue(withIdentifier: "segTabs", sender: nil)
    }
}
