////
//  BartenderVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class BartenderVC: UIViewController {
    
    @IBOutlet var orderTableView:UITableView!
    
    var ordersData:[DrinkOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ServingVC {
            let index = sender as! Int
            controller.drinksData = self.ordersData[index].items ?? []
            controller.orderData = self.ordersData[index]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
        getMyOrdersFromManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    
    func registerCell() {
        let cellNib = UINib(nibName: "OrdersTVC", bundle: nil)
        self.orderTableView.register(cellNib, forCellReuseIdentifier: OrderCellID)
    }
    
    func getMyOrdersFromManager() {
        Manager.showLoader(text: "Please Wait....", view: self.view)
        let id = DrinkUser.iUser.userId ?? ""
        Manager.getOrdersFromServer(id: id) { [weak self] (ordersData) in
            Manager.hideLoader()
            if let orders =  ordersData {
                self!.ordersData = orders
                self!.showToast(message: "Order fetched")
            } else {
                self!.ordersData = []
                self!.showToast(message: "unable to fetch orders. Please try again...")
                //err
            }
            self!.orderTableView.reloadData()
        }
    }
    
    deinit {
        print("my order vc deinit")
    }
}

extension BartenderVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersData.count
    }
    
    func configureCell(cell: OrdersTVC, index: Int) {
        let selectedOrder = self.ordersData[index]
        cell.infoLbl.attributedText = getAttributedText(Titles: [selectedOrder.userName ?? "",selectedOrder.orderTime?.components(separatedBy: " ")[0] ?? ""], Font: [UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.medium)], Colors: [UIColor.darkGray, UIColor.lightGray], seperator: ["\n","\n"], Spacing: 0, atIndex: -1)
        cell.drinkLbl.text = selectedOrder.drinkName ?? ""
        cell.priceLbl.text = "$\(selectedOrder.totalPrice ?? "0")"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCellID, for: indexPath) as! OrdersTVC
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.orderTableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: ServingSegueID, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        //return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300/35, padding: 20).height
    }
}
