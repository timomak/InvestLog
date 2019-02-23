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

class FirstViewController: UIViewController {
    
    // Collection view list
    var allViews = [Views]()
    
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
        title.font = UIFont(name: "AvenirNext-Bold", size: 30)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    // Adding Button To Navbar
    private let signOut: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)
        return button
    }()
    
    // Adding Button To Navbar
    private let addNewButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 60)
        //        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
        //        button.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return button
    }()
    
    var collectionView: UICollectionView!
    var flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomNavbar()
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(MaiCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        collectionView.contentOffset = .zero
        view.addSubview(collectionView)
        
        addCollectionView()
        createAllViewsStructs()
    }
    
    
    func createAllViewsStructs() {
        let thisMonth = Views(name: "This Month", totalAmount: 4500.00, controller: ThisMonthView())
        allViews.append(thisMonth)
        
        let settings = Views(name: "Settings", totalAmount: 0.00, controller: SettingsView())
        allViews.append(settings)
        print(allViews)
    }
    
    func addCustomNavbar() {
        view.addSubview(navbar)
        // Navbar Size
        navbar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.bounds.width, height: 100))
        
        // Adding Title to Navbar
        view.addSubview(viewNavbarTitle)
        
        // Title Size
        viewNavbarTitle.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: navbar.bottomAnchor, trailing: nil, padding: .init(top: 45, left: 20, bottom: 5, right: 0))
        viewNavbarTitle.text = (Auth.auth().currentUser?.displayName) ?? "Categories"
        
        view.addSubview(signOut)
        
        // Button Size
        signOut.anchor(top: navbar.topAnchor, leading: nil, bottom: nil, trailing: navbar.trailingAnchor, padding: .init(top: 45, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 48))
        
        view.addSubview(addNewButton)
        addNewButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        addNewButton.centerHorizontalOfView(to: view)
    }
    func addCollectionView() {
        collectionView.anchor(top: navbar.bottomAnchor, leading: view.leadingAnchor, bottom: addNewButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    @objc func signOutPressed() {
        print("Sign out pressed")
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
        self.dismiss(animated: true)
    }
    
}


extension FirstViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allViews.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MaiCollectionViewCell
        if allViews[indexPath.row].name == "Settings" {
            cell.colorIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        cell.label.text =  allViews[indexPath.row].name
        cell.amount.text = "$" + allViews[indexPath.row].totalAmount.formattedWithSeparator
        //        cell.backgroundColor =  #colorLiteral(red: 1, green: 0.3644781709, blue: 1, alpha: 1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Pressed")
        if allViews[indexPath.row].controller == ThisMonthView() {
            let thisMonth = ThisMonthView()
            thisMonth.tableView.reloadData()
            self.present(thisMonth, animated: true)
        } else {
            self.present(allViews[indexPath.row].controller, animated: true)
        }
    }
}

extension FirstViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        print(CGSize(width: (view.frame.width / 2) - 5, height: (view.frame.height / 5)))
        return CGSize(width: (UIScreen.main.bounds.width / 2), height: (view.frame.height / 4.6))
        //        return CGSize(width: 160, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
