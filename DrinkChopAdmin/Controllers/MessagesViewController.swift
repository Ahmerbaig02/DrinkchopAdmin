//
//  MessagesViewController.swift
//  Momentum
//
//  Created by Mac on 29/03/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    
    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    
    @IBOutlet var messagesTable:UITableView!
    
    var notificationData:[String:Any]!
    
    var title_color:UIColor = appTintColor
    var readTintColor:UIColor = UIColor(red: 28/255, green: 144/255, blue: 91/255, alpha: 1.0)

    var selectedContact:DrinkUser!
    
    fileprivate var uniqueRecipents:[String] = []
    var users:[[DrinkMessage]] = []
    var allMessages:[DrinkMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //saveMessageDataInDB()
        
        registerCell()
        
        if DrinkUser.iUser.userType != "0" {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performDidApearThings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessageDetailsVC {
            let index = sender as! Int
            print("index: ",index)
            controller.recipentEmail = self.uniqueRecipents[index]
            controller.allMessages = self.allMessages
            if index >= 0 && self.users.count > 0 {
                controller.messages = self.users[index]
            }
        }
    }
    
    func performDidApearThings() {
        if self.selectedContact != nil {
            print(self.selectedContact.userName!)
            if self.uniqueRecipents.contains(where: {$0 == self.selectedContact.userEmail}) {
                let index = self.uniqueRecipents.index(where: {$0 == self.selectedContact.userEmail})!
                self.performSegue(withIdentifier: MessageDetailsSegueID, sender: index)
            } else {
                self.uniqueRecipents.append(self.selectedContact.userEmail!)
                self.performSegue(withIdentifier: MessageDetailsSegueID, sender: self.uniqueRecipents.count-1)
            }
            self.selectedContact = nil
        }
        getMessagesData()
        
        if notificationData != nil {
            var messageData:DrinkMessage!
            if (notificationData["choice"] as! String) == "Doctor" {
                messageData = parseDoctorMessage(data: notificationData)
            } else {
                messageData = parsePatientMessage(data: notificationData)
            }
            self.allMessages.append(messageData)
            self.saveMessageDataInDB()
            if self.uniqueRecipents.contains(where: {$0 == messageData.email || $0 == messageData.recipentEmail}) {
                let index = self.uniqueRecipents.index(where: {$0 == messageData.email || $0 == messageData.recipentEmail})!
                self.performSegue(withIdentifier: MessageDetailsSegueID, sender: index)
            } else {
                self.uniqueRecipents.append(messageData.recipentEmail!)
                self.performSegue(withIdentifier: MessageDetailsSegueID, sender: self.uniqueRecipents.count-1)
            }
            self.notificationData = nil
        }
    }
    
    
    func saveMessageDataInDB() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self.allMessages) else {return}
        
        UserDefaults.standard.set(data, forKey: messagesDefaultID)
    }
    
    func parseDoctorMessage(data: [String:Any]) -> DrinkMessage {
        var newMessage = DrinkMessage()
        newMessage.email = DrinkUser.iUser.userEmail!
        newMessage.name = DrinkUser.iUser.userName!
        newMessage.recipentEmail = data["d_email"] as? String ?? ""
        newMessage.recipentName = data["d_name"] as? String ?? ""
        newMessage.message = data["body"] as? String ?? ""
        newMessage.title = data["title"] as? String ?? ""
        newMessage.recipentImage = data["d_image"] as? String ?? ""
        newMessage.date = data["date"] as? String ?? ""
        return newMessage
    }
    
    func parsePatientMessage(data: [String:Any]) -> DrinkMessage {
        var newMessage = DrinkMessage()
        newMessage.email = DrinkUser.iUser.userEmail!
        newMessage.name = DrinkUser.iUser.userName!
        newMessage.recipentEmail = data["p_email"] as? String ?? ""
        newMessage.recipentName = data["p_name"] as? String ?? ""
        newMessage.message = data["body"] as? String ?? ""
        newMessage.title = data["title"] as? String ?? ""
        newMessage.recipentImage = data["p_image"] as? String ?? ""
        newMessage.date = data["date"] as? String ?? ""
        return newMessage
    }
    
    func getMessagesData() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data  = UserDefaults.standard.data(forKey: messagesDefaultID) else {return}
        guard let messages = try? decoder.decode([DrinkMessage].self, from: data) else {return}
        
        self.allMessages = messages
        
        uniqueRecipents = Array(Set(self.allMessages.map({$0.recipentEmail!})))
        uniqueRecipents = uniqueRecipents.filter({$0 != ""})
        self.users.removeAll(keepingCapacity: false)
        for recp in uniqueRecipents {
            let recipentMessages = allMessages.filter({ $0.recipentEmail == recp || $0.email == recp })
            self.users.append(recipentMessages)
        }
        self.messagesTable.reloadData()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
        
        let messageNib = UINib(nibName: "MessageCell", bundle: nil)
        messagesTable.register(messageNib, forCellReuseIdentifier: messageCellID)
    }
    
    func timeAttributedTextWithImageAttachment(timeText: String) -> NSAttributedString {
        let attr_String = NSMutableAttributedString(attributedString: getAttributedText(Titles: [timeText], Font: [.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)], Colors: [title_color], seperator: [""], Spacing: 0, atIndex: -1))
        
        let locationIconAttachment = NSTextAttachment()
        locationIconAttachment.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        locationIconAttachment.bounds = CGRect(x: 0, y: -4, width: 18, height: 18)
        
        attr_String.append(NSAttributedString(attachment: locationIconAttachment))
        
        return attr_String
    }
    
    @IBAction func showSearchViewAction(_ sender: Any) {
        
    }
    
    deinit {
        print("messages view deinit")
    }
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellID, for: indexPath) as! MessageCell
        cell.MessageLabel.attributedText = getAttributedText(Titles: [users[indexPath.row][0].name! ,users[indexPath.row][0].message!], Font: [.boldSystemFont(ofSize: 14.0),.systemFont(ofSize: 11.0, weight: UIFont.Weight.medium)], Colors: [title_color,.gray], seperator: ["\n",""], Spacing: 0, atIndex: -1)
        cell.timeLabel.attributedText = timeAttributedTextWithImageAttachment(timeText: users[indexPath.row][0].date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            messagesTable.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messagesTable.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: MessageDetailsSegueID, sender: indexPath.row)
    }
    
}


extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
