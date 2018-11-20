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
        tableView.register(CustomerCell.self, forCellReuseIdentifier: cellId)
        fetchData()
    }
    
    @objc func cancelContact(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func fetchData(){
    
        
        let auth = Database.database().reference().child("userInfo").observe(.childAdded) { (snapshot) in
          
            if let dic = snapshot.value as? Dictionary<String,String> {
                print(dic)
                let oneUser = Users()
                
                oneUser.name = dic["name"]
                print(oneUser.name!)
                oneUser.email = dic["email"]
                oneUser.imageUrl = dic["imageUrl"]
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomerCell
        
        cell.textLabel?.text = user[indexPath.row].name
        cell.detailTextLabel?.text = user[indexPath.row].email

        if let imageProfile = user[indexPath.row].imageUrl {

            cell.imageCell.loadImageUsingCacheFromUrl(urlString: imageProfile)
        }


        return cell
    }
    
}

class CustomerCell : UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y-2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
        
        
    }
    
    let imageCell : UIImageView = {
        let img = UIImageView()
        
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
        return img
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(imageCell)
        imageCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imageCell.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageCell.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageCell.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
