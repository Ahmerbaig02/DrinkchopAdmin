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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newDrinkBtn.titleLabel?.numberOfLines = 0
        self.saveDrinksBtn.titleLabel?.numberOfLines = 0
        self.saveDrinksBtn.titleLabel?.textAlignment = .center
        
        registerCell()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "DrinkTVC", bundle: nil)
        self.selectionTableView.register(cellNib, forCellReuseIdentifier: drinkCellID)
    }
    
    @IBAction func newDrinkAction(_ sender: Any) {
        
    }
    
    @IBAction func saveDrinksAction(_ sender: Any) {
        
    }
    
    
    deinit {
        print("selection vc deinit")
    }

}

extension SelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: drinkCellID, for: indexPath) as! DrinkTVC
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Basline" : "Vodka"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeaderSize(Width: tableView.frame.width, aspectRatio: 280/30, padding: 0).height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DrinkTVC {
            self.selectionTableView.deselectRow(at: indexPath, animated: false)
            if cell.selectionImgView.image == #imageLiteral(resourceName: "ic_check_box_outline_blank") {
                cell.selectionImgView.tintColor = appTintColor
                cell.selectionImgView.image = #imageLiteral(resourceName: "ic_check_box")
            } else {
                cell.selectionImgView.tintColor = .darkGray
                cell.selectionImgView.image = #imageLiteral(resourceName: "ic_check_box_outline_blank")
            }
        }
    }
    
}
