//
//  CustomCell.swift
//  Messages
//
//  Created by Robin He on 11/24/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
class CustomCell : UITableViewCell {
    
    var message : Messages?{
        didSet{
            
            
            if let id = message?.toId{
                let ref = Database.database().reference().child("userInfo").child(id).observe(.value, with: { (snapshot) in
                    print(snapshot.value!)
                    if let dictionary = snapshot.value as? [String:AnyObject]{
                        self.textLabel?.text = dictionary["name"] as? String
                        if let image = dictionary["imageUrl"] as? String{
                            
                            self.imageCell.loadImageUsingCacheFromUrl(urlString: image)
                        }
                    }
                    
                }, withCancel: nil)
                
                detailTextLabel?.text = message?.sendText
                
                
            }
            
            
        }
        
        
    }
    
    
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
