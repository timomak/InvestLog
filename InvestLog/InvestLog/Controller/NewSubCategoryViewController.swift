//
//  NewSubCategoryViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/28/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//


import UIKit
import FirebaseDatabase

/*
 This view controller handles the createtion of new Categoties. Eventually also the addtion of new sub categories.
 */
class NewSubCategoryViewController: UIViewController {
    
    // Reference to viewID
    var viewId: String = ""
    
    var ref: DatabaseReference!
    
    // Title
    let topTitle: UITextView = {
        var title = UITextView()
        title.text = "New Sub-Category"
        title.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.036)
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
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.07)
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
        textField.font = UIFont(name: "AvenirNext-Bold", size: UIScreen.main.bounds.height * 0.032)
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
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.032)
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
        
        
        returnButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.left.equalTo(view.safeAreaLayoutGuide).offset((view.bounds.width / 18))
        }
        
        topTitle.snp.makeConstraints { (make) in
            make.top.equalTo(returnButton.snp.bottom).offset((view.bounds.width / 21) * -1)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        
        inputContainer.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(topTitle.snp.bottom).offset(view.bounds.width / 21)
            make.height.equalTo(view.bounds.height / 14)
        }
        inputContainer.layer.cornerRadius = view.bounds.height / 28
        
        nameInput.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(inputContainer)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(inputContainer.snp.left).offset((view.bounds.width / 20))
            make.right.equalTo(inputContainer.snp.right).offset((view.bounds.width / 20) * -1)
            make.top.equalTo(inputContainer.snp.bottom).offset(view.bounds.width / 21)
            make.height.equalTo(view.bounds.height / 16)
        }
        saveButton.layer.cornerRadius = view.bounds.height / 32
        
//        returnButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 30, bottom: 0, right: 0), size: .init(width: view.bounds.size.width / 8, height: view.bounds.size.width / 8))
//
//        topTitle.anchor(top: returnButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 30, bottom: 0, right: 0))
//
//        inputContainer.centerHorizontalOfView(to: view)
//        inputContainer.anchor(top: topTitle.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width - 40, height: 60))
//
//        nameInput.anchor(top: inputContainer.topAnchor, leading: inputContainer.leadingAnchor, bottom: inputContainer.bottomAnchor, trailing: inputContainer.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))
//
//        saveButton.centerHorizontalOfView(to: view)
//        saveButton.anchor(top: inputContainer.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width - 100, height: 55))
    }
}

extension NewSubCategoryViewController {
    @objc func saveCategoryButtonPressed() {
        if nameInput.text == "" {
            saveButton.shake()
            return
        }
        else {
            // TODO: Set Value when you get here.
            print("Setting new name to be: ", nameInput.text!)
            //            self.ref.setValue(newView.getDictionary())
            let uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]!
            ref = Database.database().reference().child("users/\(uid)/categories").childByAutoId()
            let newCategoryId = ref.key!
            let newCategory = Category(name: nameInput.text!, creationDate: Date(), modificationDate: Date(), viewId: viewId)
            ref.setValue(newCategory.getDictionary())
            
            let ref2 = Database.database().reference().child("users/\(uid)/views/\(viewId)")
            ref2.observeSingleEvent(of: .value, with: { (snapshot) in
                guard var view = snapshot.value as? [String:Any] else {
                    print("snapshot:",snapshot.value)
                    return
                }
                guard var categoriesIdArray = view["categoriesId"] as? [String] else {
                    // No categories
                    print("View has no categories Id")
                    ref2.updateChildValues(["categoriesId":[newCategoryId]])
                    return
                }
                // already has categories
                categoriesIdArray.append(newCategoryId)
                ref2.updateChildValues(["categoriesId":categoriesIdArray])
            })
            
            
            
            // Just dimiss for now. Gonna save it to the database next change.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func returnButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
