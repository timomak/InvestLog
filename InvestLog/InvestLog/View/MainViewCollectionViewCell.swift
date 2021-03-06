//
//  MainViewCollectionViewCell.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/25/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import SnapKit


class MainCollectionViewCell: UICollectionViewCell {
    
    var background: UIView = {
        var view = UIView()
        view.layer.borderWidth = 0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.borderColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        view.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = UIScreen.main.bounds.width / 27.6
        return view
    }()
    // Addting title to Navbar
    let label: UITextView = {
        var title = UITextView()
        title.text = "This month"
        title.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.03)
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isSelectable = false
        title.isScrollEnabled = false
        return title
    }()

    
    var amount: UITextView = {
        var title = UITextView()
        title.text = "$"
        title.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.03)
        title.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    var removeWrapper: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.52366817, blue: 0.4613674879, alpha: 1)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
// remove button
    let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: UIScreen.main.bounds.height * 0.04)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(FirstViewController.deleteCurrentCell(sender:)), for: .touchUpInside)
        return button
    }()
    
    var stack = UIStackView()
    
    var currentlyEditing = false {
        didSet{
            removeWrapper.isHidden = !currentlyEditing
        }
    }
    
    // Weird discovery: When you tap on the labels, the taps aren't registered by the cell. I had to put a transparent UIView on top of the cell to make everything work.
    
    var transparentView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        // Constant to set font size relative for device.
        let relativeFontConstant:CGFloat = 0.03

        let textLabels = [label, amount]


        for label in textLabels {
            label.font = label.font!.withSize(UIScreen.main.bounds.height * relativeFontConstant)
        }
    }
    
    func setUpLayout() {
        addSubview(background)
        background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        background.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self)
        }
//        background.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        stack = UIStackView(arrangedSubviews: [label,amount])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        
        addSubview(stack)
//        stack.centerOfView(to: background)
        stack.snp.makeConstraints { (make) in
            make.left.right.equalTo(background)
            make.centerY.equalTo(background)
        }
        addSubview(transparentView)
        transparentView.anchorSize(to: self)
        transparentView.centerOfView(to: self)
        addSubview(removeWrapper)
        
        
        removeWrapper.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: -6, left: -6, bottom: 0, right: 0), size: .init(width: UIScreen.main.bounds.width / 14, height: UIScreen.main.bounds.width / 14))
        
        removeWrapper.layer.cornerRadius = UIScreen.main.bounds.width / 28
        removeWrapper.addSubview(removeButton)
        removeButton.centerOfView(to: removeWrapper)
        removeButton.isUserInteractionEnabled = true

        removeWrapper.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
