////
//  NewMessageVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class NewMessageVC: UIViewController {

    @IBOutlet var contactsTableView:UITableView!

    var users:[DrinkUser] = []
    
    var title_color:UIColor = appTintColor
    var readTintColor:UIColor = UIColor(red: 28/255, green: 144/255, blue: 91/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        getAdminUsersFromManager()
    }
    
    func registerCell() {
        let messageNib = UINib(nibName: "MessageCell", bundle: nil)
        contactsTableView.register(messageNib, forCellReuseIdentifier: messageCellID)
    }
    
    func getAdminUsersFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getAdminUsersFromServer(barId: DrinkUser.iUser.barId!) { [weak self] (usersData) in
            Manager.hideLoader()
            if let usersData = usersData {
                self!.users.removeAll(keepingCapacity: false)
                self!.users = usersData
                self!.contactsTableView.reloadData()
            } else {
                //error
                print("error fetching admin users")
            }
        }
    }
    
    
    deinit {
        print("new message vc deinit")
    }
}

extension NewMessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID, for: indexPath) as! MessageCell
        cell.MessageLabel.attributedText = getAttributedText(Titles: [users[indexPath.row].userName!,users[indexPath.row].userPhone!], Font: [.boldSystemFont(ofSize: 15.0),.systemFont(ofSize: 11.5, weight: UIFont.Weight.medium)], Colors: [title_color,.gray], seperator: ["\n",""], Spacing: 0, atIndex: -1)
        cell.senderImageView.getRounded(cornerRaius: cell.senderImageView.frame.width/2)
        cell.senderImageView.pin_setImage(from: URL(string: self.users[indexPath.row].userImage ?? ""))
        cell.timeLabel.text =  ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            contactsTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactsTableView.deselectRow(at: indexPath, animated: false)
        guard let index = self.navigationController?.viewControllers.count else {return}
        guard let controller = self.navigationController?.viewControllers[index-2] as? MessagesViewController else {return}
        controller.selectedContact = self.users[indexPath.row]
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
