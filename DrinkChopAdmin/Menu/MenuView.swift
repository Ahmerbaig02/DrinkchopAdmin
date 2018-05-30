//
//  MenuView.swift
//  ParkVit
//
//  Created by Mac on 07/12/2016.
//
//

import UIKit

var ID = ""
class MenuView: UIViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var menuTable:UITableView!
    
    var MyAccountDetails:[String:Any]!
    
    var titles:[String] = []
    let adminTitles:[String] = ["Statistics","Templates", "Add Employee","Add Event","Add Happy Hour","Messages","Baseline/Selection", "Social Sites","Sign out"]
    let bartenderTitles:[String] = ["Messages","Orders", "Sign out"]
    let doormanTitles:[String] = ["Messages", "Covers","Sign out"]
    
    let textAligments:[NSTextAlignment] = [.left,.left,.left,.left,.left,.left,.left,.left,.left,.left,.left]
    
    let fontStyles:[UIFont] = [.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium)]
    
    let menuImages:[UIImage?] = [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
    let BGColors:[UIColor] = [.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.estimatedRowHeight = 54.0
        
        if DrinkUser.iUser.userType == "0" {
            self.titles = adminTitles
        } else if DrinkUser.iUser.userType == "1" {
            self.titles = doormanTitles
        } else if DrinkUser.iUser.userType == "2" {
            self.titles = bartenderTitles
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.Name.text = DrinkUser.iUser.userName ?? ""
        self.userImage.pin_setImage(from: URL(string: DrinkUser.iUser.userImage ?? ""))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.userImage.getRounded(cornerRaius: self.userImage.frame.width/2)
    }
    
    func doLogout() {
        UserDefaults.standard.set(false, forKey: isLoggedInDefaultID)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showLogoutAlert() {
        let confirm = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "Sign out", style: .default, handler: { [weak self] (action) in
            self!.doLogout()
        }))
        
        confirm.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(confirm, animated: true, completion: nil)
    }
    
    func closeMenu() {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }
    
    deinit {
        print("Menu View deinit")
    }
    
}

extension MenuView: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if titles[indexPath.row] == "" {
            return 1
        }
        
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 240/54, padding: 0).height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = fontStyles[indexPath.row]
        cell.textLabel?.textAlignment = textAligments[indexPath.row]
        cell.backgroundColor = BGColors[indexPath.row]
        cell.imageView?.tintColor = .gray
        cell.imageView?.image = menuImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if titles[indexPath.row] == "Sign out" {
            self.showLogoutAlert()
        } else if titles[indexPath.row] == "Add Event" {
            ID = "addEventHour,1"
            closeMenu()
        } else if titles[indexPath.row] == "Add Happy Hour" {
            ID = "addEventHour,0"
            closeMenu()
        } else {
            ID = (titles[indexPath.row] == "") ? "" : titles[indexPath.row]
            closeMenu()
        }
    }
    
}
