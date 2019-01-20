//
//  ViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 1/19/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // All views
    var thisMonthView = ThisMonthView()
    var settingsView = SettingsView()
    
    
    // Page Control
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 2
        pc.numberOfPages = 2
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0, green: 0.7128543258, blue: 0.5906786323, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
        pageControlSetup()
        pageControl.currentPage = 1
        currentPage()
        // Adding swipe gesture recognizers
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    // Set up Page Control
    func pageControlSetup() {
        view.addSubview(pageControl)
        pageControl.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        pageControl.index(ofAccessibilityElement: 5)
    }
    
    func nextPage() {
        if pageControl.currentPage == 1 {
            print("Last page already")
        }
        else {
            pageControl.currentPage += 1
        }
    }
    
    func previousPage() {
        if pageControl.currentPage == 0 {
            print("Last page already")
        }
        else {
            pageControl.currentPage -= 1
        }
    }
    
    func currentPage() {
        // Load the page
        switch pageControl.currentPage {
        case 0:
            print("Settings")
            removeAllViews()
            settingsView.loadSelf(superView: view, pc: pageControl)
        case 1:
            print("This Month")
            removeAllViews()
            thisMonthView.loadSelf(superView: view, pc: pageControl)
        default:
            print("Work in progress")
        }
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        // Swipe gesture recognizer action
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Going left")
                // Update page control
                previousPage()
                
                currentPage()
            case UISwipeGestureRecognizer.Direction.left:
                print("Going right")
                // Update page control
                nextPage()
                currentPage()
                
            default:
                break
            }
        }
    }
    
    func removeAllViews() {
        thisMonthView.background.removeFromSuperview()
        settingsView.background.removeFromSuperview()
    }


}


