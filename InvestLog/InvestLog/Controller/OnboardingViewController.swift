//
//  OnboardingViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/22/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Lottie

// TODO: Watch tutorial and use scrolling animation.
""" This is only going to be shown the first time the user opens the app. Onboarding... """
class OnboardingViewController: UIViewController {
    var animationTime = 0.0
    let animationView = LOTAnimationView(name: "onboarding")
    let background = LOTAnimationView(name: "background")
    
    let nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("NEXT", for: .normal)
        button.addTarget(self, action: #selector(nextPageButtonPressed), for: .touchDown)
        return button
    }()
    
    let prevPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("PREV", for: .normal)
        button.addTarget(self, action: #selector(prevPageButtonPressed), for: .touchDown)
        return button
    }()
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 4
        control.pageIndicatorTintColor = #colorLiteral(red: 0.1075617597, green: 0.09771008044, blue: 0.1697227657, alpha: 1)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        view.addSubview(background)
        view.addSubview(animationView)
        view.addSubview(nextPageButton)
        view.addSubview(prevPageButton)
        view.addSubview(pageControl)
        
        
        background.fillSuperview()
        background.contentMode = .scaleAspectFit
        background.loopAnimation = true
        background.play()
        
        animationView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: (view.bounds.width - 100) / 1.3, height: (view.bounds.width - 90) / 1.3))
        animationView.centerHorizontalOfView(to: view)
        
        
//        nextPageButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 5, right: 15))
////        animationView.loopAnimation = true
////        animationView.play()
//
//        prevPageButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: 5, right: 0))
//
//
        let stackControl =  UIStackView(arrangedSubviews: [prevPageButton,pageControl,nextPageButton])
        stackControl.axis = .horizontal
        stackControl.distribution = .fillEqually
        
        view.addSubview(stackControl)
        stackControl.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10))
        
    }
    
    @objc func nextPageButtonPressed() {
        pageControl.currentPage += 1
        if animationTime == 0 {
            animationTime += 0.5
        }
        else {
            animationTime += 0.25
        }
        if animationTime == 1 {
            // TODO: Next view
            // TODO: Change text to done right before last "Next"
        }
        animationView.play(toProgress: CGFloat(animationTime), withCompletion: nil)
    }
    
    @objc func prevPageButtonPressed() {
        pageControl.currentPage -= 1
        var currentAnimationTime = animationTime
        if animationTime == 0.5 {
            animationTime -= 0.5
        }
        else {
            animationTime -= 0.25
        }
        animationView.play(fromProgress: CGFloat(currentAnimationTime), toProgress: CGFloat(animationTime), withCompletion: nil)
    }
}
