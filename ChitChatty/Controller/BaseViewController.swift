//
//  BaseViewController.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var busyIndicator:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showBusyIndicator(withTitle:String) {
        busyIndicator = UIViewController.displaySpinner(onView: self.view, title: withTitle)
    }
    
    func dismissBusyIndicator(){
        guard let view = busyIndicator else { return }
        UIViewController.removeSpinner(spinner: view)
    }
}

