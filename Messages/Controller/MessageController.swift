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
            fetchUserDataAndNavBar()
            
        }
        
    }

    func fetchUserDataAndNavBar(){
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
            
        }
        
        let userid = Auth.auth().currentUser?.uid
        let userInfo = Database.database().reference().child("userInfo").child(userid!).observe(.value) { (snapshot) in
            
            if let snapshotName = snapshot.value as? Dictionary<String,String> {
                let name = snapshotName["name"]
             //   self.navigationItem.title = name
                let profileImage = snapshotName["imageUrl"]
                let user = Users()
                user.imageUrl = profileImage
                user.name = name
                self.setUpNavIconAndName(user:user)
            }else{
                fatalError("Cannot transfer type")
                return
                
            }
        
    }
    
    }
    
    func setUpNavIconAndName(user:Users){
        
        let titleContainer = UIView()
        titleContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        titleContainer.addSubview(container)
        let icon = UIImageView()
        if let imageDownload = user.imageUrl {
            icon.loadImageUsingCacheFromUrl(urlString: imageDownload)}
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 20
        icon.layer.masksToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(icon)
        
        let textView = UILabel()
        if let text = user.name {
            textView.text = text
        }
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        container.addSubview(textView)
        self.navigationItem.titleView = titleContainer
        
        icon.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textView.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        
        container.centerXAnchor.constraint(equalTo:titleContainer.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor).isActive = true
        
        
    }
    
    @objc func handleLogOut(){
        do{
            try Auth.auth().signOut()
    
        }catch let signOuterror {
            print(signOuterror)
        }
        let login = LoginInController()
        login.messageController = self
        present(login,animated: true,completion: nil)
    }
    
    
}

