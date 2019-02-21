
//
//  InputSpending.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/27/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class InputSpendingController: UIViewController, UITextFieldDelegate {
    var currentCategory: Category = Category(name: "Error", creationDate: Date(), modificationDate: Date())
    // Creating Navbar
    private let navbar: UIView = {
        let navigationBar = UIView()
        navigationBar.alpha = 0
        return navigationBar
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
        button.addTarget(self, action: #selector(saveSpendingButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let nameInput: UITextField = {
        var textField = UITextField()
        textField.placeholder = "amount"
        textField.font = UIFont(name: "AvenirNext-Bold", size: 30)
        textField.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.decimalPad
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
    
    // Addting title to Navbar
    let dollarSign: UITextView = {
        var title = UITextView()
        title.text = "$"
        title.font = UIFont(name: "AvenirNext-Bold", size: 35)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Add save input
    private let inButton: UIButton = {
        let button = UIButton()
        button.setTitle("In", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
//        button.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
//        button.layer.cornerRadius = 15
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.addTarget(self, action: #selector(inButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Add save output
    private let outButton: UIButton = {
        let button = UIButton()
        button.setTitle("Out", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
//        button.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
//        button.layer.cornerRadius = 15
        button.layer.cornerRadius = 15
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.addTarget(self, action: #selector(outButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Important to track where the money goes
    var moneyFlow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
        setupView()
        setupInput()
        setUpButtons()
        hideKeyboardWhenTappedAround()
    }
    
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        
        view.addSubview(navbar)
        // Navbar Size
        navbar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.bounds.width, height: 100))
        
        view.addSubview(goBackButton)
        goBackButton.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 25, left: 35, bottom: 0, right: 0))
        
        view.addSubview(saveCategoryButton)
        saveCategoryButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 20, right: 15))
    }
    
    func setupInput() {
        view.addSubview(nameInputWrapper)
        nameInputWrapper.anchor(top: navbar.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 25, bottom: 0, right: 25), size: .init(width: (view.bounds.width - 50), height: 60))
        nameInputWrapper.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(dollarSign)
        dollarSign.anchor(top: nameInputWrapper.topAnchor, leading: nameInputWrapper.leadingAnchor, bottom: nameInputWrapper.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        view.addSubview(nameInput)
        nameInput.centerOfView(to: nameInputWrapper)
        nameInput.viewWidth(width: .init(width: view.bounds.width - 60, height: 0))
        nameInput.delegate = self
    }
    
    func setUpButtons() {
        let buttonStack = UIStackView(arrangedSubviews: [inButton,outButton])
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        view.addSubview(buttonStack)
        buttonStack.anchor(top: nameInputWrapper.bottomAnchor, leading: nameInputWrapper.leadingAnchor, bottom: nil, trailing: nameInputWrapper.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
        buttonStack.viewHeight(height: .init(width: 0, height: saveCategoryButton.bounds.height))
    }
    
    @objc func goBackButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func saveSpendingButtonPressed() {
        // TODO: Handle Saving of spending
        var amount = Double(nameInput.text!) ?? 0.00
        if moneyFlow == "out" {
            amount *= -1
        }
        let spending = CategorySpending(amount: amount, creationDate: Date())
        currentCategory.allSpending.append(spending)
        
        var allCategories = HandleData().pullCategoriesFromUserDefaults()
        var counter = 0
        for category in allCategories {
            if category.creationDate == currentCategory.creationDate {
                allCategories.remove(at: counter)
                allCategories.insert(currentCategory, at: counter)
            }
            counter += 1
        }
        var tempArray: [[String:[String:Any]]] = []
        for i in allCategories {
            tempArray.append(i.getDictionary())
        }
        UserDefaults.standard.set(tempArray, forKey: "CategorySpendingArray")
        UserDefaults.standard.synchronize()
//        HandleData().saveTheEntireCategoryArrayToUserDefaults(allCategories)
        self.dismiss(animated: true)
    }
    
    @objc func inButtonPressed() {
        inButton.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        outButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        moneyFlow = "in"
    }
    
    @objc func outButtonPressed() {
        outButton.backgroundColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
        inButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        moneyFlow = "out"
    }
    
//    @objc func keyboardWillShow() {
//        saveCategoryButton.removeFromSuperview()
//        view.addSubview(saveCategoryButton)
//        saveCategoryButton.anchor(top: inButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 15, bottom: 0, right: 15))
//    }
//
//    @objc func keyboardWillHide() {
//        saveCategoryButton.removeFromSuperview()
//        view.addSubview(saveCategoryButton)
//        saveCategoryButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 20, right: 15))
//    }
//
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameInput.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
    }
    // Hide keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("Return pressed")
        textField.resignFirstResponder()
        return false
    }
}
