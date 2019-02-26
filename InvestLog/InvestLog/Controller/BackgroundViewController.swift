//
//  BackgroundViewController.swift
//  InvestLog
//
//  Created by timofey makhlay on 2/23/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit
import Lottie

/*
 I know this is weird, but hear me out :)! I'm making this controller to always be in the background playing, no matter what view you're on!
 */

class BackgroundViewController: UIViewController, OpenFirstVC {
    // Animation view
    let background = LOTAnimationView(name: "background")
    var firstTime = true
    
    
    let loginVC = LoginViewController()
    let mainVC = FirstViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.9333333333, blue: 0.8117647059, alpha: 1)
        
        loginVC.delegate = self
        
        // Putting the animation in and setting it up.
        view.addSubview(background)
        background.fillSuperview()
        background.contentMode = .scaleAspectFit
        background.loopAnimation = true
        background.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
            loginVC.modalPresentationStyle = .overFullScreen
            firstTime = false
            self.present(loginVC, animated: false)
    }
    func openFirstVC() {
        mainVC.modalPresentationStyle = .overFullScreen
        self.present(mainVC, animated: true)
    }
}
