//
//  TableViewCell.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/19/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var name: UITextView = {
        var title = UITextView()
        title.text = "name"
        title.font = UIFont(name: "AvenirNext-Bold", size: 25)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    var colorIndicator: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    var amount: UITextView = {
        var title = UITextView()
        title.text = "$"
        title.font = UIFont(name: "AvenirNext-Regular", size: 25)
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    private let line: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(name)
        name.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        name.centerVerticalOfView(to: self)
        
        addSubview(colorIndicator)
        colorIndicator.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10), size: .init(width: 150, height: 42))
        colorIndicator.centerVerticalOfView(to: name)
        
        addSubview(amount)
        amount.centerOfView(to: colorIndicator)
        
        addSubview(line)
        line.anchor(top: name.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: 2))
    }
    
    // Required with initilizer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
