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
    
    let bubbleView : UIView = {
        let bubble = UIView()
        bubble.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        bubble.layer.cornerRadius = 16
        bubble.layer.masksToBounds = true
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
        
        
    }()
    var bubblewidthAnchor : NSLayoutConstraint?
    
    func setUpConstraints(){
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubblewidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubblewidthAnchor!.isActive = true
        bubbleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
