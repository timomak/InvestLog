//
//  ThisMonthView.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/19/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class ThisMonthView: UIView {
    // Array to supply table view
    var categories: [Category] = [Category]()
    
    // Backgrvard for everything
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
        title.text = "This month"
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
    private let addNewCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return button
    }()
    
    // Addting label to show a dollar
    let dollarSignLabel: UITextView = {
        var title = UITextView()
        title.text = "$"
        title.font = UIFont(name: "AvenirNext-Bold", size: 40)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Addting label to show a accumulated spending
    let accumulatedAmountLabel: UITextView = {
        var title = UITextView()
        title.text = "2,527"
        title.font = UIFont(name: "AvenirNext-Bold", size: 40)
        title.textColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Add new spedning button
    private let newExpenseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(newCategoryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Cell ID
    private let cellId = "cellId"
    

    // Creating table view
    var tableView = UITableView()
    
    func loadSelf(superView: UIView, pc: UIPageControl) {
        superView.addSubview(background)
        background.anchor(top: superView.topAnchor, leading: superView.leadingAnchor, bottom: pc.topAnchor, trailing: superView.trailingAnchor)
        
        superView.addSubview(self)
        
        addCustomNavbar()
        addLabelAboveTableView()
        addExpencesButton()
        addTableView()
        
        newCategoryButtonPressed()
    }
    
    func addCustomNavbar() {
        // Adding Navbar View
        addSubview(navbar)
        
        // Navbar Size
        navbar.anchor(top: background.topAnchor, leading: background.leadingAnchor, bottom: nil, trailing: background.trailingAnchor, size: .init(width: background.bounds.width, height: 100))
        
        // Adding Title to Navbar
        addSubview(viewNavbarTitle)
        
        // Title Size
        viewNavbarTitle.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: navbar.bottomAnchor, trailing: nil, padding: .init(top: 45, left: 20, bottom: 5, right: 0))
        
        addSubview(addNewCategoryButton)
        
        // Button Size
        addNewCategoryButton.anchor(top: navbar.topAnchor, leading: nil, bottom: nil, trailing: navbar.trailingAnchor, padding: .init(top: 45, left: 0, bottom: 0, right: 20), size: .init(width: 48, height: 48))
    }
    
    func addLabelAboveTableView() {
        background.addSubview(dollarSignLabel)
        
        dollarSignLabel.anchor(top: viewNavbarTitle.topAnchor, leading: background.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 40, left: 20, bottom: 0, right: 0))
        
        background.addSubview(accumulatedAmountLabel)
        
        accumulatedAmountLabel.anchor(top: viewNavbarTitle.topAnchor, leading: dollarSignLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 40, left: -5, bottom: 0, right: 0))
    }
    
    
    func addExpencesButton() {
        addSubview(newExpenseButton)
        newExpenseButton.anchor(top: nil, leading: background.leadingAnchor, bottom: background.bottomAnchor, trailing: background.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 20, right: 15))
        
    }
    
    func addTableView() {
        // Add to Table View to View
        background.addSubview(tableView)
        
        // Table View Size
        tableView.anchor(top: dollarSignLabel.bottomAnchor, leading: background.leadingAnchor, bottom: newExpenseButton.topAnchor, trailing: background.trailingAnchor)
        
        // Register Table View Cells
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Table View
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.allowsSelection = false
//        var refreshControl = UIRefreshControl()
//        tableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    
    
    @objc func newCategoryButtonPressed() {
        print("Button Pressed")
        var newCategorySpending = CategorySpending(amount: 2000, creationDate: Date())
        var newCategory = Category(name: "Job", creationDate: Date(), modificationDate: Date(), spendingArray: [newCategorySpending])
        categories.append(newCategory)
    }
}



extension ThisMonthView: UITableViewDataSource {
    // Table View Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // Table View Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Cells one by one using this as a blueprint.
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell

        // Set the cell label text
        cell.name.text = categories[indexPath.row].name
        cell.colorIndicator.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        cell.amount.text = "$" + "4,500"
        
        
        
        // Push your cell to the table view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
//        let newViewController = EditProperty()
//        newViewController.property = properties[indexPath.row]
//        self.present(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
        }
    }
}

extension ThisMonthView: UITableViewDelegate {
//     Table View Cell Styling
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
