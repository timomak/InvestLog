//
//  MainViewCollectionViewCell.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/25/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class MaiCollectionViewCell: UICollectionViewCell {
    var background: UIView = {
        var view = UIView()
        view.layer.borderWidth = 0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 5
        view.layer.shadowPath = CGPath(ellipseIn: CGRect(x: 0,
                                                         y: 147,
                                                         width: (UIScreen.main.bounds.width/2) - 15,
                                                         height: 20),
                                       transform: nil)
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.borderColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        view.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 35
        return view
    }()
    // Addting title to Navbar
    let label: UITextView = {
        var title = UITextView()
        title.text = "This month"
        title.font = UIFont(name: "AvenirNext-Bold", size: 28)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()
    
    var colorIndicator: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        view.layer.cornerRadius = 10
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
    // Weird discovery: When you tap on the labels, the taps aren't registered by the cell. I had to put a transparent UIView on top of the cell to make everything work.
    var transparentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    func setUpLayout() {
        addSubview(background)
        background.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 5, bottom: 10, right: 5))
        addSubview(label)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
        addSubview(colorIndicator)
        colorIndicator.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 100, left: 20, bottom: 45, right: 20))
        addSubview(amount)
        amount.centerOfView(to: colorIndicator)
        addSubview(transparentView)
        transparentView.anchorSize(to: self)
        transparentView.centerOfView(to: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
