//
//  ChatLogController.swift
//  Messages
//
//  Created by Robin He on 11/22/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController : UICollectionViewController, UITextFieldDelegate{
    
    var user: Users? {
        didSet{
            navigationItem.title = user?.name
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setUpchatLayout()
        
    }
    
    func setUpchatLayout(){
        
        view.addSubview(textContainer)
        view.addSubview(textMessage)
        view.addSubview(sendButton)
        view.addSubview(seperateLine)
        textContainer.widthAnchor.constraint(equalTo:  view.widthAnchor).isActive = true
        textContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        textContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        textMessage.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor).isActive = true
        textMessage.leftAnchor.constraint(equalTo: textContainer.leftAnchor, constant: 8).isActive = true
        textMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textMessage.widthAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        sendButton.heightAnchor.constraint(equalTo: textMessage.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor).isActive = true
        
        seperateLine.bottomAnchor.constraint(equalTo: textContainer.topAnchor).isActive = true
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperateLine.widthAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        seperateLine.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        
        
        
    }
    
    let seperateLine : UIView = {
        let sl = UIView()
        sl.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        sl.translatesAutoresizingMaskIntoConstraints = false
        return sl
    
    }()
     let sendButton : UIButton = {
        let send = UIButton(type: .system)
        send.setTitle("Send", for: .normal)
        send.translatesAutoresizingMaskIntoConstraints = false
        send.addTarget(self, action: #selector(tapSend), for: .touchUpInside)
        return send

    }()
    @objc func tapSend(){
        
        let msgData = Database.database().reference().child("Message").childByAutoId()
        let sendText = textMessage.text!
        let toId = user!.userId!
        let timestamp = String(NSDate().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser!.uid
        let values = ["timeStamp": timestamp,"fromId": fromId,"toId": toId,"sendtext":sendText] as [String : Any]
        msgData.updateChildValues(values) { (error, ref) in
            if error != nil {
                fatalError()
                return
            }
            self.textMessage.text = ""
        }
        
       
        
    }
    
   lazy var textMessage : UITextField = {
        let msg = UITextField()
        msg.placeholder = "Enter Message..."
        msg.translatesAutoresizingMaskIntoConstraints = false
        msg.delegate = self
        return msg
        
    }()
    
    let textContainer : UIView = {
        let text = UIView()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
        
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapSend()
        return true
        
    }
}
