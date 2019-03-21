//
//  Settings.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/19/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {
    
    var background: UIView = {
        var backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return backgroundView
    }()
    
    // Creating Navbar
    private let navbar: UIView = {
        let navigationBar = UIView()
        navigationBar.alpha = 0
        return navigationBar
    }()
    
    // Addting title to Navbar
    let viewNavbarTitle: UITextView = {
        var title = UITextView()
        title.text = "Settings"
        title.font = UIFont(name: "AvenirNext-Medium", size: 40)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Adding Button To Navbar
    private let signOut: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        //        button.addTarget(self, action: #selector(newPropertyButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Return button
    private let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 60)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Cell ID
    private let cellId = "SettingCell"
    
    
    // Creating table view
    var tableView = UITableView()
    
    // Delegate
    var delegate: VCHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(background)
        background.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        addCustomNavbar()
        setupTableView()
    }
    
    func addCustomNavbar() {
        // Adding Navbar View
        background.addSubview(navbar)
        
        // Navbar Size
        navbar.anchor(top: background.topAnchor, leading: background.leadingAnchor, bottom: nil, trailing: background.trailingAnchor, size: .init(width: background.bounds.width, height: 100))
        
        // Return button
        background.addSubview(returnButton)
        
        returnButton.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: navbar.bottomAnchor, trailing: nil, padding: .init(top: 45, left: 20, bottom: 5, right: 0))
        
        // Adding Title to Navbar
        background.addSubview(viewNavbarTitle)
        
        // Title Size
        viewNavbarTitle.anchor(top: returnButton.bottomAnchor, leading: navbar.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 5, right: 0))
        
        background.addSubview(signOut)
        
//        // Button Size
//        signOut.anchor(top: nil, leading: nil, bottom: nil, trailing: navbar.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 0, height: 48))
//        signOut.centerVerticalOfView(to: returnButton)
    }
    
    func setupTableView() {
        // Add to Table View to View
        view.addSubview(tableView)
        
        // Table View Size
        tableView.anchor(top: viewNavbarTitle.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        // Register Table View Cells
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Table View
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @objc func returnButtonPressed() {
        // Dismiss self
        self.dismiss(animated: true)
    }
}

extension SettingsView: UITableViewDataSource {
    // Table View Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Table View Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Cells one by one using this as a blueprint.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        
        // Set the cell label text
        cell.name.text = "Sign Out"
        cell.amount.isHidden = true
        
        //        cell.amount.text = "$" + allSpending[indexPath.row].amount.formattedWithSeparator
        cell.selectionStyle = .none
//        cell.backgroundColor = tableView.backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Handle Sign out
            // 1. Delete email and password data
//            UserDefaults.standard.set("", forKey: "userData")
//            UserDefaults.standard.synchronize()
//
            // 2. Go to Log in page
//            self.dismiss(animated: true)
            delegate?.goBackToLogIn()
        }
    }
}

extension SettingsView: UITableViewDelegate {
    //     Table View Cell Styling
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselected")
    }
}
