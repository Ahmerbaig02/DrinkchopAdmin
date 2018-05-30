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
    
    
    @IBOutlet var totalLbl: UILabel!
    @IBOutlet var tipsBtn: UIButton!
    @IBOutlet var cardBtn: UIButton!
    @IBOutlet var cashBtn: UIButton!
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    @IBOutlet var durationSegmentCtrl:UISegmentedControl!
    @IBOutlet var employeesSegmentCtrl:UISegmentedControl!
    @IBOutlet var statTypeSegmentCtrl:UISegmentedControl!
    
    
    var bartendersData:[BartenderUser] = []
    var entryUsers: [EntryUser] = []
    var bartenderTotals: [BarTenderTotals] = []
    var entriesTotals: [EntryTotals] = []
    var barsData: [DrinkBar] = []
    var bartenderUsers: [DrinkUser] = []
    var doormanUsers: [DrinkUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.employeesSegmentCtrl.removeAllSegments()
        
        self.coverView.alpha = 0
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
        
        self.setNoDataView()
        
        self.getSalesFromManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNoDataView()
        NotificationsUtil.removeFromSuperView()
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
                for emp in self.doormanUsers.reversed() {
                    self.employeesSegmentCtrl.insertSegment(withTitle: emp.userName ?? "", at: 0, animated: true)
                }
            } else {
                for emp in self.bartendersData.reversed() {
                    self.employeesSegmentCtrl.insertSegment(withTitle: emp.userName ?? "", at: 0, animated: true)
                }
                self.coverView.alpha = 0
            }
        }
    }
    
    func setAmountDataInView(index: Int) {
        let dateStr = self.bartendersData[index].orderTime?.replacingOccurrences(of: " ", with: "T").appending(".796Z").dateFromISO8601?.humanReadableDatewoTime ?? ""
        let weekEnd = Date().endOfWeek?.humanReadableDatewoTime ?? ""
        let weekStart = Date().startOfWeek?.humanReadableDatewoTime ?? ""
        let currentDay = Date().humanReadableDatewoTime
        
        let calender = Calendar.current
        let components = calender.dateComponents([.month, .year], from: Date())
        let startOfMonth = calender.date(from: components)?.humanReadableDatewoTime ?? ""
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calender.date(byAdding: comps2, to: calender.date(from: components)!)?.humanReadableDatewoTime ?? ""
        
        print(startOfMonth)
        print(endOfMonth)
        
        let isCurrentDay = dateStr == currentDay
        let isCurrentWeek = (dateStr >= weekStart && dateStr <= weekEnd)
        let isCurrentMonth = (dateStr >= startOfMonth && dateStr <= endOfMonth)
        
        if durationSegmentCtrl.selectedSegmentIndex == 0 {
            // days
            var amount = (self.bartendersData[index].totalPrice as NSString?)!.doubleValue
            if isCurrentDay {
                if self.tipsBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    amount-=(self.bartendersData[index].tips as NSString?)!.doubleValue
                }
                if self.cashBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    if self.bartendersData[index].payment != "Paid_Card" {
                        amount = 0
                    }
                }
                if self.cardBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    if self.bartendersData[index].payment == "Paid_Card" {
                        amount = 0
                    }
                }
            } else {
                amount = 0.0
            }
            self.totalLbl.text = "Total:\t$\(amount.getRounded(uptoPlaces: 2))"
        } else if durationSegmentCtrl.selectedSegmentIndex == 1 {
            // weeks
            var amount = (self.bartendersData[index].totalPrice as NSString?)!.doubleValue
            if isCurrentWeek {
                if self.tipsBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    amount-=(self.bartendersData[index].tips as NSString?)!.doubleValue
                }
                if self.cashBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    if self.bartendersData[index].payment != "Paid_Card" {
                        amount = 0
                    }
                }
                if self.cardBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    if self.bartendersData[index].payment == "Paid_Card" {
                        amount = 0
                    }
                }
            } else {
                amount = 0.0
            }
            self.totalLbl.text = "Total:\t$\(amount.getRounded(uptoPlaces: 2))"
        } else {
            //months
            var amount = (self.bartendersData[index].totalPrice as NSString?)!.doubleValue
            if isCurrentMonth {
                if self.tipsBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    amount-=(self.bartendersData[index].tips as NSString?)!.doubleValue
                }
                if self.cashBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    if self.bartendersData[index].payment != "Paid_Card" {
                        amount = 0
                    }
                }
                if self.cardBtn.currentImage == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                    if self.bartendersData[index].payment == "Paid_Card" {
                        amount = 0
                    }
                }
            } else {
                amount = 0.0
            }
            self.totalLbl.text = "Total:\t$\(amount.getRounded(uptoPlaces: 2))"
        }
    }
    
    func getSalesFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getSalesFromServer(barId: DrinkUser.iUser.barId!) { [weak self] (bartenderUsers, entryUsers, bartenderTotals, entriesTotals, barsData, usersData) in
            Manager.hideLoader()
            if let barUsers = bartenderUsers, let enUsers = entryUsers, let barTotals = bartenderTotals, let enTotals = entriesTotals, let bData = barsData, let uData = usersData {
                
                self!.bartenderTotals = barTotals
                self!.doormanUsers = uData.filter({ $0.userType == "1" })
                self!.entryUsers = enUsers
                self!.bartendersData = barUsers
                self!.bartenderUsers = uData.filter({ $0.userType == "2" })
                self!.entriesTotals = enTotals
                self!.barsData = bData
                self!.hideNoDataView()
                
                self!.setDataInViews()
            } else {
                self!.showDataView(text: "No Sales Data..")
                self!.showToast(message: "No Sales Found..")
                print("error")
                //error
            }
        }
    }
    
    func setDataInViews() {
        self.coverNameLbl.text = "Doorman: \(self.doormanUsers[0].userName ?? "")"
        self.priceTillNowLbl.text = "Uptil now: $\(self.barsData[0].totalAmount ?? "")(\(self.barsData[0].peopleInRoom ?? ""))"
        roomCapLbl.attributedText = getAttributedText(Titles: ["Room Ocupancy","\(self.barsData[0].peopleInRoom ?? "")/\(self.barsData[0].totalRoomOccupancy ?? "")"], Font: [UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold), UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)], Colors: [UIColor.darkGray, UIColor(red: 253/255, green: 142/255, blue: 63/255, alpha: 1)], seperator: ["\n",""], Spacing: 3, atIndex: 0)
        
        self.employeesSegmentCtrl.removeAllSegments()
        for emp in self.bartendersData.reversed() {
            self.employeesSegmentCtrl.insertSegment(withTitle: emp.userName ?? "", at: 0, animated: true)
        }
        if self.bartendersData.count > 0 {
            self.employeesSegmentCtrl.setEnabled(true, forSegmentAt: 0)
            self.employeesSegmentCtrl.selectedSegmentIndex = 0
            self.setAmountDataInView(index: 0)
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
        setAmountDataInView(index: self.employeesSegmentCtrl.selectedSegmentIndex)
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
        setAmountDataInView(index: self.employeesSegmentCtrl.selectedSegmentIndex)
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
        setAmountDataInView(index: self.employeesSegmentCtrl.selectedSegmentIndex)
    }
    
    @IBAction func salesAction(_ sender: Any) {
        self.employeesSegmentCtrl.removeAllSegments()
        self.showHideCoverView(show: self.statTypeSegmentCtrl.selectedSegmentIndex == 1)
    }
    
    @IBAction func employeeAction(_ sender: Any) {
        if self.statTypeSegmentCtrl.selectedSegmentIndex == 1 {
            self.coverNameLbl.text = "Doorman: \(self.doormanUsers[self.employeesSegmentCtrl.selectedSegmentIndex].userName ?? "")"
        } else {
            setAmountDataInView(index: self.employeesSegmentCtrl.selectedSegmentIndex)
        }
    }
    
    @IBAction func durationAction(_ sender: Any) {
        self.setAmountDataInView(index: self.employeesSegmentCtrl.selectedSegmentIndex)
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
