//
//  OnboardingViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/22/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Lottie
import SnapKit

// TODO: Watch tutorial and use scrolling animation.
/*
This is only going to be shown the first time the user opens the app. Onboarding...
*/
class OnboardingViewController: UIViewController {
    var animationTime = 0.0
    let animationView = LOTAnimationView(name: "onboarding")
    let background = LOTAnimationView(name: "background")
    
    let nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 23)
        button.addTarget(self, action: #selector(nextPageButtonPressed), for: .touchDown)
        return button
    }()
    
    let prevPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("PREV", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 23)
        button.addTarget(self, action: #selector(prevPageButtonPressed), for: .touchDown)
        return button
    }()
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 4
        control.pageIndicatorTintColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        control.currentPageIndicatorTintColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        return control
    }()
    
    // Return button
    private let returnButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
//        button.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        button.addTarget(self, action: #selector(returnButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // Text Container
    let textContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9426227212, green: 0.9370191097, blue: 0.9469299912, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        return view
    }()
    
    // Header text
    let headerText: UITextView = {
        var title = UITextView()
        title.text = "Header"
        title.font = UIFont(name: "AvenirNext-Bold", size: 22)
        title.textColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        return title
    }()
    
    // Body Text
    let bodyText: UITextView = {
        var title = UITextView()
        let spacing = NSMutableParagraphStyle()
        spacing.lineSpacing = 7
        let attribute = [NSAttributedString.Key.paragraphStyle : spacing]
        title.typingAttributes = attribute
        title.text = "Header"
        title.textColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        title.backgroundColor = nil
        title.textAlignment = .center
        title.isEditable = false
        title.isScrollEnabled = false
        title.isSelectable = false
        title.font = UIFont(name: "AvenirNext-Medium", size: 20)
        return title
    }()
    
    // Constant to set font size relative for device.
    let relativeFontConstant:CGFloat = 0.03
    
    let arrayOfInformation = [
        ["Welcome To InvestLog","InvestLog is an App made by Timofey Makhlay to help people track their finances manually and efficiently."],
        ["Multiply your Freedom","You decide how to organize your spending. Never again worry if you have enough money or depend on apps to do it for you, often incorrectly."],
        ["Create Categories","You can create categories and sub-categories within to organize your spending."],
        ["Grow your Wealth","Track, Learn and Grow. Enjoy your experience!\nIf you encounter issues please email:\ntmakhlay2@gmail.com"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set each label's font size relative to the screen size
        let textLabels = [bodyText, headerText]
        
        let buttons = [returnButton, nextPageButton, prevPageButton]
        
        for label in textLabels {
            label.font = label.font!.withSize(self.view.frame.height * relativeFontConstant)
        }
        
        for button in buttons {
            button.titleLabel?.font = button.titleLabel?.font.withSize(self.view.frame.height * relativeFontConstant)
        }
        // UI Setup
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        view.addSubview(background)
        view.addSubview(animationView)
        view.addSubview(nextPageButton)
        view.addSubview(prevPageButton)
        view.addSubview(pageControl)
        view.addSubview(textContainer)
        view.addSubview(headerText)
        view.addSubview(bodyText)
        view.addSubview(returnButton)
        
        // Background Animation setup
        background.fillSuperview()
        background.contentMode = .scaleAspectFit
        background.loopAnimation = true
        background.play()
        
        // Stack for page control
        let stackControl =  UIStackView(arrangedSubviews: [prevPageButton,pageControl,nextPageButton])
        stackControl.axis = .horizontal
        stackControl.distribution = .fillEqually
        view.addSubview(stackControl)
        
        returnButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        animationView.snp.makeConstraints { (make) in
            make.top.equalTo(returnButton).inset(view.bounds.height / 20)
            make.height.equalTo((view.bounds.width) / 1.6)
            make.width.equalTo(animationView.snp.height)
            make.centerX.equalToSuperview()
        }
        
        stackControl.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }

        textContainer.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom).offset(view.bounds.width / 12)
            make.left.equalToSuperview().offset(view.bounds.width / 12)
            make.right.equalToSuperview().inset(view.bounds.width / 12)
            make.bottom.equalTo(stackControl.snp.top).offset((view.bounds.width / 12) * -1)
        }
        
        headerText.snp.makeConstraints { (make) in
            make.top.equalTo(textContainer.snp.top).offset(5)
            make.centerX.equalTo(textContainer)
        }
        
        bodyText.snp.makeConstraints { (make) in
            make.top.equalTo(headerText.snp.bottom).offset(5)
            make.centerX.equalTo(headerText)
            make.left.right.equalTo(textContainer)
        }

//        headerText.anchor(top: textContainer.topAnchor, leading: textContainer.leadingAnchor, bottom: nil, trailing: textContainer.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
//
//        bodyText.anchor(top: headerText.bottomAnchor, leading: textContainer.leadingAnchor, bottom: nil, trailing: textContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//
        updateText()
    }
}

// Non-Ui related code.
extension OnboardingViewController {
    
    @objc func nextPageButtonPressed() {
        if pageControl.currentPage != 3 {
            
            pageControl.currentPage += 1
            
            if animationTime == 0 {
                animationTime += 0.5
            }
            else {
                animationTime += 0.25
            }
            
            headerText.text = arrayOfInformation[pageControl.currentPage][0]
            bodyText.text = arrayOfInformation[pageControl.currentPage][1]
            prevPageButton.isEnabled = false
            nextPageButton.isEnabled = false
            animationView.play(toProgress: CGFloat(animationTime), withCompletion: { (bool) in
                self.prevPageButton.isEnabled = true
                self.nextPageButton.isEnabled = true
            })
        }
        else {
            self.dismiss(animated: true)
        }
    }
    
    @objc func prevPageButtonPressed() {
        if pageControl.currentPage != 0 {
            pageControl.currentPage -= 1
            var currentAnimationTime = animationTime
            if animationTime == 0.5 {
                animationTime -= 0.5
            }
            else {
                animationTime -= 0.25
            }
            headerText.text = arrayOfInformation[pageControl.currentPage][0]
            bodyText.text = arrayOfInformation[pageControl.currentPage][1]
            
            prevPageButton.isEnabled = false
            nextPageButton.isEnabled = false
            animationView.play(fromProgress: CGFloat(currentAnimationTime), toProgress: CGFloat(animationTime), withCompletion: { (bool) in
                self.prevPageButton.isEnabled = true
                self.nextPageButton.isEnabled = true
            })
        }
        else {
            prevPageButton.shake()
        }
    }
    
    func updateText() {
        if pageControl.currentPage == 0 {
            headerText.text = arrayOfInformation[0][0]
            bodyText.text = arrayOfInformation[0][1]
        }
    }
    
    @objc func returnButtonPressed() {
        self.dismiss(animated: true)
    }
}
