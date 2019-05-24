////
////  handleDataExtension.swift
////  InvestLog
////
////  Created by timofey makhlay on 1/27/19.
////  Copyright © 2019 Timofey Makhlay. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseDatabase
//import GoogleSignIn
//
//class HandleData {
//    
//    // Take a category object and save it to UserDefaults
//    func saveDataCategoryToUserDefaults(_ category: Category) {
//        if UserDefaults.standard.bool(forKey: "hasCategorySpending") == true {
//            let newCategory = Category(name: category.name, creationDate: category.creationDate, modificationDate: category.modificationDate, spendingArray: category.allSpending)
//            var categories = UserDefaults.standard.array(forKey: "CategorySpendingArray") as! [[String: [String: Any]]]
//            categories.append(newCategory.getDictionary())
//            UserDefaults.standard.set(categories, forKey: "CategorySpendingArray")
//            UserDefaults.standard.synchronize()
//        } else {
//            UserDefaults.standard.set(true, forKey: "hasCategorySpending")
//            let newCategory = Category(name: category.name, creationDate: category.creationDate, modificationDate: category.modificationDate, spendingArray: category.allSpending)
//            let categories = [newCategory.getDictionary()]
//            UserDefaults.standard.set(categories, forKey: "CategorySpendingArray")
//            UserDefaults.standard.synchronize()
//        }
//    }
//    
//    func saveTheEntireCategoryArrayToUserDefaults(_ array: [Category]) {
//        if UserDefaults.standard.bool(forKey: "hasCategorySpending") == true {
//            eraseAllCategoriesFromUserDefaults()
//            var tempArray: [[String: [String: Any]]] = []
//            
//            for category in array {
//                if category.allSpending.count == 0 {
//                    print(category.name, " is empty")
//                    
//                } else {
//                    print("Removing category spending to see if it solves the error.")
//                    category.allSpending = []
//                }
//                tempArray.append(category.getDictionary())
//            }
//            print(tempArray)
//            UserDefaults.standard.set(tempArray, forKey: "CategorySpendingArray")
//            UserDefaults.standard.synchronize()
//        } else {
//            UserDefaults.standard.set(true, forKey: "hasCategorySpending")
//            UserDefaults.standard.synchronize()
//            UserDefaults.standard.set(array, forKey: "CategorySpendingArray")
//            UserDefaults.standard.synchronize()
//        }
//    }
//    
//    func eraseAllCategoriesFromUserDefaults() {
//        UserDefaults.standard.set([], forKey: "CategorySpendingArray")
//        UserDefaults.standard.synchronize()
//    }
//
//    func pullCategoriesFromUserDefaults() -> [Category] {
//        let categories = UserDefaults.standard.array(forKey: "CategorySpendingArray") as? [[String: [String: Any]]] ?? []
//        return UnwrapCategoryDictionary(categories)
//    }
//    
//    // Unwrap a category from [[String: [String: Any]]] to [Category] object array
//    func UnwrapCategoryDictionary(_ array: [[String: [String: Any]]]) -> [Category] {
//        var tempCategory = [Category]()
//        var tempName = ""
//        var tempCreationDate = Date()
//        var tempModificationDate = Date()
//        var tempSpendingArray = [CategorySpending]()
//        for dict in array {
//            for (name, values) in dict {
//                tempName = name
//                var tempCounter = 0
//                for (valueName, value) in values {
//                    tempCounter += 1
//                    if valueName == "CreationDate" {
//                        tempCreationDate = value as! Date
//                    } else if valueName == "LastModified" {
//                        tempModificationDate = value as! Date
//                    } else if valueName == "SpendingArray" {
//                        let secondTempSpendingArray = value as? [[Date: Double]] ?? []
//                        for spending in secondTempSpendingArray {
//                            for (date, amount) in spending {
//                                let newSpending = CategorySpending(amount: amount, creationDate: date)
//                                tempSpendingArray.append(newSpending)
//                            }
//                        }
//                    }
//                }
//            }
//            tempCategory.append(Category(name: tempName, creationDate: tempCreationDate, modificationDate: tempModificationDate, spendingArray: tempSpendingArray))
//        }
//        return tempCategory
//    }
//    
//    func readPropertiesFromDatabase() {
//        let userUID = Auth.auth().currentUser?.uid
//        print("Setting query Path and saving firebase data Locally. User Id : ", userUID!)
//        
//        // Path to user's properties
//        let query = Database.database().reference().child("users").child(userUID!).child("InvestLog").child("ThisMonth").child("Categories")
//        // Using the path find the properties.
//        query.observe(.value, with: { snapshot in
//            print("SnapSHot as any: ", snapshot.value!)
//            // If there is data already, make the data into an array and save it as userdefaults.
//            if let snapshotValue = snapshot.value as? [[String: [String: Any]]] {
//                print("Snapshot value as super array: ", snapshotValue)
//                
//                print("dataProperties value as super array: ", snapshotValue)
//                UserDefaults.standard.set(snapshotValue, forKey: "properties")
//                // Making sure that the rest of the app knows that there are properties already in the app.
//                UserDefaults.standard.set(true, forKey: "hasProperty")
//                UserDefaults.standard.synchronize()
//            } else {
//                UserDefaults.standard.set(false, forKey: "hasProperty")
//                UserDefaults.standard.synchronize()
//            }
//        })
//    }
//}
