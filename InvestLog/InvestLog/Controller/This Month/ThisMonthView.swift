//
//  ThisMonthView.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/19/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class ThisMonthView: UIViewController {
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
//        button.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(background)
        background.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        addCustomNavbar()
        addLabelAboveTableView()
        addExpencesButton()
        addTableView()
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "hasCategorySpending") == true {
//            print("hasCategorySpending == ", UserDefaults.standard.bool(forKey: "hasCategorySpending"))
////            categories = UserDefaults.standard.array(forKey: "CategorySpendingArray") as! [Category]
//            let newCategories = UserDefaults.standard.array(forKey: "CategorySpendingArray") as! [[String: [String: Any]]]
//            // TODO: Unwrap dictionary
//            categories = HandleData().UnwrapCategoryDictionary(newCategories)
//            print("New categories: ", categories)
//        } else {
//            print("User has no categories yet.")
//        }
        categories = HandleData().pullCategoriesFromUserDefaults() ?? []
        tableView.reloadData()
//        print(categories)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        // Swipe gesture recognizer action
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                print("Going back")
                // Update page control
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }

    func addCustomNavbar() {
        // Adding Navbar View
        view.addSubview(navbar)
        
        // Navbar Size
        navbar.anchor(top: background.topAnchor, leading: background.leadingAnchor, bottom: nil, trailing: background.trailingAnchor, size: .init(width: background.bounds.width, height: 100))
        
        // Adding Title to Navbar
        view.addSubview(viewNavbarTitle)
        
        // Title Size
        viewNavbarTitle.anchor(top: navbar.topAnchor, leading: navbar.leadingAnchor, bottom: navbar.bottomAnchor, trailing: nil, padding: .init(top: 45, left: 20, bottom: 5, right: 0))
        
        view.addSubview(addNewCategoryButton)
        
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
        view.addSubview(newExpenseButton)
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
//        tableView.allowsSelection = false
//        var refreshControl = UIRefreshControl()
//        tableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    
    
    @objc func newCategoryButtonPressed() {
        print("Button Pressed")
//        var newCategorySpending = CategorySpending(amount: 2000, creationDate: Date())
//        var newCategory = Category(name: "Job", creationDate: Date(), modificationDate: Date(), spendingArray: [newCategorySpending])
//        categories.append(newCategory)
//        tableView.reloadData()
        self.present(NewCategoryViewController(), animated: true)
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
        cell.selectionStyle = .none
        // Push your cell to the table view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySpendingController = CategorySpendingController()
        categorySpendingController.currentCategory = categories[indexPath.row]
        self.present(categorySpendingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Handle Deletion of UserDefaults array.
            categories.remove(at: indexPath.row)
            HandleData().saveTheEntireCategoryArrayToUserDefaults(categories)
            tableView.reloadData()
        }
    }
}

extension ThisMonthView: UITableViewDelegate {
//     Table View Cell Styling
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselected")
    }
}
