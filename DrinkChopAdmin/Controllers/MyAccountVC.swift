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
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titlesStr.insert("John Doe", at: 0)
        
        imagePicker.delegate = self
        
        registerCell()
        
        self.userImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageFromLibrary))
        self.userImgView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ID != "" {
            self.performSegue(withIdentifier: ID, sender: nil)
            ID = ""
        }
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
    
    @objc func getImageFromLibrary() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
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
            titlesStr[indexPath.row] = "Resume"
            self.accountCollectionView.reloadData()
        } else if titlesStr[indexPath.row] == "Resume" {
            titlesStr[indexPath.row] = "Pause"
            self.accountCollectionView.reloadData()
        } else if titlesStr[indexPath.row] == "Signout" {
            showLogoutAlert()
        } else if indexPath.row == 0 {
            self.performSegue(withIdentifier: "My Account", sender: nil)
        } else  {
            self.performSegue(withIdentifier: titlesStr[indexPath.row], sender: nil)
        }
    }
    
}

extension MyAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImgView.contentMode = .scaleAspectFit
            userImgView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
