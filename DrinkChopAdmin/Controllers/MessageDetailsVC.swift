//
//  MessageDetailsVC.swift
//  Momentum
//
//  Created by Mac on 24/10/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class MessageDetailsVC: UIViewController {
    
    @IBOutlet var sendMessageBtn:UIButton!
    @IBOutlet var chatCollectionView:UICollectionView!
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var messageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewBottomConstraint: NSLayoutConstraint!
    
    fileprivate var sizingCell:ChatCVC!
    
    var recipentEmail:String!
    
    var messages:[DrinkMessage] = []
    
    var allMessages:[DrinkMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPadding()
        self.messageTextView.textColor = UIColor.lightGray
        self.messageTextView.text = "Write Message..."
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Functions
    
    func setPadding() {
        messageTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 0, right: 0)
    }
    
    func registerCells() {
        let chatCellNib = UINib(nibName: "ChatCVC", bundle: nil)
        self.chatCollectionView.register(chatCellNib, forCellWithReuseIdentifier: chatCellID)
        
        self.sizingCell = chatCellNib.instantiate(withOwner: self, options: nil).first as! ChatCVC
    }
    
    func saveMessageDataInDB() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self.allMessages) else {return}
        
        UserDefaults.standard.set(data, forKey: messagesDefaultID)
    }
    
    
    func updateMessagesData(messageTitle: String) {
        var newMessage = DrinkMessage()
        newMessage.email = DrinkUser.iUser.userEmail!
        newMessage.name = DrinkUser.iUser.userName!
        newMessage.recipentEmail = self.recipentEmail
        newMessage.recipentName = self.recipentEmail
        newMessage.message = self.messageTextView.text!
        newMessage.title = messageTitle
        newMessage.recipentImage = self.recipentEmail
        newMessage.date = Date().humanReadableDate
        self.messages.append(newMessage)
        self.allMessages.append(newMessage)
        self.saveMessageDataInDB()
        self.chatCollectionView.reloadData()
        self.messageTextView.resignFirstResponder()
        self.messageTextView.text = ""
    }
    
    func sendMessageForDoctor() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let params:[String: Any] = ["message": self.messageTextView.text!,
                                    "Patient_Email": recipentEmail,
                                    "check":1,
                                    "D_Email": DrinkUser.iUser.userName!,
                                    "D_Name": DrinkUser.iUser.userEmail!,
                                    "D_Image": DrinkUser.iUser.userImage!,
                                    "Date": Date().humanReadableDate]
        Manager.sendDocMessageFromServer(params: params) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.updateMessagesData(messageTitle: "Patient Message")
            } else {
                self!.showToast(message: "Message Sending Failed")
                print("error sending doc message")
            }
        }
    }
    
    func sendMessageForPatient() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let params:[String: Any] = ["message": self.messageTextView.text!,
                                    "Doctor_Email": recipentEmail,
                                    "check":1,
                                    "P_Email": DrinkUser.iUser.userEmail!,
                                    "P_Name": DrinkUser.iUser.userName!,
                                    "P_Image": DrinkUser.iUser.userImage!,
                                    "Date": Date().humanReadableDate]
        Manager.sendPatientMessageFromServer(params: params) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.updateMessagesData(messageTitle: "Doctor Message")
            } else {
                self!.showToast(message: "Message Sending Failed")
                print("error sending doc message")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func messageSendAction(_ sender: Any) {
        self.sendMessageBtn.isEnabled = false
        if DrinkUser.iUser.userType != "0" {
            sendMessageForPatient()
        } else {
            sendMessageForDoctor()
        }
    }
    
    deinit {
        print("messages details deinit")
    }
}

extension MessageDetailsVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.messageTextView.text == "Write Message..." {
            self.messageTextView.text = ""
            self.messageTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.messageTextView.text == "" {
            self.messageTextView.textColor = UIColor.lightGray
            self.messageTextView.text = "Write Message..."
        } else {
            self.messageTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            sendMessageBtn.isEnabled = true
        } else {
            sendMessageBtn.isEnabled = false
        }
        if self.messageViewHeightConstraint.constant < self.messageTextView.contentSize.height {
            self.messageViewHeightConstraint.constant = -(self.messageTextView.contentSize.height + 20)
        } else {
            self.messageViewHeightConstraint.constant = 0.0
        }
    }
}

extension MessageDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func configureChatCell(cell: ChatCVC, index: Int) {
        let currentChatMessage = self.messages[index].message!
        let cellChatSize = currentChatMessage.heightWithConstrainedWidth(width: 250, font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.medium))
        cell.chatMessageLabel.textColor = UIColor.white
        cell.chatMessageLabel.text = currentChatMessage
        if self.messages[index].email != DrinkUser.iUser.userEmail {
            cell.chatMessageLabel.frame = CGRect(x: 16, y: 0, width: cellChatSize.width+16, height: cellChatSize.height+20)
            cell.chatBGView.frame = CGRect(x: 8, y: 0, width: cellChatSize.width+24, height: cellChatSize.height+20)
            cell.dateTimeLbl.textAlignment = .right
            cell.dateTimeLbl.frame = CGRect(x: 0, y: cellChatSize.height+24, width: 150, height: 20)
            cell.chatBGView.backgroundColor = UIColor.lightGray
        } else {
            cell.chatMessageLabel.frame = CGRect(x: view.frame.width - cellChatSize.width - 32, y: 0, width: cellChatSize.width+16, height: cellChatSize.height+16)
            cell.chatBGView.frame = CGRect(x: view.frame.width - cellChatSize.width - 40, y: 0, width: cellChatSize.width+24, height: cellChatSize.height+16)
            cell.dateTimeLbl.frame = CGRect(x: view.frame.width - 160, y: cellChatSize.height+20, width: 150, height: 20)
            cell.dateTimeLbl.textAlignment = .right
            cell.chatBGView.backgroundColor = appTintColor
        }
        cell.dateTimeLbl.text = self.messages[index].date!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellID, for: indexPath) as! ChatCVC
        configureChatCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = 250.0
        let currentChatMessage = self.messages[indexPath.row].message!
        let cellChatSize = currentChatMessage.heightWithConstrainedWidth(width: cellWidth, font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.medium))
        return CGSize(width: self.view.frame.width, height: cellChatSize.height + 40)
    }
}
