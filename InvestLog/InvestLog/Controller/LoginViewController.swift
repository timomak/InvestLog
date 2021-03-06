//
//  LoginViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/20/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn
import Lottie
import SnapKit
import FirebaseAuth
import KeychainSwift


/// This View Controller handles Log in / Sign up / Google log in and getting DATABASE data.
class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {
    
    /// Handles transitions by the BackgroundViewController
    var delegate: VCHandler?
    
    /// To Save data with Keychain
    let keychain = KeychainSwift()
    
    /// Textfield for email
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
    
    /// Textfield for password
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
    
    /// Textfield for confirm password
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
    
    /// Log in or sign up button
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
    
    /// Log in or sign up button with google
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
    
    /// Input fields container
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
    /// logo Container
    let logoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 63
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
    /// Logo Animation
    let logoImage = LOTAnimationView(name: "loading")
    
    /// Checks if the next view can be presented.
    var canLoadNextView = false
    
    
    /// Error label
    let errorLabel: UITextView = {
        var title = UITextView()
        title.text = "Error"
        title.font = UIFont(name: "AvenirNext-Bold", size: 15)
        title.textColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        title.isHidden = true
        return title
    }()
    
    /// Error text
    var errorText: String = "" {
        didSet {
            errorLabel.isHidden = false
            errorLabel.text = errorText
            logoImage.loopAnimation = false
        }
    }
    
    /// Constant to set font size relative for device.
    let relativeFontConstant:CGFloat = 0.036
    
    // Stuff for firebase
    var ref: DatabaseReference!
    var isSignedIn = false
    var username: String?
    var email: String?
    var uid: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Set each label's font size relative to the screen size
        let textLabels = [emailTextField, passwordTextField, confirmPasswordTextField]
        
        let buttons = [googleButton, logInButton]
        
        for label in textLabels {
            label.font = label.font!.withSize(self.view.frame.height * relativeFontConstant)
        }
        
        for button in buttons {
            button.titleLabel?.font = button.titleLabel?.font.withSize(self.view.frame.height * relativeFontConstant)
        }
        addViewComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("Trying to log in")
//        guard let userData = UserDefaults.standard.dictionary(forKey: "userData") as? [String:String]
//            else { return }
        
        let tempEmail = keychain.get("email") ?? ""

        let tempPassword = keychain.get("password") ?? ""
        
        logoImage.loopAnimation = true
        
        // After the animation finshed last loop.
        logoImage.play { (finished) in
            if self.canLoadNextView == true {
                self.moveToNextView()
            }
        }

//        let currentEmail = userData["email"]
//        let currentPassword = userData["password"]
//
        if tempEmail != "" {
            firebaseLogIn(userEmail: tempEmail, userPassword: tempPassword)
        }
        
        
    }
    
    func addViewComponents() {
        view.backgroundColor = UIColor.clear
        
        // Adding all Subviews
        view.addSubview(googleButton)
        view.addSubview(logInButton)
        view.addSubview(inputContainer)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(logoContainer)
        view.addSubview(logoImage)
        view.addSubview(errorLabel)
        
        logoImage.contentMode = .scaleAspectFit
        
        logoContainer.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.bounds.width / 3)
            make.height.equalTo(logoContainer.snp.width)
        }
        logoContainer.layer.cornerRadius = (view.bounds.width / 3) / 2
        
        logoImage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(logoContainer)
            make.height.equalTo(logoContainer).offset(-4)
            make.width.equalTo(logoImage.snp.height)
        }
        
        googleButton.snp.makeConstraints { (make) in
            make.width.equalTo(view.bounds.width / 1.12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset((view.bounds.width / 12) * -1)
        }
        
        logInButton.snp.makeConstraints { (make) in
            make.width.equalTo(googleButton.snp.width)
            make.centerX.equalTo(googleButton.snp.centerX)
            make.bottom.equalTo(googleButton.snp.top).offset((view.bounds.width / 20) * -1)
        }
        
        inputContainer.snp.makeConstraints { (make) in
            make.top.equalTo(logoContainer.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(view.bounds.width / 12)
            make.right.equalToSuperview().offset((view.bounds.width / 12) * -1)
            make.bottom.equalTo(logInButton.snp.top).offset((view.bounds.width / 12) * -1)
        }
        
        // Inputs
        let inputStack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,confirmPasswordTextField])
        inputStack.spacing = view.bounds.width / 10
        inputStack.distribution = .fillEqually
        inputStack.axis = .vertical
        view.addSubview(inputStack)

        inputStack.snp.makeConstraints { (make) in
            make.top.left.equalTo(inputContainer).offset(15)
            make.right.bottom.equalTo(inputContainer).offset(-15)
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        // Adding underlines
        for i in 0...2 {
            let underline = UIView()
            underline.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
            view.addSubview(underline)
            if i == 0 {
                underline.snp.makeConstraints { (make) in
                    make.top.equalTo(emailTextField.snp.bottom).offset(-15)
                    make.left.equalTo(emailTextField)
                    make.right.equalTo(emailTextField)
                    make.height.equalTo(3)
                }
            }
            else if i == 1 {
                underline.snp.makeConstraints { (make) in
                    make.top.equalTo(passwordTextField.snp.bottom).offset(-15)
                    make.left.equalTo(passwordTextField)
                    make.right.equalTo(passwordTextField)
                    make.height.equalTo(3)
                }
            }
            else if i == 2 {
                underline.snp.makeConstraints { (make) in
                    make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(-15)
                    make.left.equalTo(confirmPasswordTextField)
                    make.right.equalTo(confirmPasswordTextField)
                    make.height.equalTo(3)
                }
            }
        }
        
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inputContainer.snp.top).offset(3)
            make.left.right.equalToSuperview()
        }
    }
}

