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

    var msg = [Messages]()
    let customCellId = "cusCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(writeNewMessage))
       checkIfUserLoginIn()
            
     //   loadMessageAndContact()
        
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: customCellId)
       
        
    }
    var messageDictionary = [String:Messages]()
    
    
    func loadMessageAndMultiplyUserSupport(){
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        let msgUser = Database.database().reference().child("user-Messages").child(currentUserId).observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-Messages").child(currentUserId).child(userId).observe(.childAdded, with: { (snap) in
                let msgId = snap.key
                
                Database.database().reference().child("Message").child(msgId).observe(.value, with: { (sc) in
                    
                    let ss = sc.value as! [String:AnyObject]
                    let mess = Messages()
                    mess.fromId = ss["fromId"] as? String
                    mess.sendText = ss["sendtext"] as? String
                    mess.toId = ss["toId"] as? String
                    mess.timeStamp = ss["timeStamp"] as? NSNumber
                    print("timeStamp \(mess.timeStamp?.stringValue)")
                    
                    if let partnerId = mess.getPartnerId() {
                        
                        self.messageDictionary[partnerId] = mess
                        self.msg = Array(self.messageDictionary.values)
                        
                        
                        self.msg.sort(by: { (m1, m2) -> Bool in
                            let ts1value : Int
                            let ts2value : Int
                            if let ts1 = m1.timeStamp {
                                ts1value = ts1.intValue
                                if let ts2 = m2.timeStamp {
                                    ts2value = ts2.intValue
                                    
                                    return ts1value > ts2value
                                }
                            }
                            
                            return true
                        })
                    }
                    DispatchQueue.main.async {
                        print("print in the console")
                        self.tableView.reloadData()
                    }
                })
                
                
                
            }, withCancel: nil)
            
            
            
            
           
        }, withCancel: nil)
        
       
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! CustomCell
        let message = msg[indexPath.row]
        
        customCell.message = message
        return customCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let messag =  msg[indexPath.row]
        
        guard let partnerId = messag.getPartnerId() else{return}
        let user = Database.database().reference().child("userInfo").child(partnerId).observe(.value, with: { (snapshot) in
            guard let dic = snapshot.value as? [String:AnyObject] else{return}
            let use = Users()
            use.email = dic["name"] as? String
            use.imageUrl = dic["imageUrl"] as? String
            use.name = dic["name"] as? String
            use.userId = partnerId
        
            self.tapToMessage(user: use)
            
        }, withCancel: nil)
        
       
    }
    
   @objc func writeNewMessage(){
        let contact = ContactController()
        contact.msgController = self
        let contactController = UINavigationController(rootViewController: contact)
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
    
   
    
     func tapToMessage(user:Users){
        let chatController = ChatLogController(collectionViewLayout:UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
        
    }
    
    
    
    
    func setUpNavIconAndName(user:Users){
        
        msg.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()

        loadMessageAndMultiplyUserSupport()
        
        let titleContainer = UIView()
        titleContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToMessage)))

        
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

