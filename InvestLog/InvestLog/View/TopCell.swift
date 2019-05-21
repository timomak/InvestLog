//
//  TopCell.swift
//  InvestLog
//
//  Created by timofey makhlay on 3/28/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import SnapKit

class TopCollectionViewCell: UICollectionViewCell {
    
    
    // Creating Navbar
    private let navbar: UIView = {
        let navigationBar = UIView()
        navigationBar.alpha = 0
        return navigationBar
    }()
    
    // Addting title to Navbar
    let viewNavbarTitle: UITextView = {
        var title = UITextView()
        title.text = "Categories"
        title.font = UIFont(name: "AvenirNext-Medium", size: 60)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    // Constant to set font size relative for device.
    let relativeFontConstant:CGFloat = 0.05
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewNavbarTitle.font = viewNavbarTitle.font!.withSize(UIScreen.main.bounds.height * relativeFontConstant)

        addSubview(navbar)
        addSubview(viewNavbarTitle)
        
        
        navbar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(self.bounds.height)
        }
//        navbar.alpha = 1
//        navbar.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        
        viewNavbarTitle.snp.makeConstraints { (make) in
            make.left.equalTo(safeAreaLayoutGuide).offset(15)
            make.centerY.equalTo(navbar)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
