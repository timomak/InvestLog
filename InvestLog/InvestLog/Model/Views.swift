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
    var id = ""
    
    
    func getNewTotalAmount() -> Double {
        var total: Double = 0
        for category in categories {
            for spending in category.allSpending {
                total += spending.amount
            }
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
    var allSpending: [CategorySpending]
    
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
}

struct CategorySpending {
    var creationDate: Date
    var amount: Double
    
    func getDictionary() -> [String:Any] {
        return [
            "creationDate":creationDate,
            "amount":amount
        ]
    }
}

