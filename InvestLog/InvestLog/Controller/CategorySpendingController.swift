//
//  CategorySpending.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/27/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategorySpendingViewController: UIViewController {
    // For firebase data
    var ref: DatabaseReference!
    var uid: String = ""
    var categoryId: String = ""
    var spendingId: [String] = []
    
    var allSpending:[CategorySpending] = [] {
        didSet {
            allSpending = allSpending.sorted(by: { $0.creationDate > $1.creationDate})
            tableView.reloadData()
        }
    }
    
//    var currentCategory: Category = Category(name: "Error", creationDate: Date(), modificationDate: Date(), allSpending: [])
    
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
//        currentCategory.allSpending = [CategorySpending(creationDate: Date(), amount: 3000)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getCategoryDataFrom(id: categoryId)
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
//        viewNavbarTitle.text = currentCategory.name
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
    
//    func getCategoryId
    
    @objc func goBackButtonPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func addNewCategorySpending() {
        print("Creating new category")
//        currentCategory.allSpending.append(CategorySpending(amount: 4000, creationDate: Date()))
//        tableView.reloadData()
//        print(currentCategory.allSpending)
        let inputSpendingController = InputSpendingController()
//        inputSpendingController.currentCategory = currentCategory
        inputSpendingController.categoryId = categoryId
        self.present(inputSpendingController, animated: true)
    }
    
    func getCategoryDataFrom(id: String) {
        // Using the view id, get all the categories under that Id and load those categories.
        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        ref = Database.database().reference().child("users/\(uid)/categories/\(id)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let viewData = snapshot.value as? [String:Any] else {
                // TODO: Handle error
                print("snapshot: ",snapshot.value ?? "Null")
                
                // Will happen if there's no categories in the view but there is a path
                //                self.categories = []
                
                return
            }
            
            self.viewNavbarTitle.text = viewData["name"] as? String ?? "Error"
//            self.totalAmount = viewData["totalAmount"] as? Double ?? 0
            //            self.categoriesId = viewData["categoriesId"] as? [String] ?? []
            
            let subCategoriesInfo = viewData["subCategoriesId"] as? [String] ?? []
            if subCategoriesInfo != [] {
                self.spendingId = subCategoriesInfo
                // Call function to fill categories
                self.findSubCategoriesData()
            }
            else {
                self.allSpending = []
            }
            
            
        }) { (error) in
            print("Error: ", error.localizedDescription)
            // Will happen if there's no categories in the view because the path doesn't exist
            // Will almost never happen.
        }
    }
    
    func findSubCategoriesData() {
        ref = Database.database().reference().child("users/\(uid)/subCategories")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let subCategoriesData = snapshot.value as? [String:[String:Any]] else {
                print("snapshot: ",snapshot.value ?? "Null")
                // If not categories
                // TODO: HAndle not having categories
                self.allSpending = []
                return
            }
            var tempAllSpending: [CategorySpending] = []
            for (subCategoryId, subCategory) in subCategoriesData {
                print("This should be the sub category Id:", subCategoryId)
                for item in self.spendingId {
                    if subCategoryId == item {
                        var newSubCategory = CategorySpending(creationDate: Date(), amount: 0, categoryId: "", id: "")
                        newSubCategory.creationDate = Date(timeIntervalSince1970: subCategory["creationDate"] as! Double)
                        newSubCategory.amount = subCategory["amount"] as? Double ?? 0
                        newSubCategory.id = subCategoryId
                        tempAllSpending.append(newSubCategory)
                    }
                }
            }
            self.allSpending = tempAllSpending
        }) { (error) in
            print("Error: ", error.localizedDescription)
            // Will happen if there's no categories in the view because the path doesn't exist
            // Will almost never happen.
        }
    }
}

extension CategorySpendingViewController: UITableViewDataSource {
    // Table View Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSpending.count
    }
    
    // Table View Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create Cells one by one using this as a blueprint.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        
        // Format Date to String
        let df = DateFormatter()
        df.dateFormat = "MMM dd yyyy"
        
        // Set the cell label text
        cell.name.text = df.string(from: allSpending[indexPath.row].creationDate)
//        cell.colorIndicator.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
//        cell.amount.text = "$" + allSpending[indexPath.row].amount.formattedWithSeparator
        cell.selectionStyle = .none
        cell.backgroundColor = tableView.backgroundColor
        
        
        var amountValue = allSpending[indexPath.row].amount
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let categorySpendingController = CategorySpendingController()
//        categorySpendingController.currentCategory = categories[indexPath.row]
//        self.present(categorySpendingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: Handle Deletion of UserDefaults array.
            let spendingId = allSpending[indexPath.row].id
            let spendingAmount = allSpending[indexPath.row].amount
            let ref = Database.database().reference().child("users/\(self.uid)/subCategories/\(spendingId)")
            
            // Update category total.
            let ref2 = Database.database().reference().child("users/\(self.uid)/categories/\(self.categoryId)/totalAmount")
            ref2.observeSingleEvent(of: .value, with: { (snapshot) in
                guard var totalCategoryAmount = snapshot.value as? Double else {
                    print("snapshot:",snapshot.value!)
                    return
                }
                totalCategoryAmount -= spendingAmount
                let ref3 = Database.database().reference().child("users/\(self.uid)/categories/\(self.categoryId)")
                ref3.updateChildValues(["totalAmount":totalCategoryAmount])
                
                let ref4 = Database.database().reference().child("users/\(self.uid)/categories/\(self.categoryId)/subCategoriesId")
                ref4.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard var subCategoriesId = snapshot.value as? [String] else {
                        print("snapshot:",snapshot.value!)
                        return
                    }
                    var newSpendingArray: [String] = []
                    for id in subCategoriesId {
                        if id != spendingId {
                            newSpendingArray.append(id)
                        }
                    }
                    // Updating array without this one.
                    ref4.updateChildValues(["subCategoriesId":newSpendingArray])
                })

                
                // Need to delete categories here (end of its loop)
                ref.removeValue { error, _ in
                    print(error ?? "Error didn't occur")
                    
                }
            })
            


            allSpending.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

extension CategorySpendingViewController: UITableViewDelegate {
    //     Table View Cell Styling
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Deselected")
    }
}
