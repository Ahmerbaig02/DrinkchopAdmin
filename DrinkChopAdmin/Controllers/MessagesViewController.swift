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
    
    var title_color:UIColor = appTintColor
    var readTintColor:UIColor = UIColor(red: 28/255, green: 144/255, blue: 91/255, alpha: 1.0)

    var users:[String] = ["Ahmer Baig", "Ali Baig" ,"Ali Hassan Jutt", "Husnain Jutt", "Safeer Baig", "Irtiza Ali"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessageDetailsVC {
            let index = sender as! Int
        }
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
        cell.MessageLabel.attributedText = getAttributedText(Titles: [users[indexPath.row] ,"Hi How are you?"], Font: [.boldSystemFont(ofSize: 14.0),.systemFont(ofSize: 11.0, weight: UIFont.Weight.medium)], Colors: [title_color,.gray], seperator: ["\n",""], Spacing: 0, atIndex: -1)
        cell.timeLabel.attributedText = timeAttributedTextWithImageAttachment(timeText: ("12/11/2017"))
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
