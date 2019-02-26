//
//  NewCategoryViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/23/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import FirebaseDatabase

/*
This view controller handles the createtion of new Categoties. Eventually also the addtion of new sub categories.
*/
class NewCategoryViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    // Title
    let topTitle: UITextView = {
        var title = UITextView()
        title.text = "New Category"
        title.font = UIFont(name: "AvenirNext-Medium", size: 30)
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Return button
    private let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 60)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Text container view
    let inputContainer: UIView = {
        let container = UIView()
        container.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        container.layer.cornerRadius = 30
        container.layer.shadowOpacity = 0.7
        container.layer.shadowRadius = 5
        container.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return container
    }()
    
    // Input label
    let nameInput: UITextField = {
        var textField = UITextField()
        textField.placeholder = "name"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 25)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.textAlignment = .center
        textField.tag = 0
        return textField
    }()
    
    // Save button
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
        button.backgroundColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        button.layer.cornerRadius = 28
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        button.addTarget(self, action: #selector(saveCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        hideKeyboardWhenTappedAround()
        
        let uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]!
        ref = Database.database().reference().child("users/\(uid)/views").childByAutoId()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(returnButton)
        view.addSubview(topTitle)
        view.addSubview(inputContainer)
        view.addSubview(nameInput)
        view.addSubview(saveButton)
        
        returnButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 30, bottom: 0, right: 0), size: .init(width: view.bounds.size.width / 8, height: view.bounds.size.width / 8))
        
        topTitle.anchor(top: returnButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 30, bottom: 0, right: 0))
        
        inputContainer.centerHorizontalOfView(to: view)
        inputContainer.anchor(top: topTitle.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width - 40, height: 60))
        
        nameInput.anchor(top: inputContainer.topAnchor, leading: inputContainer.leadingAnchor, bottom: inputContainer.bottomAnchor, trailing: inputContainer.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))

        saveButton.centerHorizontalOfView(to: view)
        saveButton.anchor(top: inputContainer.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width - 100, height: 55))
    }
    
    @objc func saveCategoryButtonPressed() {
        if nameInput.text == "" {
            saveButton.shake()
            return
        }
        else {
            // Testing
            let newView = Views(name: nameInput.text!, totalAmount: 0, categories: [])
            print(newView.getDictionary())
            self.ref.setValue(newView.getDictionary())
            
            // Just dimiss for now. Gonna save it to the database next change.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func returnButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
