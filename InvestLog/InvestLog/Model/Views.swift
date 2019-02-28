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
    
    init(name:String, totalAmount: Double = 0, categories:[Category] = [], id: String = "") {
        self.name = name
        self.totalAmount = totalAmount
        self.categories = categories
        self.id = id
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
            "categories": temp
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
    
    init(name:String, creationDate: Date, modificationDate: Date, allSpending:[CategorySpending] = [], totalAmount: Double = 0) {
        self.name = name
        self.totalAmount = totalAmount
        self.creationDate = creationDate
        self.allSpending = allSpending
        self.modificationDate = modificationDate
    }
    
    func getDictionary() -> [String:Any] {
        var temp: [[String:Any]] = []
        
        for item in allSpending {
            temp.append(item.getDictionary())
        }
        return [
            "name": name,
            "creationDate":creationDate,
            "modificationDate": modificationDate,
            "allSpending": allSpending
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
    
    init(creationDate: Date, amount:Double) {
        self.creationDate = creationDate
        self.amount = amount
    }
    
    func getDictionary() -> [String:Any] {
        return [
            "creationDate":creationDate,
            "amount":amount
        ]
    }
}

