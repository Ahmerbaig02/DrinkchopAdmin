////
//  StatsVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class StatsVC: UIViewController {

    @IBOutlet var coverView: UIView!
    @IBOutlet var coverNameLbl: UILabel!
    @IBOutlet var roomCapLbl: UILabel!
    @IBOutlet var priceTillNowLbl: UILabel!
    @IBOutlet var exemptLbl: UILabel!
    @IBOutlet var closingTimeLbl: UILabel!
    @IBOutlet var exemptBtn: UIButton!
    @IBOutlet var nonExemptBtn: UIButton!
    
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    @IBOutlet var durationSegmentCtrl:UISegmentedControl!
    @IBOutlet var employeesSegmentCtrl:UISegmentedControl!
    @IBOutlet var statTypeSegmentCtrl:UISegmentedControl!
    
    var employees:[String] = ["Ahmer", "Ali", "Safeer", "Ahmed", "Khurram", "Bilawal", "John Doe", "John Smith","Ahmer", "Ali", "Safeer", "Ahmed", "Khurram", "Bilawal", "John Doe", "John Smith"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for emp in employees {
            self.employeesSegmentCtrl.insertSegment(withTitle: emp, at: 0, animated: true)
        }
        registerCell()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
    }
    
    func showHideCoverView(show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show == true {
                self.coverView.alpha = 1
            } else {
                self.coverView.alpha = 0
            }
        }
    }
    
    //MARK: - cover actions
    @IBAction func exemptAction(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
            btn.tintColor = appTintColor
            btn.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        } else {
            btn.tintColor = .darkGray
            btn.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank"), for: .normal)
        }
    }
    
    @IBAction func nonExemptAction(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
            btn.tintColor = appTintColor
            btn.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        } else {
            btn.tintColor = .darkGray
            btn.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank"), for: .normal)
        }
    }
    
    
    @IBAction func tipsAction(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
            btn.tintColor = appTintColor
            btn.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        } else {
            btn.tintColor = .darkGray
            btn.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank"), for: .normal)
        }
    }
    
    @IBAction func cardsAction(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
            btn.tintColor = appTintColor
            btn.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        } else {
            btn.tintColor = .darkGray
            btn.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank"), for: .normal)
        }
    }
    
    @IBAction func cashAction(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
            btn.tintColor = appTintColor
            btn.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        } else {
            btn.tintColor = .darkGray
            btn.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank"), for: .normal)
        }
    }

    @IBAction func salesAction(_ sender: Any) {
        self.showHideCoverView(show: self.statTypeSegmentCtrl.selectedSegmentIndex == 1)
    }
    
    @IBAction func employeeAction(_ sender: Any) {
        
    }
    
    @IBAction func durationAction(_ sender: Any) {
        
    }
    
    deinit {
        print("stats vc deinit")
    }
}

extension StatsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
