//
//  ServingVC.swift
//  DrinkChopAdmin
//
//  Created by Mahnoor Fatima on 4/25/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class ServingVC: UIViewController {

    @IBOutlet var itemsTableView: UITableView!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var totalDueLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var tipsLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var servedBtn: UIButton!
    @IBOutlet weak var servingInfoView: UIView!
    
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    
    var drinksData:[Drink] = []
    var orderData: DrinkOrder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setDataInViews()
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.servingInfoView.getRounded(cornerRaius: 5)
        self.servingInfoView.giveShadow(cornerRaius: 5)
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
        
    }
    
    func setDataInViews() {
        self.taxLbl.text = "Tax: $\(self.orderData.taxAmount ?? "0")"
        self.tipsLbl.text = "Tips: $\(self.orderData.tips ?? "0")"
        self.totalLbl.text = "Total: $\(self.orderData.totalPrice ?? "0")"
        if self.orderData.payment == "Paid" {
            self.totalDueLbl.text = "Paid"
        } else { 
            self.totalDueLbl.text = "Total Due: $\(self.orderData.totalPrice ?? "0")"
        }
        self.orderNameLbl.text = self.orderData.userName ?? ""
        let orderTax = (orderData.taxAmount as NSString?)!.integerValue
        let orderTips = (orderData.tips as NSString?)!.integerValue
        let totalAmount = (orderData.totalPrice as NSString?)!.integerValue
        self.orderLbl.text = "Order: $\(totalAmount - (orderTax+orderTips))"
    }
    
    
    func acceptOrderFromManager(status: String) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.acceptOrderOnServer(userId: self.orderData.userId!, order_id: self.orderData.orderId!, bartender_id: self.orderData.barTenderId!, status: status) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                if status == "1" {
                    self!.showToast(message: "Order accepted")
                    self!.servedBtn.setTitle("Served", for: .normal)
                } else {
                    self!.showToast(message: "Order served")
                    _ = self!.navigationController?.popViewController(animated: true)
                }
            } else {
                self!.showToast(message: "error accepting order")
                print("error accepting order")
            }
        }
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
    }
    
    @IBAction func serveAction(_ sender: Any) {
        self.acceptOrderFromManager(status: (self.servedBtn.currentTitle == "Served") ? "2" : "1")
    }
    
    deinit {
        print("deinit ServingVC")
    }

}

extension ServingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "servingCell", for: indexPath)
        let drinkData = drinksData[indexPath.row]
        cell.textLabel?.text = drinkData.drinkName ?? ""
        let drinkCost = (drinkData.drinkCost as NSString?)!.integerValue
        let drinkQuantity = (drinkData.quantity as NSString?)!.integerValue
        cell.detailTextLabel?.text = "$\(drinkQuantity * drinkCost)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension ServingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
