//
//  viewz.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/25/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

struct Views {
    var name: String
    var totalAmount: Double
    var categories: [Category]
    var id: String
    var categoriesId:[String]
    
    init(name:String, totalAmount: Double = 0, categories:[Category] = [], id: String = "", categoriesId:[String] = []) {
        self.name = name
        self.totalAmount = totalAmount
        self.categories = categories
        self.id = id
        self.categoriesId = categoriesId
    }
    
    func getNewTotalAmount() -> Double {
        var total: Double = 0
        for category in categories {
            total += category.getTotalAmount()
        }
        return total
    }
    
    func getDictionary() -> [String:Any] {
        var temp: [[String:Any]] = []
        
        for category in categories {
            temp.append(category.getDictionary())
        }
        return [
            "name": name,
            "totalAmount": getNewTotalAmount(),
            "categoriesId": categoriesId
        ]
    }
}

struct Category {
    // Category
    var name: String
    var creationDate: Date
    var modificationDate: Date
    var totalAmount: Double
    var allSpending: [CategorySpending]
    var viewId: String
    
    init(name:String, creationDate: Date, modificationDate: Date, allSpending:[CategorySpending] = [], totalAmount: Double = 0, viewId: String = "") {
        self.name = name
        self.totalAmount = totalAmount
        self.creationDate = creationDate
        self.allSpending = allSpending
        self.modificationDate = modificationDate
        self.viewId = viewId
    }
    
    func getDictionary() -> [String:Any] {
        // Things to later handle time
//        let df = DateFormatter()
//        df.dateFormat = "MMM dd yyyy"
//        // gives date with time portion in UTC 0
//        let date = Date(timeIntervalSince1970: timestamp)

        return [
            "name": name,
            "creationDate":creationDate.timeIntervalSince1970,
            "modificationDate": modificationDate.timeIntervalSince1970,
            "allSpending": allSpending,
            "viewId": viewId,
            "totalAmount": totalAmount
        ]
    }
    
    func getTotalAmount() -> Double {
        var total: Double = 0
        for item in allSpending {
            total += item.amount
        }
        return total
    }
}

struct CategorySpending {
    var creationDate: Date
    var amount: Double
    var categoryId: String
    
    init(creationDate: Date, amount:Double, categoryId:String = "") {
        self.creationDate = creationDate
        self.amount = amount
        self.categoryId = categoryId
    }
    
    func getDictionary() -> [String:Any] {
        return [
            "creationDate":creationDate,
            "amount":amount
        ]
    }
}
