////
//  MyAccountVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {
    
    @IBOutlet var userImgView:UIImageView!
    @IBOutlet var accountCollectionView:UICollectionView!
    
    var titlesStr:[String] = ["Statistics","Messages","Pause","Close for the day","Signout"]
    
    var notificationData:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titlesStr.insert(DrinkUser.iUser.userName ?? "" , at: 0)
        self.userImgView.pin_setImage(from: URL(string: DrinkUser.iUser.userImage ?? ""))
        
        registerCell()
        
        if DrinkUser.iUser.userType == "0" {
            self.titlesStr[1] = "Statistics"
        } else if DrinkUser.iUser.userType == "1" {
            self.titlesStr[1] = "Covers"
        } else if DrinkUser.iUser.userType == "2" {
            self.titlesStr[1] = "Orders"
        }
        
        self.userImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageFromLibrary))
        self.userImgView.addGestureRecognizer(tapGesture)
        
        updateTokenFromManager()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessagesViewController {
            controller.notificationData = notificationData
        }
        if let controller = segue.destination as? AddEventHourVC {
            controller.isEvent = sender as? Bool ?? true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
        
        if ID != "" {
            if ID.components(separatedBy: ",").count > 1 {
                let isEvent = (ID.components(separatedBy: ",")[1] as NSString).boolValue
                ID = ID.components(separatedBy: ",")[0]
                self.performSegue(withIdentifier: ID, sender: isEvent)
                ID = ""
            } else {
                self.performSegue(withIdentifier: ID, sender: nil)
                ID = ""
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.userImgView.getRounded(cornerRaius: self.userImgView.frame.width/2)
        self.userImgView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "AccountCVC", bundle: nil)
        self.accountCollectionView.register(cellNib, forCellWithReuseIdentifier: AccountCellID)
    }
    
    func updateTokenFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.updateTokenOnServer { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                self!.showToast(message: "Token Updated")
                print("token updated", success)
            } else {
                self!.showToast(message: "update token error")
                print("update token error")
            }
        }
    }
    
    func changeBarStatusFromManager(status: Int, indexPath: IndexPath, isForCloseDay: Bool) {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.updateBarStatusOnServer(barId: DrinkUser.iUser.barId!, status: status) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print(success)
                if !isForCloseDay && self!.titlesStr[indexPath.row] == "Pause" {
                    self!.titlesStr[indexPath.row] = "Resume"
                } else if !isForCloseDay && self!.titlesStr[indexPath.row] == "Resume" {
                    self!.titlesStr[indexPath.row] = "Pause"
                } else if isForCloseDay && self!.titlesStr[indexPath.row] == "Close for the day" {
                    self!.titlesStr[indexPath.row] = "Open for the day"
                } else if isForCloseDay && self!.titlesStr[indexPath.row] == "Open for the day" {
                    self!.titlesStr[indexPath.row] = "Close for the day"
                }
                self!.accountCollectionView.reloadData()
            } else {
                //err
            }
        }
    }
    
    func gotoImageGallery(isCamera: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = (isCamera) ? .camera : .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func getImageFromLibrary() {
        let sheet = UIAlertController(title: "Gallery", message: "Select option from below:", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (action) in
            self!.gotoImageGallery(isCamera: true)
        }))
        sheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] (action) in
            self!.gotoImageGallery(isCamera: false)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
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
    
    @IBAction func Menu(_ sender: AnyObject) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    deinit {
        print("my account vc deinit")
    }
}

extension MyAccountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesStr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCellID, for: indexPath) as! AccountCVC
        cell.infoLbl.text = titlesStr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width, aspectRatio: 300.0/30.0, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if titlesStr[indexPath.row] == "Pause" {
            self.changeBarStatusFromManager(status: 0, indexPath: indexPath, isForCloseDay: false)
        } else if titlesStr[indexPath.row] == "Resume" {
            self.changeBarStatusFromManager(status: 1, indexPath: indexPath, isForCloseDay: false)
        } else if titlesStr[indexPath.row] == "Close for the day" {
            self.changeBarStatusFromManager(status: 0, indexPath: indexPath, isForCloseDay: true)
        } else if titlesStr[indexPath.row] == "Open for the day" {
            self.changeBarStatusFromManager(status: 1, indexPath: indexPath, isForCloseDay: true)
        } else if titlesStr[indexPath.row] == "Signout" {
            showLogoutAlert()
        } else if indexPath.row == 0 {
            // no segue
        } else  {
            self.performSegue(withIdentifier: titlesStr[indexPath.row], sender: nil)
        }
    }
    
}

extension MyAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func saveUserData() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(DrinkUser.iUser) else {return}
        
        UserDefaults.standard.set(data, forKey: UserProfileDefaultsID)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImgView.contentMode = .scaleAspectFit
            userImgView.image = pickedImage
            let fileURL = info[UIImagePickerControllerReferenceURL] as! URL
            let data = UIImageJPEGRepresentation(pickedImage, 1)!
            
            Manager.showLoader(text: "Please Wait...", view: self.view)
            Manager.uploadUserImageOnServer(imgData: data, fileURL: fileURL, completionHandler: { [weak self] (url) in
                Manager.hideLoader()
                if let url = url {
                    print(url)
                    DrinkUser.iUser.userImage = url
                    self!.saveUserData()
                } else {
                    //err
                }
            })
            
        }
        dismiss(animated: true, completion: nil)
    }
}
