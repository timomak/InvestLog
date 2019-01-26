//
//  newCategoryViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/26/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {
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
//        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
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
//        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupInput()
    }
    
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        
    }
}
