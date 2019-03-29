//
//  FirstViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/21/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn
import Lottie

/*
This controller handles displaying all the categories. And also shows default options such as settings or adding new categories.
*/

class FirstViewController: UIViewController {
    // To present next view with categories
    var delegate: VCHandler?
    
    // For Firebase
    var ref: DatabaseReference!
    var uid: String = ""
    
    // State
    private var isCurrenltyEditing = false {
        didSet {
            // TODO: Add remove label on collection view cell.
            print("Button pressed. Reloading layout.")
            hasDoneEdges = false
            hasDoneMiddle = false
            hasDoneVerical = false
            collectionView.reloadData()
        }
    }
    
    // Collection view list
    var allViews = [Views]() {
        didSet {
            // Sorts all the views in alphabetical order.
            allViews = allViews.sorted { $0.name < $1.name }
            // TODO: This has been giving sometimes errors after having added uid into func.
            hasDoneEdges = false
            hasDoneMiddle = false
            hasDoneVerical = false
            collectionView.reloadData()

        }
    }
    
//    // Creating Navbar
//    private let navbar: UIView = {
//        let navigationBar = UIView()
//        navigationBar.alpha = 0
//        return navigationBar
//    }()
//    
//    // Addting title to Navbar
//    let viewNavbarTitle: UITextView = {
//        var title = UITextView()
//        title.text = "Categories"
//        title.font = UIFont(name: "AvenirNext-Medium", size: 60)
//        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        title.backgroundColor = nil
//        title.textAlignment = .center
//        title.isEditable = false
//        title.isScrollEnabled = false
//        title.isSelectable = false
//        return title
//    }()
    
    // Adding Button To Navbar
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchDragExit)
        button.addTarget(self, action: #selector(settingsButtonPressBegan), for: .touchDown)
        return button
    }()
    
    // Adding Button To Navbar
    private let addNewButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.08)
        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchDragExit)
        button.addTarget(self, action: #selector(newCategoryButtonPressBegan), for: .touchDown)
        return button
    }()
    
    // Edit button
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchDragExit)
        button.addTarget(self, action: #selector(editButtonPressBegan), for: .touchDown)
        return button
    }()
    
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    
    // Needed to set up collecion view flowlayout
    var hasDoneEdges = false
    var hasDoneVerical = false
    var hasDoneMiddle = false
        
    // Constant to set font size relative for device.
    let relativeFontConstant:CGFloat = 0.036

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        
        // Set each label's font size relative to the screen size
        let buttons = [settingsButton, editButton]
                
        for button in buttons {
            button.titleLabel?.font = button.titleLabel?.font.withSize(self.view.frame.height * relativeFontConstant)
        }
        
        
        addCustomNavbar()
        
        // Collection View Setup
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCell")
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentOffset = .zero
        view.insertSubview(collectionView, belowSubview: addNewButton)
        
        addCollectionView()
//        createAllViewsStructs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Check for user data.
        findUserData()
//        createAllViewsStructs()
    }
    
    
//    func createAllViewsStructs() {
//        let thisMonth = Views(name: "This Month", totalAmount: 2578.00, categories: [])
//        allViews.append(thisMonth)
//
//        let borrow = Views(name: "Borrow", totalAmount: -525044.00, categories: [])
//        allViews.append(borrow)
//
//        let bank = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank)
//        let bank1 = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank1)
//        let bank2 = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank2)
//        let bank3 = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank3)
//        let bank4 = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank4)
//        let bank5 = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank5)
//        let bank6 = Views(name: "Banks", totalAmount: 0.00, categories: [])
//        allViews.append(bank6)
//
////        print(allViews)
//    }
    
    func addCustomNavbar() {
//        view.addSubview(navbar)
//        view.addSubview(viewNavbarTitle)
//        view.addSubview(addNewButton)
//        view.addSubview(settingsButton)
//        view.addSubview(editButton)
        
        print("View bounds:",view.bounds)
        let buttonStack = UIStackView(arrangedSubviews: [editButton, addNewButton, settingsButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalCentering
        
        view.insertSubview(buttonStack, at: 0)
        
        buttonStack.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.bounds.height / 14)
        }
        
        let buttonBackground = UIView()
        buttonBackground.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        buttonBackground.alpha = 0.6
//        buttonBackground.layer.borderWidth = 1
//        buttonBackground.layer.borderColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        
        view.insertSubview(buttonBackground, belowSubview: buttonStack)
        buttonBackground.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(buttonStack.snp.top)
        }
        
