//
//  LoginInController.swift
//  Messages
//
//  Created by Robin He on 11/15/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
class LoginInController : UIViewController {
    
    let inputContainerView : UIView = {
        let input = UIView()
        input.backgroundColor = .white
        input.layer.cornerRadius = 5
        input.layer.masksToBounds = true
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
        
    }()
    
    let nameTextField : UITextField = {
        let name = UITextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let emailTextField : UITextField = {
        let email = UITextField()
        email.placeholder = "Email address"
        email.keyboardType = .emailAddress
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let passWordTextField : UITextField = {
        let passWord = UITextField()
        passWord.placeholder = "Password"
        passWord.isSecureTextEntry = true
        passWord.translatesAutoresizingMaskIntoConstraints = false
        return passWord
    }()
    
    let namespaceLine : UIView = {
        
        let space = UIView()
        space.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        space.translatesAutoresizingMaskIntoConstraints = false
        return space
    }()
    
    let emailspaceLine : UIView = {
        
        let space = UIView()
        space.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        space.translatesAutoresizingMaskIntoConstraints = false
        return space
    }()
    lazy var imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pick")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
   
    
    let registerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var toggleButton : UISegmentedControl = {
        let toggle = UISegmentedControl(items: ["Register","Login"])
        toggle.selectedSegmentIndex = 0
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.tintColor = .white
        toggle.layer.cornerRadius = 5
        toggle.layer.masksToBounds = true
        toggle.addTarget(self, action: #selector(toggleSelect), for: .valueChanged)
        return toggle
        
        
    }()
    
    @objc func toggleSelect(){
        let title = toggleButton.titleForSegment(at: toggleButton.selectedSegmentIndex)
        
        registerButton.setTitle(title, for: .normal)
        //login trim
        
        inputContainerHeightAnchor?.constant = toggleButton.selectedSegmentIndex == 0 ? 150 : 100
        
        nameHeightAnchor?.isActive = false
        nameHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: toggleButton.selectedSegmentIndex == 0 ? 1/3 : 0)
        nameHeightAnchor?.isActive = true
        nameSpaceLineAnchor?.constant = toggleButton.selectedSegmentIndex == 0 ? 1 : 0
        emailHeightAnchor?.isActive = false
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: toggleButton.selectedSegmentIndex == 0 ? 1/3 : 1/2 )
        emailHeightAnchor?.isActive = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 155)
        
        view.addSubview(inputContainerView)
        setUpForInputContainerView()
        view.addSubview(registerButton)
        setUpForRegisterButton()
        view.addSubview(imageView)
        setUpForImage()
        view.addSubview(toggleButton)
        setUpForToggle()
    }
    
    func setUpForToggle(){
        toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toggleButton.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -15).isActive = true
        toggleButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        toggleButton.heightAnchor.constraint(equalToConstant: 40)
        
        
    }
    
    func setUpForImage(){
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        
    }
    
    func setUpForRegisterButton(){
        
        registerButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 10).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50)
        
    }
    
    var inputContainerHeightAnchor : NSLayoutConstraint?
    func setUpForInputContainerView(){
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightAnchor?.isActive = true
        
        view.addSubview(nameTextField)
        view.addSubview(namespaceLine)
        view.addSubview(emailTextField)
        view.addSubview(emailspaceLine)
        view.addSubview(passWordTextField)
        setUpForText()
    }
    var nameHeightAnchor : NSLayoutConstraint?
    var nameSpaceLineAnchor : NSLayoutConstraint?
    var emailHeightAnchor : NSLayoutConstraint?
    
    func setUpForText(){
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 14).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameHeightAnchor?.isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        namespaceLine.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        namespaceLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSpaceLineAnchor = namespaceLine.heightAnchor.constraint(equalToConstant: 1)
        nameSpaceLineAnchor?.isActive = true
        namespaceLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor)
        emailHeightAnchor?.isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailspaceLine.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailspaceLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailspaceLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailspaceLine.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        passWordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor).isActive = true
        passWordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passWordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
        passWordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    }
    
}


extension UIColor {
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat){
        self.init(red: r/255, green:g/255, blue: b/255, alpha: 1)
        
        
    }
    
    
    
}
