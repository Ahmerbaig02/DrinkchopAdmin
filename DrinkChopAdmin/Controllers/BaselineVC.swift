////
//  BaselineVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class BaselineVC: UIViewController {

    @IBOutlet var baselineTableView: UITableView!
    
    var selectedDrinksData:[Drink] = []
    var drinksData:[[Drink]] = []
    var drinksTypes:[String] = []
    
    weak var parentController: BaseLineSelectionVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BourbonVC {
            let indexPath = sender as! IndexPath
            controller.selectedDrinkData = self.drinksData[indexPath.section][indexPath.item]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDrinksDataFromManager()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "DrinkTVC", bundle: nil)
        self.baselineTableView.register(cellNib, forCellReuseIdentifier: drinkCellID)
    }
    
    func getDrinksDataFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getDrinksFromServer(id: (DrinkUser.iUser.barId as NSString?)!.integerValue) { [weak self] (drinksData, drinkTypes) in
            Manager.hideLoader()
            if let drinks = drinksData, let types = drinkTypes {
                self!.drinksTypes = types
                var newDrinks:[[Drink]] = []
                for type in types {
                    newDrinks.append(drinks.filter({ $0.drinkType == type }))
                }
                self!.drinksData = newDrinks
                self!.baselineTableView.reloadData()
            } else {
                self!.showToast(message: "Error Fetching Drinks. Please trya again...")
                //err
            }
        }
    }
    
    
    @IBAction func sendSelectionAction(_ sender: Any) {
        guard let controllers = self.parentController?.baselineSelectionControllers else {return}
        let selectionController = controllers[1] as! SelectionVC
        selectionController.selectedDrinksData = self.selectedDrinksData
        selectionController.drinksData = self.drinksData
        selectionController.drinksTypes = self.drinksTypes
    }
    
    deinit {
        print("baseline vc deinit")
    }
}

extension BaselineVC: DrinkTVCDelegate {
    
    func selectItem(cell: DrinkTVC, indexPath: IndexPath) {
        if cell.selectionImgView.image == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
            cell.selectionImgView.tintColor = appTintColor
            cell.selectionImgView.image = #imageLiteral(resourceName: "ic_check_box")
            let item = self.drinksData[indexPath.section][indexPath.row]
            self.selectedDrinksData.append(item)
        } else {
            cell.selectionImgView.tintColor = .darkGray
            cell.selectionImgView.image = #imageLiteral(resourceName: "ic_check_box_outline_blank")
            let item = self.drinksData[indexPath.section][indexPath.row]
            let RIndex = self.self.selectedDrinksData.index(where: { $0.drinkId == item.drinkId})
            self.selectedDrinksData.remove(at: RIndex!)
        }
    }
}

extension BaselineVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drinksTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: drinkCellID, for: indexPath) as! DrinkTVC
        let selectedDrink = self.drinksData[indexPath.section][indexPath.row]
        cell.titleLbl.text = selectedDrink.drinkName ?? ""
        cell.indexPath = indexPath
        cell.delegate = self
        
        if self.selectedDrinksData.contains(where: { $0.drinkId == selectedDrink.drinkId }) {
            cell.selectionImgView.tintColor = appTintColor
            cell.selectionImgView.image = #imageLiteral(resourceName: "ic_check_box")
        } else {
            cell.selectionImgView.tintColor = .darkGray
            cell.selectionImgView.image = #imageLiteral(resourceName: "ic_check_box_outline_blank")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinksTypes[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.baselineTableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: SelectedDrinkSegueID, sender: indexPath)
    }
}
