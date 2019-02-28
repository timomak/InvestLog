//
//  CategorySpending.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/27/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class CategorySpendingController: UIViewController {
    var currentCategory: Category = Category(name: "Error", creationDate: Date(), modificationDate: Date(), allSpending: [])
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
        title.font = UIFont(name: "AvenirNext-Bold", size: 35)
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
    
    // Adding Button To Navbar
    private let newCategorySpendingButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 40)
//        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(addNewCategorySpending), for: .touchUpInside)
        return button
    }()
    
    // Cell ID
    private let cellId = "CategoryCell"
    
    
    // Creating table view
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        viewNavbarTitle.text = currentCategory.name
        view.addSubview(newCategorySpendingButton)
        newCategorySpendingButton.anchor(top: navbar.topAnchor, leading: nil, bottom: nil, trailing: navbar.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 35))
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
    
    @objc func goBackButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func addNewCategorySpending() {
        print("Creating new category")
//        currentCategory.allSpending.append(CategorySpending(amount: 4000, creationDate: Date()))
//        tableView.reloadData()
//        print(currentCategory.allSpending)
        let inputSpendingController = InputSpendingController()
        inputSpendingController.currentCategory = currentCategory
        self.present(inputSpendingController, animated: true)
    }
}

extension CategorySpendingController: UITableViewDataSource {
    // Table View Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCategory.allSpending.count
    }
    
    // Table View Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Cells one by one using this as a blueprint.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        
        // Format Date to String
        let df = DateFormatter()
        df.dateFormat = "MMM dd yyyy"
        
        // Set the cell label text
        cell.name.text = df.string(from: currentCategory.allSpending[indexPath.row].creationDate)
//        cell.colorIndicator.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        cell.amount.text = "$" + currentCategory.allSpending[indexPath.row].amount.formattedWithSeparator
        cell.selectionStyle = .none
        cell.backgroundColor = tableView.backgroundColor
        
        // Push your cell to the table view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let categorySpendingController = CategorySpendingController()
//        categorySpendingController.currentCategory = categories[indexPath.row]
//        self.present(categorySpendingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Handle Deletion of UserDefaults array.
            print("Deleted")
        }
    }
}

extension CategorySpendingController: UITableViewDelegate {
    //     Table View Cell Styling
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselected")
    }
}
