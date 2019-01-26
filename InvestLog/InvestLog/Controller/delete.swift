////
////  SixthChallengeVC.swift
////  FinalAssessment
////
////  Created by Adriana González Martínez on 12/5/18.
////  Copyright © 2018 Adriana González Martínez. All rights reserved.
////
//import UIKit
//class SixthChallengeVC: UIViewController {
//    var items = [Item]()
//    var collectionView: UICollectionView!
//    let flowLayout = UICollectionViewFlowLayout()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        for i in 1...25{
//            items.append(Item(number: i, image: UIImage(named: "Present")!))
//        }
//        
//        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
//        collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "cellId")
//        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        self.view.addSubview(collectionView)
//        
//        
//        
//        
//        
//    }
//    
//}
//struct Item {
//    var number: Int
//    var image: UIImage
//    
//    init(number: Int, image:UIImage) {
//        self.number = number
//        self.image = image
//    }
//}
//
//extension SixthChallengeVC: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ItemCell
//        cell.imageView.image = items[indexPath.row].image
//        cell.label.text = String(items[indexPath.row].number)
//        
//        return cell
//        
//    }
//    
//}
//extension SixthChallengeVC: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width/5, height: 90)
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//    
//    
//}
