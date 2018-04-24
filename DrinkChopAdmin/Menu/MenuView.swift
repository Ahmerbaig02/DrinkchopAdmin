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
    
    let titles:[String] = ["Statistics","Templates","Employee","Doorman","Messages","Baseline/Selection"]
    
    
    let textAligments:[NSTextAlignment] = [.left,.left,.left,.left,.left,.left,.left,.left,.left,.left,.left]
    
    let fontStyles:[UIFont] = [.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium),.systemFont(ofSize: 15, weight: UIFont.Weight.medium)]
    
    let menuImages:[UIImage?] = [#imageLiteral(resourceName: "ic_credit_card"),#imageLiteral(resourceName: "ic_work"),#imageLiteral(resourceName: "ic_notification"),#imageLiteral(resourceName: "ic_settings"),#imageLiteral(resourceName: "ic_info_outline_white"),#imageLiteral(resourceName: "ic_phone"),#imageLiteral(resourceName: "ic_favorite"),#imageLiteral(resourceName: "ic_about"),#imageLiteral(resourceName: "ic_search"),#imageLiteral(resourceName: "ic_shopping_cart"),nil]
    let BGColors:[UIColor] = [.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear,.clear]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.estimatedRowHeight = 54.0
        Name.text = "Ahmer Baig"
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.userImage.getRounded(cornerRaius: self.userImage.frame.width/2)
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
        
        ID = (titles[indexPath.row] == "") ? "" : titles[indexPath.row]
        closeMenu()
    }
    
}
