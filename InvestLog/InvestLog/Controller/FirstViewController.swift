//
//  FirstViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/21/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Lottie

/*
This controller handles displaying all the categories. And also shows default options such as settings or adding new categories.
*/

class FirstViewController: UIViewController {
    // To present next view with categories
    var delegate: OpenFirstVC?
    
    // For Firebase
    var ref: DatabaseReference!
    var uid: String = ""
    
    // State
    private var isCurrenltyEditing = false {
        didSet {
                // TODO: Add remove label on collection view cell.
                print("Button pressed. Reloading layout.")
                collectionView.reloadData()
        }
    }
    
    // Collection view list
    var allViews = [Views]() {
        didSet {
            // Sorts all the views in alphabetical order.
            allViews = allViews.sorted { $0.name < $1.name }
            // TODO: This has been giving sometimes errors after having added uid into func.
            collectionView.reloadData()

        }
    }
    
    // Creating Navbar
    private let navbar: UIView = {
        let navigationBar = UIView()
        navigationBar.alpha = 0
        return navigationBar
    }()
    
    // Addting title to Navbar
    let viewNavbarTitle: UITextView = {
        var title = UITextView()
        title.text = "Welcome"
        title.font = UIFont(name: "AvenirNext-Medium", size: 60)
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    // Adding Button To Navbar
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9645629525, green: 0.9588286281, blue: 0.9689704776, alpha: 1), for: .normal)
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
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 60)
        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchDragExit)
        button.addTarget(self, action: #selector(newCategoryButtonPressBegan), for: .touchDown)
        return button
    }()
    
    // Edit button
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9645629525, green: 0.9588286281, blue: 0.9689704776, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 25)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(editButtonPressed), for: .touchDragExit)
        button.addTarget(self, action: #selector(editButtonPressBegan), for: .touchDown)
        return button
    }()
    
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    
    let handle = FirebaseHandle()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        addCustomNavbar()
        
        // Collection View Setup
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(MaiCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentOffset = .zero
        view.addSubview(collectionView)
        
        addCollectionView()
//        createAllViewsStructs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("checking data")
        findUserData()
        print("Views: ", allViews)
        
    }
    
    
//    func createAllViewsStructs() {
//        let thisMonth = Views(name: "This Month", totalAmount: 2578.00, categories: [])
//        allViews.append(thisMonth)
//
//        let borrow = Views(name: "Borrow", totalAmount: -50.00, categories: [])
//        allViews.append(borrow)
//
//        let bank = Views(name: "Banks", totalAmount: 525044.00, categories: [])
//        allViews.append(bank)
//
//        print(allViews)
//    }
    
    func addCustomNavbar() {
        view.addSubview(navbar)
        view.addSubview(viewNavbarTitle)
        view.addSubview(addNewButton)
        view.addSubview(settingsButton)
        view.addSubview(editButton)
        
        
        // Navbar Size
        navbar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.bounds.width, height: 130))
        
        // Title Size
        viewNavbarTitle.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: navbar.bottomAnchor, trailing: nil, padding: .init(top: 45, left: 20, bottom: 5, right: 0))
        viewNavbarTitle.text = (Auth.auth().currentUser?.displayName) ?? "Welcome"
        
        // Button constrains
        addNewButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        addNewButton.centerHorizontalOfView(to: view)
        
        // Button Size
        settingsButton.anchor(top: addNewButton.topAnchor, leading: nil, bottom: addNewButton.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        
        // Button Size
        editButton.anchor(top: addNewButton.topAnchor, leading: view.leadingAnchor, bottom: addNewButton.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
    }
    func addCollectionView() {
        collectionView.anchor(top: navbar.bottomAnchor, leading: view.leadingAnchor, bottom: addNewButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    // There are two functions per button because I like to slitghtly animate them while they're selected.
    
    @objc func settingsButtonPressed() {
        settingsButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.present(SettingsView(), animated: true)
    }
    @objc func settingsButtonPressBegan() {
        settingsButton.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
    }
    
    @objc func editButtonPressed() {
//        self.present(SettingsView(), animated: true)
        editButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        if isCurrenltyEditing == false {
            isCurrenltyEditing = true
        } else {
            isCurrenltyEditing = false
        }
        
        print("Is editing:",isCurrenltyEditing)
    }
    @objc func editButtonPressBegan() {
        editButton.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
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
        // TODO: Func to handle not having views in the database.
//        self.allViews = []
    }
}


extension FirstViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allViews.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MaiCollectionViewCell

        cell.label.text =  allViews[indexPath.row].name
        
        // Should hide or show the remove button
        cell.currentlyEditing = isCurrenltyEditing
        
        var amountValue = allViews[indexPath.row].totalAmount
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
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Pressed")
        
        let viewId = allViews[indexPath.row].id
//        getCategoriesFromId(id: viewId)
        
        self.dismiss(animated: true)
        // MARK: Delegate transition
        delegate?.openPresentCategoriesVC(id: viewId)
    }
}

extension FirstViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        print(CGSize(width: (view.frame.width / 2) - 5, height: (view.frame.height / 5)))
        return CGSize(width: (collectionView.bounds.size.width / 2) - 13, height: 150)
        //        return CGSize(width: 160, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Vertical Spacing
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Middle spacing
        return 3.0
    }
    
    
}
