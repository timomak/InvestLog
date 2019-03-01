//
//  PresentCategoryViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/19/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Firebase

class PresentCategoryViewController: UIViewController {
    // For Firebase
    var ref: DatabaseReference!
    var uid: String = ""
    
    // Array to supply table view
    var categories: [Category] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Cell ID
    private let cellId = "cellId"
    
    // Delegate to switch views
    var delegate: OpenFirstVC?
    
    
    // Creating table view
    var tableView = UITableView()
    
    var tableViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
    // Return button
    private let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 60)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Add button
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 60)
//        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Labels background
    var labelsBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
    // Title
    let viewNameLabel: UITextView = {
        var title = UITextView()
        title.text = "Name"
        title.font = UIFont(name: "AvenirNext-Medium", size: 25)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    // Amount
    let totalAmountLabel: UITextView = {
        var title = UITextView()
        title.text = "Tap \"+\" to add"
        title.font = UIFont(name: "AvenirNext-Medium", size: 25)
        title.textColor = #colorLiteral(red: 0.8514072299, green: 0.8501688242, blue: 0.870927155, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
//        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        setTop()
        createTempData()
        view.addSubview(tableViewBackground)
        addTableView()
    }
    
    func createTempData() {
        for _ in 0...3 {
            var newCategory = Category(name: "Groceries", creationDate: Date(), modificationDate: Date(), allSpending: [], totalAmount: 3000)
            
            categories.append(newCategory)
        }
    }
    
    func setTop() {
        view.addSubview(returnButton)
        view.addSubview(addButton)
        view.addSubview(labelsBackground)
        view.addSubview(viewNameLabel)
        view.addSubview(totalAmountLabel)
        
        returnButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 30, bottom: 0, right: 0), size: .init(width: view.bounds.size.width / 8, height: view.bounds.size.width / 8))
        
        addButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 30), size: .init(width: view.bounds.size.width / 8, height: view.bounds.size.width / 8))
        
        labelsBackground.anchor(top: returnButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width - 40, height: 100))
        labelsBackground.centerHorizontalOfView(to: view)
        
        let labelStack = UIStackView(arrangedSubviews: [viewNameLabel, totalAmountLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -5
        view.addSubview(labelStack)
        labelStack.centerOfView(to: labelsBackground)
    }
    
    func updateTableViewBackgroundConstrainsts() {
        // Set the background of the table view
        tableViewBackground.anchor(top: tableView.topAnchor, leading: tableView.leadingAnchor, bottom: tableView.bottomAnchor, trailing: tableView.trailingAnchor, padding: .init(top: -10, left: -5, bottom: -30, right: -5))
        tableViewBackground.layer.cornerRadius = 30
    }
    
    
    func addTableView() {
        // Add to Table View to View
        view.addSubview(tableView)
        
        let cellXCount = CGFloat(70 * categories.count)
        if cellXCount >= 70 {
            // Table View Size
            tableView.anchor(top: labelsBackground.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: view.bounds.width - 30, height: cellXCount))
            tableView.centerHorizontalOfView(to: view)

            
            // Register Table View Cells
            tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
            tableView.delegate = self
            tableView.dataSource = self
            
            // Table View
            tableView.backgroundColor = .clear
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            //        tableView.allowsSelection = false
            //        var refreshControl = UIRefreshControl()
            //        tableView.refreshControl = refreshControl
            //        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
            
            
            updateTableViewBackgroundConstrainsts()
        }
        else {
            tableViewBackground.backgroundColor = .clear
        }
    }
    
//    func getCategoriesFromId(id: String) {
//        // Using the view id, get all the categories under that Id and load those categories.
//        let presentVC = PresentCategoryViewController()
//        ref = Database.database().reference().child("users/\(uid)/views/\(id)/categories")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let value = snapshot.value as? [String: [String:Any]] else {
//                // TODO: Handle error
//                print("snapshot: ",snapshot.value)
//
//                // Will happen if there's no categories in the view but there is a path
//                self.categories = []
//
//                return
//            }
//
//            // TODO: Present the view with categories
//            self.categories = []
//
//
//        }) { (error) in
//            print("Error: ", error.localizedDescription)
//            // Will happen if there's no categories in the view because the path doesn't exist
//            // Will almost never happen.
//            self.categories = []
//        }
//    }
    
    @objc func addButtonPressed() {
        self.present(NewSubCategoryViewController(),animated: true)
    }
    @objc func returnButtonPressed() {
        self.dismiss(animated: true)
        
        // TODO: Add delegate to present FirstVC
        delegate?.openFirstVC()
    }
}



extension PresentCategoryViewController: UITableViewDataSource {
    // Table View Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // Table View Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Cells one by one using this as a blueprint.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell

        // Set the cell label text
        cell.name.text = categories[indexPath.row].name
//        cell.colorIndicator.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        cell.amount.text = "$" + categories[indexPath.row].totalAmount.formattedWithSeparator
        cell.selectionStyle = .none
        // Push your cell to the table view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySpendingController = CategorySpendingViewController()
        categorySpendingController.currentCategory = categories[indexPath.row]
        self.present(categorySpendingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Handle Deletion of UserDefaults array.
            categories.remove(at: indexPath.row)
//            HandleData().saveTheEntireCategoryArrayToUserDefaults(categories)
            tableView.reloadData()
        }
    }
}

extension PresentCategoryViewController: UITableViewDelegate {
//     Table View Cell Styling
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselected")
    }
}
