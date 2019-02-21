//
//  newCategoryViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/26/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    // Creating Navbar
    private let navbar: UIView = {
        let navigationBar = UIView()
        navigationBar.alpha = 0
        return navigationBar
    }()
    
    // Addting title to Navbar
    let viewNavbarTitle: UITextView = {
        var title = UITextView()
        title.text = "New Category"
        title.font = UIFont(name: "AvenirNext-Bold", size: 30)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Adding Button To Navbar
    private let goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(goBackButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Add save Category Button
    private let saveCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(saveCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nameInput: UITextField = {
        var textField = UITextField()
        textField.placeholder = "name"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 25)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        //        textField.delegate = self
        textField.textAlignment = .center
//        textField.addTarget(self, action: #selector(NewProperty.moveBackground), for: .touchDown)
        textField.tag = 0
        return textField
    }()
    let nameInputWrapper: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupInput()
        hideKeyboardWhenTappedAround()
    }
    
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        view.addSubview(navbar)
        // Navbar Size
        navbar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.bounds.width, height: 100))
        view.addSubview(goBackButton)
        goBackButton.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 35, bottom: 0, right: 0))
        view.addSubview(viewNavbarTitle)
        viewNavbarTitle.anchor(top: goBackButton.bottomAnchor, leading: navbar.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: -15, left: 15, bottom: 0, right: 0))
        
        view.addSubview(saveCategoryButton)
        saveCategoryButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 20, right: 15))
    }
    func setupInput() {
        view.addSubview(nameInputWrapper)
        nameInputWrapper.anchor(top: navbar.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 60, left: 25, bottom: 0, right: 25), size: .init(width: (view.bounds.width - 50), height: 60))
        nameInputWrapper.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(nameInput)
        nameInput.centerOfView(to: nameInputWrapper)
        nameInput.viewWidth(width: .init(width: view.bounds.width - 60, height: 0))
        nameInput.delegate = self
    }
    
    @objc func goBackButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func saveCategoryButtonPressed() {
        guard let text = nameInput.text else {
            self.dismiss(animated: true)
            return
        }
        if text == "" {
            self.dismiss(animated: true)
        } else {
//            if UserDefaults.standard.bool(forKey: "hasCategorySpending") == true {
//                print("hasCategorySpending == ", UserDefaults.standard.bool(forKey: "hasCategorySpending"))
//                let newCategory = Category(name: text, creationDate: Date(), modificationDate: Date())
//                var categories = UserDefaults.standard.array(forKey: "CategorySpendingArray") as! [[String: [String: Any]]]
//                categories.append(newCategory.getDictionary())
//                UserDefaults.standard.set(categories, forKey: "CategorySpendingArray")
//                UserDefaults.standard.synchronize()
//            } else {
//                print("hasCategorySpending == ", UserDefaults.standard.bool(forKey: "hasCategorySpending"))
//                UserDefaults.standard.set(true, forKey: "hasCategorySpending")
//                let newCategory = Category(name: text, creationDate: Date(), modificationDate: Date())
//                let categories = [newCategory.getDictionary()]
//                UserDefaults.standard.set(categories, forKey: "CategorySpendingArray")
//                UserDefaults.standard.synchronize()
//            }
            let newCategory = Category(name: text, creationDate: Date(), modificationDate: Date())
            HandleData().saveDataCategoryToUserDefaults(newCategory)
            self.dismiss(animated: true)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("Return pressed")
        textField.resignFirstResponder()
        return false
    }
}
