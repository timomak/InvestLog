//
//  InvestLogTests.swift
//  InvestLogTests
//
//  Created by timofey makhlay on 5/23/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import XCTest
import UIKit
import Fire


/// Testing Creating complex data and deleting it from Firebase.
class InvestLogTestDataFirebase: XCTestCase {
    
    /// The user ID (I'm using my own in this case.
    let uid = "gpEFfnoS4fT36bQVqk9g7t5OUhG2"
    
    /// Firebase reference
    var ref: DatabaseReference!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func findUserData() {
        //        uid = UserDefaults.standard.dictionary(forKey: "uid")!["uid"]! as! String
        ref = Database.database().reference().child("users/\(uid)/views")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: [String:Any]] else {
                // TODO: Handle error
                print("snapshot: ",snapshot.value)
                
                // Will happen if there's no views on database
                self.noViewsInFirebase()
                
                
                return
            }
            var newViews:[Views] = []
            
            // Will only get the name and total Amount for all the Views on Firebase
            for (key,item) in value {
                print("key: ", key)
                var newView = Views(name: "", totalAmount: 0.0, categories: [], id: key)
                newView.name = item["name"] as! String
                newView.totalAmount = item["totalAmount"] as! Double
                // TODO: viewCategory into category struct
                newViews.append(newView)
            }
            print("new views: ", newViews)
            
            self.allViews = newViews
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
