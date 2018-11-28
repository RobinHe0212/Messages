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
                setupNameAndProfileImage()
                detailTextLabel?.text = message?.sendText
                if let timeSeconds = message?.timeStamp?.doubleValue {
                    let timestampDate = NSDate(timeIntervalSince1970: timeSeconds) as Date
                    let dataFormatter = DateFormatter()
                    dataFormatter.dateFormat = "HH:mm MM-dd"
                    timeLabel.text = dataFormatter.string(from: timestampDate)
                }
               
                
                
                
            
            
            
        }
        
        
    }
    
    func setupNameAndProfileImage(){
        let partnerId : String?
        print("fromId \(message?.fromId)")
        print("current \(Auth.auth().currentUser?.uid)")
        if message?.fromId == Auth.auth().currentUser?.uid {
            partnerId = message?.toId
            print("from : \(partnerId)")
        }else{
            partnerId = message?.fromId
             print("to : \(partnerId)")
        }
        
        if let id = partnerId{
            let ref = Database.database().reference().child("userInfo").child(id).observe(.value, with: { (snapshot) in
                print("check fromTo \(snapshot.value!)")
                if let dictionary = snapshot.value as? [String:AnyObject]{
                    self.textLabel?.text = dictionary["name"] as? String
                    if let image = dictionary["imageUrl"] as? String{
                        
                        self.imageCell.loadImageUsingCacheFromUrl(urlString: image)
                        
                    }
                }
                
            }, withCancel: nil)
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
    
    let timeLabel : UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(imageCell)
        imageCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imageCell.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageCell.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageCell.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 15).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
