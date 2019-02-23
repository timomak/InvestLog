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
    let backgroundAnimation = LOTAnimationView(name: "background")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        view.addSubview(backgroundAnimation)
        backgroundAnimation.fillSuperview()
        backgroundAnimation.contentMode = .scaleAspectFit
        
        backgroundAnimation.loopAnimation = true
        backgroundAnimation.play()
        
        
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
        createAllViewsStructs()
    }
    
    
    func createAllViewsStructs() {
        let thisMonth = Views(name: "This Month", totalAmount: 2578.00, categories: [])
        allViews.append(thisMonth)
        
        let borrow = Views(name: "Borrow", totalAmount: -50.00, categories: [])
        allViews.append(borrow)
        
        let bank = Views(name: "Banks", totalAmount: 525044.00, categories: [])
        allViews.append(bank)

        print(allViews)
    }
    
    func addCustomNavbar() {
        view.addSubview(navbar)
        view.addSubview(viewNavbarTitle)
        view.addSubview(addNewButton)
        view.addSubview(settingsButton)
        
        
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
    }
    func addCollectionView() {
        collectionView.anchor(top: navbar.bottomAnchor, leading: view.leadingAnchor, bottom: addNewButton.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    @objc func settingsButtonPressed() {
        self.present(SettingsView(), animated: true)
    }
    
}


extension FirstViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allViews.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MaiCollectionViewCell
//        if allViews[indexPath.row].name == "Settings" {
//            cell.colorIndicator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
        cell.label.text =  allViews[indexPath.row].name
        var amountValue = allViews[indexPath.row].totalAmount
        if amountValue > 0 {
            cell.amount.textColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        }
        else if amountValue < 0 {
            cell.amount.textColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
            amountValue *= -1
        }
        else {
            cell.amount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        cell.amount.text = "$" + amountValue.formattedWithSeparator
        //        cell.backgroundColor =  #colorLiteral(red: 1, green: 0.3644781709, blue: 1, alpha: 1)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Pressed")
//        if allViews[indexPath.row].controller == ThisMonthView() {
//            let thisMonth = ThisMonthView()
//            thisMonth.tableView.reloadData()
//            self.present(thisMonth, animated: true)
//        } else {
//            self.present(allViews[indexPath.row].controller, animated: true)
//        }
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
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Vertical Spacing
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Middle spacing
        return 3.0
    }
    
    
}
