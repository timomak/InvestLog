//
//  InvestLogTests.swift
//  InvestLogTests
//
//  Created by timofey makhlay on 5/23/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import XCTest
import UIKit
import FirebaseDatabase


/// Testing Creating complex data and deleting it from Firebase.
class InvestLogTests: XCTestCase {
    
    /// The user ID (I'm using my own in this case.
    let uid = "gpEFfnoS4fT36bQVqk9g7t5OUhG2"
    
    /// Firebase reference
    var ref: DatabaseReference!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    func testThatAdditionToDatabase() {
        createViewInFirebase()
        XCTAssertGreaterThan(allViews().count, 0)
        XCTAssertEqual(0, 1)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func createViewInFirebase() {
        // Firebase path
        ref = Database.database().reference().child("users/\(uid)/views").childByAutoId()
        
        // Creating a View Object
        let newView = Views(name: "Running a test", totalAmount: 0, categories: [], id: "")
        print(newView.getDictionary())
        
        // Saving data to firebase.
        self.ref.setValue(newView.getDictionary())
    }
    
    func allViews() -> [Views] {
        var allViews:[Views] = []
        ref = Database.database().reference().child("users/\(uid)/views")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: [String:Any]] else {
                // TODO: Handle error
                print("snapshot: ",snapshot.value)
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
            allViews = newViews
        }) { (error) in
            print(error.localizedDescription)
        }
        return allViews
    }

}

struct Views {
    var name: String
    var totalAmount: Double
    var categories: [Category]
    var id: String
    var categoriesId:[String]
    
    init(name:String, totalAmount: Double = 0, categories:[Category] = [], id: String = "", categoriesId:[String] = []) {
        self.name = name
        self.totalAmount = totalAmount
        self.categories = categories
        self.id = id
        self.categoriesId = categoriesId
    }
    
    func getDictionary() -> [String:Any] {
        return [
            "name": name,
            "totalAmount": 0,
            "categoriesId": categoriesId
        ]
    }
}
