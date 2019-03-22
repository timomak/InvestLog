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
    
    // View Id
    var viewId: String = ""
    var categoriesId:[String] = []
    
    // Array to supply table view
    var categories: [Category] = [] {
        didSet {
            totalAmount = 0
            for category in categories {
                print("Category total amount", category.totalAmount)
                totalAmount += category.totalAmount
            }
            addAmountToViewTotal(totalAmount, viewId)
            categories = categories.sorted { $0.name < $1.name }
            print("Number of items in categories: ", categories.count)
            updateTableViewConstrains()
            tableView.reloadData()
        }
    }
    
    // Cell ID
    private let cellId = "cellId"
    
    // Delegate to switch views
    var delegate: VCHandler?
    
    
    // Creating table view
    var tableView = UITableView()
    
    var tableViewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
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
    
    // Amount String
    var totalAmount: Double = 0 {
        didSet{
            print("total amount changed by:", totalAmount)
            if totalAmount > 0 {
                totalAmountLabel.textColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
                totalAmountLabel.text = "$" + totalAmount.formattedWithSeparator
            }
            else if totalAmount < 0 {
                totalAmountLabel.textColor = #colorLiteral(red: 1, green: 0.08736196905, blue: 0.08457560092, alpha: 1)
                totalAmountLabel.text = "$" + (totalAmount * -1).formattedWithSeparator
            }
            else if totalAmount == 0 {
                totalAmountLabel.textColor = #colorLiteral(red: 0.8152421713, green: 0.8140566945, blue: 0.8339331746, alpha: 1)
                totalAmountLabel.text = "Tap \"+\" to add"
            }
        }
    }
    
    var heightAnchor:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setTop()
