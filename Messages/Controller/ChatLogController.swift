//
//  ChatLogController.swift
//  Messages
//
//  Created by Robin He on 11/22/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController : UICollectionViewController, UITextFieldDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    var msgAll = [Messages]()
    var user: Users? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
        
    }
    
    func observeMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid,let userId = user?.userId else{return}
        let ref = Database.database().reference().child("user-Messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
            let msgRef = Database.database().reference().child("Message").child(snapshot.key).observe(.value, with: { (ss) in
                
                guard let dic = ss.value as? [String:AnyObject] else{return}
                print(dic)
                let msg = Messages()
                msg.imageUrl = dic["imageUrl"] as? String
                msg.sendText = dic["sendtext"] as? String
                msg.timeStamp = dic["timeStamp"] as? NSNumber
                msg.fromId = dic["fromId"] as? String
                msg.toId = dic["toId"] as? String
                if msg.getPartnerId() == self.user?.userId {
                    self.msgAll.append(msg)
                    
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
                
               
            }, withCancel: nil)
        }, withCancel: nil)
        
        
    }
    
    let chatCellId = "chatCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
       collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.backgroundColor = .white
//        setUpchatLayout()
        
        collectionView.alwaysBounceVertical = true
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: chatCellId)
        
        collectionView.keyboardDismissMode = .interactive
       
        
    }
    
    @objc func tapUploadImage(){
        let imagePickerController = UIImagePickerController()
        present(imagePickerController,animated: true,completion:nil)
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        var selectedImage : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            selectedImage = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originalImage
        }
        if let selected = selectedImage {
            
            uploadFirebaseUsingImage(image:selected)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadFirebaseUsingImage(image:UIImage){
        
        let picId = NSUUID().uuidString
       let store = Storage.storage().reference().child("message_pic").child(picId)
    
        if let jpegImage =  image.jpegData(compressionQuality: 0.2){
            store.putData(jpegImage, metadata: nil) { (meta, err) in
                if err != nil {
                    fatalError()
                    return
                }
                store.downloadURL(completion: { (url, error) in
                    if error != nil {
                        fatalError()
                        return
                    }
                    if let imageUrl = url?.absoluteString {
                         self.sendImage(url: imageUrl)
                    }
                    
                   
                })
            }
            
        }
    }
    func sendImage(url:String){
        
        
        let msgData = Database.database().reference().child("Message").childByAutoId()
        let sendImageUrl = url
        let toId = user!.userId!
        let timestamp = String(NSDate().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser!.uid
        let values = ["timeStamp": timestamp,"fromId": fromId,"toId": toId,"imageUrl":sendImageUrl] as [String : Any]
        msgData.updateChildValues(values) { (error, ref) in
            if error != nil {
                fatalError()
                return
            }
            guard let msgId = msgData.key else{return}
            print(msgId)
            let userMsgRef = Database.database().reference().child("user-Messages").child(fromId).child(toId).child(msgId)
            
            userMsgRef.setValue(1)
            let toUserref = Database.database().reference().child("user-Messages").child(toId).child(fromId).child(msgId)
            toUserref.setValue(1)
            
            
            self.textMessage.text = ""
        }
        
        
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var uploadImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "upload_image")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUploadImage)))
        return image
        
        
    }()
    
    lazy var inputcontainerView : UIView = {
        
        let textContainer = UIView()
        textContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        textContainer.backgroundColor = .white
        
        textContainer.addSubview(uploadImage)
        textContainer.addSubview(textMessage)
        textContainer.addSubview(sendButton)
        textContainer.addSubview(seperateLine)
        
        uploadImage.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor).isActive = true
        uploadImage.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        textMessage.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor).isActive = true
        textMessage.leftAnchor.constraint(equalTo: uploadImage.rightAnchor, constant: 8).isActive = true
        textMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textMessage.rightAnchor.constraint(equalTo: textContainer.rightAnchor, constant :-68).isActive = true
        
        sendButton.rightAnchor.constraint(equalTo: textContainer.rightAnchor, constant: 0).isActive = true
        sendButton.heightAnchor.constraint(equalTo: textMessage.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor).isActive = true
        
        seperateLine.bottomAnchor.constraint(equalTo: textContainer.topAnchor).isActive = true
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperateLine.widthAnchor.constraint(equalTo: textContainer.widthAnchor).isActive = true
        seperateLine.leftAnchor.constraint(equalTo: textContainer.leftAnchor).isActive = true
        
        
        
        return textContainer
        
    }()
    
    override var inputAccessoryView: UIView?{
        
        get{
           return inputcontainerView
            
        }
        
    }
    override var canBecomeFirstResponder: Bool{
        
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatCell
        cell.textView.text = msgAll[indexPath.row].sendText
        let msage = msgAll[indexPath.row]
        setUpBubbleColor(message: msage, cell: cell)
        
        if let text = msgAll[indexPath.row].sendText {
            
            cell.bubblewidthAnchor?.constant = estimatedbubbleHeight(text: text).width + 32
            
        }
       
        
        
        return cell
    }
    
    func setUpBubbleColor(message:Messages,cell:ChatCell){
        
        if let profileimageUrl = user?.imageUrl {
             cell.imageProfile.loadImageUsingCacheFromUrl(urlString: profileimageUrl)
            
        }
        
        

        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatCell.bubbleOutgoingColor
            cell.textView.textColor = .white
            cell.bubbleleftAnchor?.isActive = false
            cell.bubblerightAnchor?.isActive = true
            cell.imageProfile.isHidden = true
        }else{
            cell.bubbleleftAnchor?.isActive = true
            cell.bubblerightAnchor?.isActive = false
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = .black
            cell.imageProfile.isHidden = false
        }
        if let messageImage = message.imageUrl {
            
            cell.messageImage.loadImageUsingCacheFromUrl(urlString: messageImage)
            cell.messageImage.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
            
        }else{
            
            cell.messageImage.isHidden = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msgAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height :CGFloat = 80
        if let text = msgAll[indexPath.row].sendText {
             height = estimatedbubbleHeight(text: text ).height+20
            
        }
       
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func estimatedbubbleHeight(text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
        
        
    }
    
    
    func setUpchatLayout(){
        
     //   view.addSubview(textContainer)
//        view.addSubview(textMessage)
//        view.addSubview(sendButton)
//        view.addSubview(seperateLine)
//        textContainer.widthAnchor.constraint(equalTo:  view.widthAnchor).isActive = true
//        textContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        textContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        textContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//
        textMessage.centerYAnchor.constraint(equalTo: textContainer.centerYAnchor).isActive = true
        textMessage.leftAnchor.constraint(equalTo: textContainer.leftAnchor, constant: 8).isActive = true
        textMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textMessage.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant :-68).isActive = true
        
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
            guard let msgId = msgData.key else{return}
            print(msgId)
        let userMsgRef = Database.database().reference().child("user-Messages").child(fromId).child(toId).child(msgId)
        
            userMsgRef.setValue(1)
        let toUserref = Database.database().reference().child("user-Messages").child(toId).child(fromId).child(msgId)
            toUserref.setValue(1)
            
            
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
