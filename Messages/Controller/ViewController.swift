//
//  ViewController.swift
//  Messages
//
//  Created by Robin He on 11/15/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
    }

    @objc func logOut(){
        let loginController = LoginInController()
        present(loginController,animated: true,completion: nil)
        
    }
}

