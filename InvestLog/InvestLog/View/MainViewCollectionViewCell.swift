//
//  MainViewCollectionViewCell.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/25/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

// Delegate to ViewController to delete
protocol MainCollectionViewCellDelegate {
    func delete(category: MainCollectionViewCell)
}

class MainCollectionViewCell: UICollectionViewCell {
    
    // Adding delegate
    var delegate:MainCollectionViewCellDelegate?
    
    var background: UIView = {
        var view = UIView()
        view.layer.borderWidth = 0
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.borderColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        view.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 50
        return view
    }()
    // Addting title to Navbar
    let label: UITextView = {
        var title = UITextView()
        title.text = "This month"
        title.font = UIFont(name: "AvenirNext-Medium", size: 28)
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
        title.font = UIFont(name: "AvenirNext-Medium", size: 25)
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
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 60)
        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(removeButtonPressed), for: .touchDown)
        return button
    }()
    
    var stack = UIStackView()
    
    var currentlyEditing = false {
        didSet{
            removeWrapper.isHidden = !currentlyEditing
//            print("Should Be hidden:", !currentlyEditing)
        }
    }
    
    // Weird discovery: When you tap on the labels, the taps aren't registered by the cell. I had to put a transparent UIView on top of the cell to make everything work.
    
    var transparentView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    func setUpLayout() {
        addSubview(background)
        background.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        background.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        stack = UIStackView(arrangedSubviews: [label,amount])
        stack.axis = .vertical
        stack.spacing = -10
        
        addSubview(stack)
        stack.centerOfView(to: background)
        addSubview(transparentView)
        transparentView.anchorSize(to: self)
        transparentView.centerOfView(to: self)
        addSubview(removeWrapper)
        removeWrapper.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        
        removeWrapper.layer.cornerRadius = 15
        addSubview(removeButton)
        removeButton.centerOfView(to: removeWrapper)
        removeButton.isUserInteractionEnabled = true
//        
//        // Temp
//        var tempView = UIView()
//        tempView.alpha = 0.5
//        tempView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        removeWrapper.addSubview(tempView)
//        tempView.viewConstantRatio(widthToHeightRatio: 1, width: .init(width: 30, height: 30))
//        tempView.centerOfView(to: removeWrapper)
        removeWrapper.isHidden = true
    }
    
    @objc func removeButtonPressed(_ sender: Any) {
        print("Should be deleting")
        delegate?.delete(category: self)
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
