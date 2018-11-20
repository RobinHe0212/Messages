//
//  LoginController+imageHandler.swift
//  Messages
//
//  Created by Robin He on 11/19/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
extension LoginInController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @objc func tapImage(){
        
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = true
                present(imagePickerController,animated: true,completion: nil)
        
        
    }
    @objc func handleRegister(){
        
        
        guard let email = emailTextField.text, let password = passWordTextField.text, let name = nameTextField.text else{
            
            fatalError("form is not correct")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let uid = user?.user.uid else{
                fatalError()
            }
            //store imageurl in storage
              let uniqueUid = NSUUID().uuidString
            var imageUrl : String?
            let store = Storage.storage().reference().child("imageFile/\(uniqueUid).png")
            if let picUpload = self.imageView.image!.pngData() {
                store.putData(picUpload, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        fatalError("cannot save data, error is \(err)")
                        return
                    }else {
                        store.downloadURL(completion: { (url, error) in
                            if error != nil {
                                fatalError("error exist")
                                return
                            }else{
                                print(url!)
                                imageUrl = url?.absoluteString
                               
                                let values =  ["name" : name, "email" : email,"imageUrl":imageUrl] as? [String : AnyObject]
                                 self.saveUserInfo(value: values!  , uid: uid)
                            }
                        })
                        
                    }
                })
                
            }
            
            
            
                
           
            
        }
        
    }
    
    func saveUserInfo(value:[String: AnyObject],uid:String){
        
        //save user info (name , email into database)
        let messageDB = Database.database().reference().child("userInfo").child(uid)
        
        
        messageDB.updateChildValues(value, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImagePicker : UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            selectedImagePicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                
                selectedImagePicker = originalImage
            }
        if let selectImage = selectedImagePicker {
            imageView.image = selectedImagePicker
        }
        
        
      dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