//        navbar.snp.makeConstraints { (make) in
//            make.left.right.top.equalTo(view)
//            make.height.equalTo(view.bounds.height / 7)
//        }
//        navbar.alpha = 1
//        navbar.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
//
//        viewNavbarTitle.snp.makeConstraints { (make) in
//            make.left.equalTo(view.safeAreaLayoutGuide).offset(15)
//            make.centerY.equalTo(navbar)
//        }
        
        
//        // Navbar Size
//        navbar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.bounds.width, height: 130))
//
//        // Title Size
//        viewNavbarTitle.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: navbar.bottomAnchor, trailing: nil, padding: .init(top: 45, left: 20, bottom: 5, right: 0))
//        viewNavbarTitle.text = (Auth.auth().currentUser?.displayName) ?? "Welcome"
//
//        if viewNavbarTitle.text != "Welcome" {
//            viewNavbarTitle.font = UIFont(name: "AvenirNext-Medium", size: 40)
//        }
//
//        // Button constrains
//        addNewButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
//        addNewButton.centerHorizontalOfView(to: view)
//
//        // Button Size
//        settingsButton.anchor(top: addNewButton.topAnchor, leading: nil, bottom: addNewButton.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
//
//        // Button Size
//        editButton.anchor(top: addNewButton.topAnchor, leading: view.leadingAnchor, bottom: addNewButton.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
    }
    func addCollectionView() {
//        collectionView.anchor(top: navbar.bottomAnchor, leading: view.leadingAnchor, bottom: addNewButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-1 * (view.bounds.height / 20))
            make.left.right.equalToSuperview()
            make.bottom.equalTo(addNewButton.snp.top)
        }
    }
}


extension FirstViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allViews.count + 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
            cell.viewNavbarTitle.text = "Categories"
//            cell.backgroundColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
            return cell
        }
        else if indexPath.row == (allViews.count + 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
            cell.viewNavbarTitle.text = ""
//            cell.backgroundColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MainCollectionViewCell
//            cell.backgroundColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
            cell.label.text =  allViews[indexPath.row - 1].name
            
            // Should hide or show the remove button
            cell.currentlyEditing = isCurrenltyEditing
            
            var amountValue = allViews[indexPath.row - 1].totalAmount
            
            if amountValue > 0 {
                cell.amount.textColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
                cell.amount.text = "$" + amountValue.formattedWithSeparator
            }
            else if amountValue < 0 {
                cell.amount.textColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
                amountValue *= -1
                cell.amount.text = "$" + amountValue.formattedWithSeparator
            }
            else {
                // If there's no spending.
                cell.amount.textColor = #colorLiteral(red: 0.8445890546, green: 0.8395691514, blue: 0.8484483361, alpha: 1)
                cell.amount.font = UIFont(name: "AvenirNext-Medium", size: 22)
                cell.amount.text = "Tap to add +"
            }
            cell.removeButton.tag = indexPath.row - 1
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Pressed")
        if isCurrenltyEditing == false {
             if indexPath.row != 0 && indexPath.row != allViews.count + 1 {
                let viewId = allViews[indexPath.row - 1].id
        //        getCategoriesFromId(id: viewId)
                
                self.dismiss(animated: true)
                // MARK: Delegate transition
                delegate?.openPresentCategoriesVC(id: viewId)
            }
        }
    }
}



extension FirstViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == (allViews.count + 1) {
            return CGSize(width: view.bounds.size.width, height: view.bounds.size.height / 14)
        }
        else if indexPath.row > 0 {
            return CGSize(width: (collectionView.bounds.size.width / 2) - 17, height: view.bounds.height / 6)
        }
        else {
            return CGSize(width: view.bounds.size.width, height: view.bounds.size.height / 14)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 5, left: 7, bottom: 0, right: 7)
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Vertical Spacing
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Middle spacing
        return 0.0
    }
    
}

