////
//  EmployeeVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class EmployeeVC: UIViewController {

    @IBOutlet var roomCapacityTF: UITextField!
    @IBOutlet var closingTimeTF: UITextField!
    @IBOutlet var coverTF: UITextField!
    @IBOutlet var exemptLbl: UILabel!
    @IBOutlet var categoryTypeTF: UITextField!
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        registerCell()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.roomCapacityTF.getRounded(cornerRaius: 5)
        self.closingTimeTF.getRounded(cornerRaius: 5)
        self.coverTF.getRounded(cornerRaius: 5)
        self.categoryTypeTF.getRounded(cornerRaius: 5)
        
        roomCapacityTF.layer.borderColor = appTintColor.cgColor
        closingTimeTF.layer.borderColor = appTintColor.cgColor
        coverTF.layer.borderColor = appTintColor.cgColor
        categoryTypeTF.layer.borderColor = appTintColor.cgColor
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
    }
   
    deinit {
        print("deinit employeeVC")
    }

}


extension EmployeeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleDoorCellID, for: indexPath) as! PeopleDoorCVC
        if indexPath.row%2 == 0 {
            cell.infoLbl.textColor = appTintColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: collectionView.frame.width/3, aspectRatio: 86/44, padding: 20)
    }
}
