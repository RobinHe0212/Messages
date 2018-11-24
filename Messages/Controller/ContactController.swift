//
//  ContactController.swift
//  Messages
//
//  Created by Robin He on 11/17/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
class ContactController : UITableViewController{
    
    let cellId = "cellId"
    
    var user = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelContact))
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        fetchData()
    }
    
    @objc func cancelContact(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func fetchData(){
    
        
        let auth = Database.database().reference().child("userInfo").observe(.childAdded) { (snapshot) in
          
            if let dic = snapshot.value as? Dictionary<String,String> {
//                print(dic)
                
                let oneUser = Users()
                
                oneUser.name = dic["name"]
                print(oneUser.name!)
                oneUser.email = dic["email"]
                oneUser.imageUrl = dic["imageUrl"]
                oneUser.userId = snapshot.key
                self.user.append(oneUser)
                
                self.tableView.reloadData()
            }else{
                
                fatalError("cannot cast type")
                return
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  100
    }
    
    var msgController : MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        print("dismiss success")
        let navUser = user[indexPath.row]
        
            self.msgController?.tapToMessage(user:navUser)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        
        cell.textLabel?.text = user[indexPath.row].name
        cell.detailTextLabel?.text = user[indexPath.row].email

        if let imageProfile = user[indexPath.row].imageUrl {

            cell.imageCell.loadImageUsingCacheFromUrl(urlString: imageProfile)
        }


        return cell
    }
    
}

