//
//  LoginViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/20/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Lottie

// TODO: Auth at https://firebase.google.com/docs/auth/ios/password-auth

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {
    
    // Textfield for email
    private let emailTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "email"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 28)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .left
        textField.tag = 0
        return textField
    }()
    
    // Textfield for password
    private let passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "password"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 28)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.isSecureTextEntry = true
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .left
        textField.tag = 1
        return textField
    }()
    
    // Textfield for confirm password
    private let confirmPasswordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "confirm password"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 28)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.isSecureTextEntry = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .left
        textField.tag = 2
        return textField
    }()
    
    // Log in or sign up button
    let logInButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .selected)
        button.setBackgroundColor(color: #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1), forState: .selected)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 30)
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        button.addTarget(self, action: #selector(loginButtonEnded), for: .touchUpInside)
        button.addTarget(self, action: #selector(loginButtonEnded), for: .touchDragExit)
        button.addTarget(self, action: #selector(loginButtonBegan), for: .touchDown)
        return button
    }()
    
    // Log in or sign up button with google
    let googleButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(#colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitle("Google Sign In", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 30)
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        button.addTarget(self, action: #selector(googleButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(googleButtonPressed), for: .touchDragExit)
        button.addTarget(self, action: #selector(googleButtonPressedBegan), for: .touchDown)
        return button
    }()
    
    // Input fields container
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
    // Lottie animation
    let backgroundAnimation =  LOTAnimationView(name: "background")
    
    // Stuff for firebase
    var ref: DatabaseReference!
    var isSignedIn = false
    var username: String?
    var email: String?
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        addViewComponents()
    }
    
    func addViewComponents() {
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        
        // Adding all Subviews
        view.addSubview(backgroundAnimation)
        view.addSubview(googleButton)
        view.addSubview(logInButton)
        view.addSubview(inputContainer)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        
        // Animation settings
        backgroundAnimation.fillSuperview()
        backgroundAnimation.loopAnimation = true
        backgroundAnimation.contentMode = .scaleAspectFit
        backgroundAnimation.play()
        
        // All constraints:
        
        // Google button
        googleButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 60, right: 0), size: .init(width: view.bounds.width - 60, height: 0))
        googleButton.centerHorizontalOfView(to: view)
        
        // Login Button
        logInButton.anchor(top: nil, leading: nil, bottom: googleButton.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 30, right: 0), size: .init(width: view.bounds.width - 60, height: 0))
        logInButton.centerHorizontalOfView(to: view)
        
        // Input container
        
        inputContainer.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: logInButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 120, left: 30, bottom: 30, right: 30))
        
        // Inputs
        let inputStack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,confirmPasswordTextField])
        inputStack.spacing = 10
        inputStack.distribution = .fillEqually
        inputStack.axis = .vertical
        view.addSubview(inputStack)
        
        
        inputStack.anchor(top: inputContainer.topAnchor, leading: inputContainer.leadingAnchor, bottom: inputContainer.bottomAnchor, trailing: inputContainer.trailingAnchor, padding: .init(top: 60, left: 10, bottom: 60, right: 10))
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        // Adding underlines
        for i in 0...2 {
            let underline = UIView()
            underline.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
            view.addSubview(underline)
            if i == 0 {
                underline.anchor(top: emailTextField.bottomAnchor, leading: inputStack.leadingAnchor, bottom: nil, trailing: inputStack.trailingAnchor,padding: .init(top: -30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 3))
            }
            else if i == 1 {
                underline.anchor(top: passwordTextField.bottomAnchor, leading: inputStack.leadingAnchor, bottom: nil, trailing: inputStack.trailingAnchor,padding: .init(top: -30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 3))
            }
            else if i == 2 {
                underline.anchor(top: confirmPasswordTextField.bottomAnchor, leading: inputStack.leadingAnchor, bottom: nil, trailing: inputStack.trailingAnchor,padding: .init(top: -30, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 3))
            }
        }
    }
    
    @objc func loginButtonEnded() {
        logInButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @objc func loginButtonBegan() {
        logInButton.backgroundColor = #colorLiteral(red: 0.9433736205, green: 0.9435314536, blue: 0.9433527589, alpha: 1)

    }
    
    @objc func googleButtonPressedBegan() {
        googleButton.backgroundColor = #colorLiteral(red: 0.9433736205, green: 0.9435314536, blue: 0.9433527589, alpha: 1)
    }
    
    @objc func googleButtonPressed() {
        googleButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Configure Google Sign In
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Problem at signing in with google with error : \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Problem at signing in with google in Auth with error : \(error)")
                return
            }
            // User is signed in
            self.isSignedIn = true
            
            print("User Logged in.")
            self.username = Auth.auth().currentUser?.displayName
            self.email = Auth.auth().currentUser?.email
            self.uid = Auth.auth().currentUser?.uid
            print("user successfully signed in through GOOGLE! uid:\(String(describing: Auth.auth().currentUser!.email))")
            
            //            self.readPropertiesFromDatabase()
            
            // Logins automatically after sign in.
//            self.loadNextView()
        }
    }
    
    // Action when begins to edit any textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
    }
    
    // Hide keyboard when return is pressed on any keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            loginButtonEnded()
            textField.resignFirstResponder()
        }
        // Do
        return false
    }
}

