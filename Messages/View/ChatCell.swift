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
        addSubview(textView)
        setUpConstraints()
    }
    let textView : UITextView = {
        
        let text = UITextView()
        text.text = "sample code"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .blue
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = .white
        return text
        
        
    }()
    
    func setUpConstraints(){
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: 8).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