extension FirstViewController {
    // There are two functions per button because I like to slitghtly animate them while they're selected.
    @objc func settingsButtonPressed() {
        settingsButton.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        let settingsVC = SettingsView()
        settingsVC.mainVC = self
        self.present(settingsVC, animated: true)
    }
    @objc func settingsButtonPressBegan() {
        settingsButton.setTitleColor(#colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1), for: .normal)
    }
    
    @objc func editButtonPressed() {
        //        self.present(SettingsView(), animated: true)
        
        if isCurrenltyEditing == false {
            isCurrenltyEditing = true
//            editButton.setTitle("Done", for: .normal)
            editButton.setTitleColor(#colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1), for: .normal)
        } else {
            isCurrenltyEditing = false
            editButton.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
//            editButton.setTitle("Edit", for: .normal)
        }
        
        //        print("Is editing:",isCurrenltyEditing)
    }
    @objc func editButtonPressBegan() {
        editButton.setTitleColor(#colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1), for: .normal)
    }
    
    @objc func newCategoryButtonPressed() {
        addNewButton.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        self.present(NewCategoryViewController(), animated: true)
    }
    
    @objc func newCategoryButtonPressBegan() {
        addNewButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
    
    func findUserData() {
        //        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        ref = Database.database().reference().child("users/\(uid)/views")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: [String:Any]] else {
                // TODO: Handle error
                print("snapshot: ",snapshot.value)
                
                // Will happen if there's no views on database
                self.noViewsInFirebase()
                
                
                return
            }
            var newViews:[Views] = []
            
            // Will only get the name and total Amount for all the Views on Firebase
            for (key,item) in value {
                print("key: ", key)
                var newView = Views(name: "", totalAmount: 0.0, categories: [], id: key)
                newView.name = item["name"] as! String
                newView.totalAmount = item["totalAmount"] as! Double
                // TODO: viewCategory into category struct
                newViews.append(newView)
            }
            print("new views: ", newViews)
            
            self.allViews = newViews
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func noViewsInFirebase() {
        // Func to handle not having views in the database.
        
        // Check if dummy data is needed
        if UserDefaults.standard.bool(forKey: "NeedsDummyData") != true {
            let randomArray = ["Groceries", "Jobs","Borrow","Investments"]
            let mockView = Views(name: randomArray.randomElement()!, totalAmount: 0, categories: [])
            
            let uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]!
            let ref = Database.database().reference().child("users/\(uid)/views").childByAutoId()
            ref.setValue(mockView.getDictionary())
            findUserData()
        }
        UserDefaults.standard.set(true, forKey: "NeedsDummyData")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func deleteCurrentCell(sender:AnyObject) {
        let id = sender.tag!
        let viewId = allViews[id].id
        // Need to delete from firebase
        // 1. Find View in firebase
        
        ref = Database.database().reference().child("users/\(uid)/views/\(viewId)/categoriesId")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let categoriesId = snapshot.value as? [String] else {
                print("snapshot:",snapshot.value!)
                // Probably empty
                // Need to delete the View here (after having deleted everything inside it.
                Database.database().reference().child("users/\(self.uid)/views/\(viewId)").removeValue()
                return
            }
            for categoryId in categoriesId {
                // Do the same search thing within here for all categories within view
                let ref2 = Database.database().reference().child("users/\(self.uid)/categories/\(categoryId)/subCategoriesId")
                ref2.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let subCategoriesId = snapshot.value as? [String] else {
                        print("snapshot:",snapshot.value!)
                        return
                    }
                    for subCategoryId in subCategoriesId {
                        // Do the same thing with sub categories within categories and delete them one by one.
                        let subCategoryToDelete = Database.database().reference().child("users/\(self.uid)/subCategories/\(subCategoryId)")
                        subCategoryToDelete.removeValue { error, _ in
                            print(error ?? "Error")
                        } // Removing all sub categoires within category
                    }
                    // Need to delete categories here (end of its loop)
                    Database.database().reference().child("users/\(self.uid)/categories/\(categoryId)").removeValue { error, _ in
                        print(error ?? "Error")
                    }
                })
            }
            // Need to delete the View here (after having deleted everything inside it.
            Database.database().reference().child("users/\(self.uid)/views/\(viewId)").removeValue { error, _ in
                print(error ?? "Error")
            }
        })
        
        allViews.remove(at: id)
        hasDoneEdges = false
        hasDoneMiddle = false
        hasDoneVerical = false
        collectionView.reloadData()
    }
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: {
            self.delegate?.goBackToLogIn()
        })
    }
}
