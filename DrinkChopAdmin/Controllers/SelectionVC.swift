////
//  SelectionVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class SelectionVC: UIViewController {

    @IBOutlet var selectionTableView: UITableView!
    @IBOutlet var saveDrinksBtn: UIButton!
    @IBOutlet var newDrinkBtn: UIButton!
    
    weak var parentController: BaseLineSelectionVC?
    
    var selectedDrinksData:[Drink] = []
    var drinksData:[[Drink]] = []
    var drinksTypes:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newDrinkBtn.titleLabel?.numberOfLines = 0
        self.saveDrinksBtn.titleLabel?.numberOfLines = 0
        self.saveDrinksBtn.titleLabel?.textAlignment = .center
        
        registerCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NewDrinkVC {
            let VC = self.parentController?.baselineSelectionControllers[0] as! BaselineVC
            controller.drinksTypes = VC.drinksTypes
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectionTableView.reloadData()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "DrinkTVC", bundle: nil)
        self.selectionTableView.register(cellNib, forCellReuseIdentifier: drinkCellID)
    }
    
    func insertDrinksFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self.selectedDrinksData) else {return}
        guard let jsonStr = String(data: data, encoding: .utf8) else {return}
        Manager.insertDrinksOnServer(json: jsonStr) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                if success {
                    self!.showToast(message: "drinks Saved")
                    print("drinksDataSaved \(success)")
                    self!.selectedDrinksData.removeAll(keepingCapacity: false)
                    self!.drinksData.removeAll(keepingCapacity: false)
                    self?.selectionTableView.reloadData()
                } else {
                    self!.showToast(message: "error inserting saving drinks data\t already added to inventory")
                }
            } else {
                self!.showToast(message: "error inserting drinks...")
                print("error inserting saving drinks data\t already added to inventory")
            }
        }
    }
    
    @IBAction func newDrinkAction(_ sender: Any) {
        self.performSegue(withIdentifier: newDrinkSegueID, sender: nil)
    }
    
    @IBAction func saveDrinksAction(_ sender: Any) {
        insertDrinksFromManager()
    }
    
    
    deinit {
        print("selection vc deinit")
    }

}

extension SelectionVC: DrinkTVCDelegate {
    
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

extension SelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.drinksTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinksData[section].count
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
        return self.drinksTypes[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeaderSize(Width: tableView.frame.width, aspectRatio: 280/30, padding: 0).height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectionTableView.deselectRow(at: indexPath, animated: false)
    }
    
}
