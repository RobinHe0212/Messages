//
//  ChatCell.swift
//  Messages
//
//  Created by Robin He on 11/29/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
class ChatCell : UICollectionViewCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(imageProfile)
        bubbleView.addSubview(messageImage)
        setUpConstraints()
    }
    let textView : UITextView = {
        
        let text = UITextView()
        text.text = "sample code"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .clear
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = .white
        return text
        
        
    }()
    
    let messageImage : UIImageView = {
        let image = UIImageView()
      //  image.backgroundColor = .brown
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
        
    }()
    
    let imageProfile : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "flower")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        return img
        
        
        
    }()
    
    static let bubbleOutgoingColor = UIColor(r: 0, g: 137, b: 249)
    let bubbleView : UIView = {
        let bubble = UIView()
        bubble.backgroundColor = bubbleOutgoingColor
        bubble.layer.cornerRadius = 16
        bubble.layer.masksToBounds = true
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
        
        
    }()
    var bubblewidthAnchor : NSLayoutConstraint?
    var bubbleleftAnchor : NSLayoutConstraint?
    var bubblerightAnchor : NSLayoutConstraint?
    
    func setUpConstraints(){
        
        messageImage.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImage.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImage.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImage.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubblerightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubblerightAnchor!.isActive = false
        bubbleleftAnchor = bubbleView.leftAnchor.constraint(equalTo: imageProfile.rightAnchor, constant: 8)
        bubbleleftAnchor!.isActive = false
        
        bubblewidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubblewidthAnchor!.isActive = true
        bubbleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        imageProfile.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageProfile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        imageProfile.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageProfile.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
