//
//  BackgroundViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/23/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Lottie
//import FirebaseDatabase

/*
 I know this is weird, but hear me out :)! I'm making this controller to always be in the background playing, no matter what view you're on!
 */

protocol VCHandler: class {
    func openFirstVC()
    func openPresentCategoriesVC(id:String)
    func openPresentSubCategoryVC(viewId:String, categoryId: String)
    func goBackToLogIn()
}

class BackgroundViewController: UIViewController, VCHandler {
    // Animation view
    let background = LOTAnimationView(name: "background")
    var firstTime = true
    
    
    let loginVC = LoginViewController()
    let mainVC = FirstViewController()
    let presentCategoriesVC = PresentCategoryViewController()
    let presentSubCategoryVC = CategorySpendingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        
        loginVC.delegate = self
        mainVC.delegate = self
        presentCategoriesVC.delegate = self
        presentSubCategoryVC.delegate = self
        
        // Putting the animation in and setting it up.
        view.addSubview(background)
        background.fillSuperview()
        background.contentMode = .scaleAspectFit
        background.loopAnimation = true
        background.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if UserDefaults.standard.integer(forKey: "numberOfUses") > 0 {
            loginVC.modalPresentationStyle = .overFullScreen
            firstTime = false
            self.present(loginVC, animated: false)
        } else {
            // Onboarding handle.

            // Present onboarding VC
            loginVC.modalPresentationStyle = .overFullScreen
            firstTime = false
            self.present(loginVC, animated: false)
            loginVC.present(OnboardingViewController(), animated: true)
        }
    }
    
    func goBackToLogIn() {
        loginVC.modalPresentationStyle = .overFullScreen
        self.present(loginVC, animated: true)
    }
    
    func openFirstVC() {
        mainVC.findUserData()
        mainVC.modalPresentationStyle = .overFullScreen
        self.present(mainVC, animated: true)
    }
    
    func openPresentSubCategoryVC(viewId:String, categoryId: String) {
        presentSubCategoryVC.categoryId = categoryId
        presentSubCategoryVC.viewId = viewId
        presentSubCategoryVC.getCategoryDataFrom(id: categoryId)
//        presentSubCategoryVC.getViewDataFrom(id: presentCategoriesVC.viewId)
        presentSubCategoryVC.modalPresentationStyle = .overFullScreen
        self.present(presentSubCategoryVC, animated: true)
    }
    
    func openPresentCategoriesVC(id:String) {
        print("Adding presnet VC")
        presentCategoriesVC.viewId = id
        presentCategoriesVC.getViewDataFrom(id: presentCategoriesVC.viewId)
        presentCategoriesVC.modalPresentationStyle = .overFullScreen
        self.present(presentCategoriesVC, animated: true)
    }
}
