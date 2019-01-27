//
//  categories.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/20/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class Category {
    // Category
    var name: String
    var creationDate: Date
    var modificationDate: Date
    var allSpending = [CategorySpending]()
    
    init(name: String, creationDate: Date, modificationDate: Date, spendingArray: [CategorySpending] = []) {
        self.name = name
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.allSpending = spendingArray
    }
    
    // Function to determine the color [Red or Green]
    // Function to find the accumulated spending
    
    
    // Function to return property in JSON format to be able to store it with Firebase
    func getDictionary() -> [String: [String: Any]] {
        return [name: ["CreationDate": creationDate, "LastModified": modificationDate, "SpendingArray": getSpendingDictionary()]]
    }
    
    func getSpendingDictionary() -> [[Date: Double]] {
        var tempArray = [[Date: Double]]()
        for category in allSpending{
            tempArray.append(category.getDictionary())
        }
        return tempArray
    }
}

class CategorySpending {
    var creationDate: Date
    var amount: Double
    
    init(amount: Double, creationDate: Date) {
        self.amount = amount
        self.creationDate = creationDate
    }
    func getDictionary() -> [Date: Double] {
        return [creationDate: amount]
    }
    
}