extension LoginViewController {
    
    func arePasswordsMatching() -> Bool {
        if passwordTextField.text == "" || emailTextField.text == "" || confirmPasswordTextField.text == "" {
            errorText = "One of the required fields is incomplete."
            logInButton.shake()
            logoImage.loopAnimation = false
            return false
        }
        if passwordTextField.text != confirmPasswordTextField.text {
            errorText = "The passwords don't match."
            logInButton.shake()
            logoImage.loopAnimation = false
            return false
        }
        return true
    }
    
    func firebaseSignUp() {
        // Firebase sign in with email and password
        if arePasswordsMatching() == true {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                if let error = error {
                    print("Error: ", error.localizedDescription)
                    if error.localizedDescription == "The email address is already in use by another account." {
                        // Log in with the data.
                        self.firebaseLogIn(userEmail: self.emailTextField.text!, userPassword: self.passwordTextField.text!)
                    } else {
                        self.errorText = error.localizedDescription
                        self.logInButton.shake()
                    }
                } else {
                    
                    // User is signed in
                    self.isSignedIn = true
                    
                    print("New account made!")
                    self.username = Auth.auth().currentUser?.displayName
                    self.email = Auth.auth().currentUser?.email
                    self.uid = Auth.auth().currentUser?.uid
                    
                    self.safeUserInfoForNextLogIn(userEmail:  self.emailTextField.text!, userPassword: self.passwordTextField.text!)
                    
                    self.loadNextView()
                }
            }
        }
    }
    func safeUserInfoForNextLogIn(userEmail:String, userPassword:String) {
//        print("SAving user data!")
        // Safe user info for next log in
//        UserDefaults.standard.set(["email": userEmail, "password": userPassword], forKey: "userData")
//        UserDefaults.standard.synchronize()
        keychain.set(userEmail, forKey: "email")
        keychain.set(userPassword, forKey: "password")
        
    }
    func firebaseLogIn(userEmail:String, userPassword:String) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] user, error in
            guard let strongSelf = self else {
                self?.errorText = "Some Error Occurred."
                self?.logInButton.shake()
                return
            }
            if let error = error {
                print("Error: ", error.localizedDescription)
                
                strongSelf.errorText = error.localizedDescription
                strongSelf.logInButton.shake()
            } else {
                // User is signed in
                strongSelf.isSignedIn = true
                
                print("User Logged in.")
                strongSelf.username = Auth.auth().currentUser?.displayName
                strongSelf.email = Auth.auth().currentUser?.email
                strongSelf.uid = Auth.auth().currentUser?.uid
                
                strongSelf.safeUserInfoForNextLogIn(userEmail: userEmail, userPassword: userPassword)
                
                strongSelf.loadNextView()
            }
        }
    }
    
    func loadNextView() {
        logoImage.loopAnimation = false
        canLoadNextView = true
    }
    
    @objc func loginButtonEnded() {
        logInButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        logoImage.loopAnimation = true
        
        // After the animation finshed last loop.
        logoImage.play { (finished) in
            if self.canLoadNextView == true {
                self.moveToNextView()
            }
        }
        
        firebaseSignUp()
    }
    
    func moveToNextView() {
        print("Animation Finished")
        // Next view. Choose between onboarding or continue
        
        // TODO: Get data from Firebase for user!
        saveUserID(uid!)
        if self.isSignedIn == true {
            if UserDefaults.standard.integer(forKey: "numberOfUses") == 1 {
                self.dismiss(animated: true)
                delegate?.openFirstVC()
            }
            else {
                self.dismiss(animated: true)
                delegate?.openFirstVC()
                // Handle First time Sign in.
                // TODO: Add onboarding.
                UserDefaults.standard.set(1, forKey: "numberOfUses")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    @objc func loginButtonBegan() {
        logInButton.backgroundColor = #colorLiteral(red: 0.9433736205, green: 0.9435314536, blue: 0.9433527589, alpha: 1)
        
    }
    
    @objc func googleButtonPressedBegan() {
        googleButton.backgroundColor = #colorLiteral(red: 0.9433736205, green: 0.9435314536, blue: 0.9433527589, alpha: 1)
    }
    
    @objc func googleButtonPressed() {
        googleButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        logInButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        logoImage.loopAnimation = true
        
        // After the animation finshed last loop.
        logoImage.play { (finished) in
            if self.canLoadNextView == true {
                self.moveToNextView()
            }
        }
        
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
            self.saveUserID(self.uid!)
            print("user successfully signed in through GOOGLE! uid:\(String(describing: Auth.auth().currentUser!.email))")
            
            self.isSignedIn = true
            
            print("User Logged in.")
            
            self.loadNextView()
        }
    }
    
    func saveUserID(_ userID:String) {
        print("UserID: ", userID)
        UserDefaults.standard.set(["uid":uid], forKey: "uid")
        UserDefaults.standard.synchronize()
    }
    
    // Action when begins to edit any textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
//        textField.font = UIFont(name: "AvenirNext-Bold", size: 25)
        errorLabel.isHidden = true
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

