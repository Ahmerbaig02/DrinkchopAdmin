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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPadding()
        self.messageTextView.textColor = UIColor.lightGray
        self.messageTextView.text = "Write Message..."
        registerCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
    
    // MARK: - Actions
    @IBAction func messageSendAction(_ sender: Any) {
        self.sendMessageBtn.isEnabled = false
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
        return 4
    }
    
    func configureChatCell(cell: ChatCVC, index: Int) {
        let currentChatMessage = "Material icons are beautifully crafted, delightful, and easy to use in your web, Android, and iOS projects. Learn more about material design and our process for making these icons in the system icons section of the material design guidelines."
        let cellChatSize = currentChatMessage.heightWithConstrainedWidth(width: 250, font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.medium))
        cell.chatMessageLabel.textColor = UIColor.white
        cell.chatMessageLabel.text = currentChatMessage
        if arc4random() % 3 == 0 {
            cell.chatMessageLabel.frame = CGRect(x: 16, y: 0, width: cellChatSize.width+16, height: cellChatSize.height+20)
            cell.chatBGView.frame = CGRect(x: 8, y: 0, width: cellChatSize.width+24, height: cellChatSize.height+20)
            cell.dateTimeLbl.textAlignment = .right
            cell.dateTimeLbl.frame = CGRect(x: 8, y: cellChatSize.height+24, width: cellChatSize.width+24, height: 20)
            cell.chatBGView.backgroundColor = UIColor.lightGray
        } else {
            cell.chatMessageLabel.frame = CGRect(x: view.frame.width - cellChatSize.width - 32, y: 0, width: cellChatSize.width+16, height: cellChatSize.height+16)
            cell.chatBGView.frame = CGRect(x: view.frame.width - cellChatSize.width - 40, y: 0, width: cellChatSize.width+24, height: cellChatSize.height+16)
            cell.dateTimeLbl.frame = CGRect(x: view.frame.width - cellChatSize.width - 40, y: cellChatSize.height+20, width: cellChatSize.width+24, height: 20)
            cell.dateTimeLbl.textAlignment = .right
            cell.chatBGView.backgroundColor = appTintColor
        }
        cell.dateTimeLbl.text = "10:0\(index) PM"
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
        let currentChatMessage = "Material icons are beautifully crafted, delightful, and easy to use in your web, Android, and iOS projects. Learn more about material design and our process for making these icons in the system icons section of the material design guidelines."
        let cellChatSize = currentChatMessage.heightWithConstrainedWidth(width: cellWidth, font: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.medium))
        return CGSize(width: self.view.frame.width, height: cellChatSize.height + 40)
    }
}
