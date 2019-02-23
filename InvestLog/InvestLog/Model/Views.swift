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
}

struct Category {
    // Category
    var name: String
    var creationDate: Date
    var modificationDate: Date
    var allSpending: [CategorySpending]
}

struct CategorySpending {
    var creationDate: Date
    var amount: Double
}