//        createTempData()
        addTableView()
        tableViewBackgroundConstrainsts()
        print("test")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
        print("View ID:", viewId)
        getViewDataFrom(id: viewId)
        tableView.reloadData()
        updateTableViewConstrains()
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
    
    func tableViewBackgroundConstrainsts() {
        print("Should be updating constrainsts. Height: ", CGFloat(70 * categories.count))
        // Set the background of the table view
        tableViewBackground.anchor(top: tableView.topAnchor, leading: tableView.leadingAnchor, bottom: nil, trailing: tableView.trailingAnchor, padding: .init(top: -10, left: -5, bottom: 0, right: -5))
        heightAnchor = tableViewBackground.heightAnchor.constraint(equalToConstant: CGFloat(70 * categories.count) + 30)
        heightAnchor.isActive = true
        tableViewBackground.layer.cornerRadius = 30
        tableViewBackground.layoutIfNeeded()
        if categories.count == 0 {
            tableViewBackground.isHidden = true
        } else {
            tableViewBackground.isHidden = false
        }
    }
    
    
    func addTableView() {
        // Add to Table View to View
        view.addSubview(tableViewBackground)
        view.addSubview(tableView)

        tableView.anchor(top: labelsBackground.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 30, left: 0, bottom: 60, right: 0), size: .init(width: view.bounds.width - 30, height: 0))
            tableView.centerHorizontalOfView(to: view)

            
            // Register Table View Cells
            tableView.register(TableViewCell.self, forCellReuseIdentifier: cellId)
            tableView.delegate = self
            tableView.dataSource = self
            
            // Table View
            tableView.backgroundColor = .clear
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func addAmountToViewTotal(_ amount: Double,_ id: String) {
        print("add ", amount, "to view total amount.")
        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        ref = Database.database().reference().child("users/\(uid)/views/\(id)")
        var oldAmount = 0.0
        // first get the current amount, second add to it.
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let viewData = snapshot.value as? [String:Any] else {
                // TODO: Handle error
                print("snapshot: ",snapshot.value ?? "Null")
                return
            }
            oldAmount = viewData["totalAMount"] as? Double ?? 0
        })
        ref.updateChildValues(["totalAmount":amount + oldAmount])
    }
    
    func getViewDataFrom(id: String) {
        // Using the view id, get all the categories under that Id and load those categories.
        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        ref = Database.database().reference().child("users/\(uid)/views/\(id)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let viewData = snapshot.value as? [String:Any] else {
                // TODO: Handle error
                print("snapshot: ",snapshot.value ?? "Null")

                // Will happen if there's no categories in the view but there is a path
//                self.categories = []

                return
            }
            
            self.viewNameLabel.text = viewData["name"] as? String ?? "Error"
            self.totalAmount = viewData["totalAmount"] as? Double ?? 0
//            self.categoriesId = viewData["categoriesId"] as? [String] ?? []
            
            let categoriesInfo = viewData["categoriesId"] as? [String] ?? []
            if categoriesInfo != [] {
                self.categoriesId = categoriesInfo
                // Call function to fill categories
                self.findCategoriesData()
            }
            else {
                self.categories = []
            }
            

        }) { (error) in
            print("Error: ", error.localizedDescription)
            // Will happen if there's no categories in the view because the path doesn't exist
            // Will almost never happen.
        }
    }
    
    func findCategoriesData() {
        ref = Database.database().reference().child("users/\(uid)/categories")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let categoriesData = snapshot.value as? [String:[String:Any]] else {
                print("snapshot: ",snapshot.value ?? "Null")
                // If not categories
                // TODO: HAndle not having categories
                self.categories = []
                return
            }
            var tempCategories: [Category] = []
            for (categoryId, category) in categoriesData {
                print("This should be the category Id:", categoryId)
                for item in self.categoriesId {
                    if categoryId == item {
                        var newCategory = Category(name: "", creationDate: Date(), modificationDate: Date(), allSpending: [], totalAmount: 0, viewId: "")
                        newCategory.name = category["name"] as? String ?? "Error"
                        newCategory.creationDate = Date(timeIntervalSince1970: category["creationDate"] as! Double)
                        newCategory.modificationDate = Date(timeIntervalSince1970: category["modificationDate"] as! Double)
                        newCategory.viewId = category["viewId"] as? String ?? "Error"
                        newCategory.id = item
                        newCategory.totalAmount = category["totalAmount"] as? Double ?? 0
                        tempCategories.append(newCategory)
                    }
                }
            }
            self.categories = tempCategories
        }) { (error) in
            print("Error: ", error.localizedDescription)
            // Will happen if there's no categories in the view because the path doesn't exist
            // Will almost never happen.
        }
    }
    
    func updateTableViewConstrains() {
////        let cellXCount = CGFloat(70 * categories.count)
////        if cellXCount >= 70 {
////        tableView.removeFromSuperview()
        tableViewBackground.removeFromSuperview()
////            addTableView()
////        }
        view.insertSubview(tableViewBackground, belowSubview: tableView)
//
//        view.removeConstraints(tableViewBackground.constraints)
//        tableViewBackground.constraints.removeAll()
        heightAnchor.isActive = false
        tableViewBackgroundConstrainsts()
//        heightAnchor = tableViewBackground.heightAnchor.constraint(equalToConstant: CGFloat(70 * categories.count))
//        heightAnchor.isActive = true
        tableViewBackground.layoutIfNeeded()
    }
    
    
    @objc func addButtonPressed() {
        let newSubCategoryVC = NewSubCategoryViewController()
        newSubCategoryVC.viewId = viewId
        self.present(newSubCategoryVC,animated: true)
//        print("Adding 70 to background of table view")
//        tableViewBackground.heightAnchor
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
//        cell.amount.text = "$" + categories[indexPath.row].totalAmount.formattedWithSeparator
        cell.selectionStyle = .none
        // Push your cell to the table view
        
        var amountValue = categories[indexPath.row].totalAmount
        
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
            cell.amount.text = "Tap me to add"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categorySpendingController = CategorySpendingViewController()
        categorySpendingController.categoryId = categories[indexPath.row].id
//        categorySpendingController.currentCategory = categories[indexPath.row]
        self.present(categorySpendingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Handle Deletion of firebase array.
            
            let categoryId = categoriesId[indexPath.row]
            let ref = Database.database().reference().child("users/\(self.uid)/categories/\(categoryId)/subCategoriesId")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let subCategoriesId = snapshot.value as? [String] else {
                    print("snapshot:",snapshot.value!)
                    return
                }
                
                for subCategoryId in subCategoriesId {
                    // Do the same thing with sub categories within categories and delete them one by one.
                    let subCategoryToDelete = Database.database().reference().child("users/\(self.uid)/subCategories/\(subCategoryId)")
                    subCategoryToDelete.removeValue { error, _ in
                        print(error ?? "Error didn't occur")
                    } // Removing all sub categoires within category
                }
                // Need to delete categories here (end of its loop)
                Database.database().reference().child("users/\(self.uid)/categories/\(categoryId)").removeValue { error, _ in
                    print(error ?? "Error didn't occur")
                }
            })
            // Need to delete categories here (end of its loop)
            Database.database().reference().child("users/\(self.uid)/categories/\(categoryId)").removeValue()
            

            
            
            categories.remove(at: indexPath.row)
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
