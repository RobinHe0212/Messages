//
//  ViewController.swift
//  Messages
//
//  Created by Robin He on 11/15/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(writeNewMessage))
       checkIfUserLoginIn()
            
            
        
    }
   @objc func writeNewMessage(){
    
        let contactController = UINavigationController(rootViewController: ContactController())
        present(contactController,animated: true,completion: nil)
        
    }
    
    func checkIfUserLoginIn(){
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
            
        }else {
            let userid = Auth.auth().currentUser?.uid
            let userInfo = Database.database().reference().child("userInfo").child(userid!).observe(.value) { (snapshot) in
                
                if let snapshotName = snapshot.value as? Dictionary<String,String> {
                let name = snapshotName["name"]
                self.navigationItem.title = name
                }else{
                    fatalError("Cannot transfer type")
                    return
                    
                }
            }
            
        }
        
    }

    @objc func handleLogOut(){
        do{
            try Auth.auth().signOut()
    
        }catch let signOuterror {
            print(signOuterror)
        }
        let login = LoginInController()
        present(login,animated: true,completion: nil)
    }
    
    
}

