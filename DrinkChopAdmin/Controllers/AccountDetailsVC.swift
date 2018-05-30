////
//  AccountDetailsVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class AccountDetailsVC: UIViewController {

    @IBOutlet var peopleDoorView: UIView!
    @IBOutlet var peopleDoorCollectionView: UICollectionView!
    
    @IBOutlet var userImgView: UIImageView!

    @IBOutlet var coversCollectionView: UICollectionView!
    
    var coversData:[DrinkCover] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImgView.pin_setImage(from: URL(string: DrinkUser.iUser.userImage ?? ""))
        
        self.userImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageFromLibrary))
        self.userImgView.addGestureRecognizer(tapGesture)
        
        registerCell()
        
        getCoversFromManager()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.peopleDoorView.getRounded(cornerRaius: 5)
        self.peopleDoorView.giveShadow(cornerRaius: 5)
        
        self.userImgView.getRounded(cornerRaius: self.userImgView.frame.width/2)
        self.userImgView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    func registerCell() {
        let cellNib = UINib(nibName: "PeopleDoorCVC", bundle: nil)
        self.peopleDoorCollectionView.register(cellNib, forCellWithReuseIdentifier: PeopleDoorCellID)
        
        let coverCellNib = UINib(nibName: "CoverCVC", bundle: nil)
        self.coversCollectionView.register(coverCellNib, forCellWithReuseIdentifier: CoverCellID)
    }
    
    func getCoversFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getCoversFromServer(id: DrinkUser.iUser.userId!) { [weak self] (coversData) in
            Manager.hideLoader()
            if let covers = coversData {
                self!.coversData.removeAll(keepingCapacity: false)
                self!.coversData = covers
                self!.coversCollectionView.reloadData()
            } else {
                self!.showToast(message: "Unable to fetch Covers.")
                print("covers fetch error")
                //err
            }
        }
    }

    func confirmCheckinFromManager(status: String, index: Int) {
        let bartenderId = self.coversData[index].barEntryId ?? ""
        let people = self.coversData[index].entryCount ?? ""
        let barId = self.coversData[index].barId ?? ""
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.checkinUserOnServer(barId: barId, bar_entry_id: bartenderId, status: status, people: people) { [weak self] (success) in
            Manager.hideLoader()
            if let success = success {
                print("success:\(success)\nstatus: \(status)")
                self!.showToast(message: "Confirmed Cover Checkin.")
                self!.coversData.remove(at: index)
                self!.coversCollectionView.reloadData()
            } else {
                self!.showToast(message: "Unable to Confirm Cover Checkin.")
                print("error confirm check in status: \(status)")
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
    
    deinit {
        print("my account vc deinit")
    }
}

extension AccountDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == peopleDoorCollectionView {
            return 4
        } else {
            return self.coversData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == peopleDoorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleDoorCellID, for: indexPath) as! PeopleDoorCVC
            if indexPath.row%2 == 0 {
                cell.infoLbl.textColor = appTintColor
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverCellID, for: indexPath) as! CoverCVC
        cell.nameLbl.text = self.coversData[indexPath.row].userName ?? ""
        cell.priceLbl.text = "Paid for: \(self.coversData[indexPath.row].entryCount ?? "0")\n\nTotal: $\(self.coversData[indexPath.row].amount ?? "")"
        cell.confirmationNumberLbl.text = "Confirmation Number:\n\(self.coversData[indexPath.row].confirmationId ?? "")"
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.coversCollectionView {
            return 0
        }
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == peopleDoorCollectionView {
            return getCellHeaderSize(Width: collectionView.frame.width/3, aspectRatio: 86/44, padding: 20)
        }
        return getCellHeaderSize(Width: collectionView.frame.width, aspectRatio: 355/255, padding: 0)
    }
}


extension AccountDetailsVC: CoverCVCDelegate {
    
    func verifyCover(cell: CoverCVC) {
        guard let index = self.coversCollectionView.indexPath(for: cell)?.row else {return}
        confirmCheckinFromManager(status: "1", index: index)
    }
    
    func discardCover(cell: CoverCVC) {
        guard let index = self.coversCollectionView.indexPath(for: cell)?.row else {return}
        confirmCheckinFromManager(status: "2", index: index)
    }
}

extension AccountDetailsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                    self!.showToast(message: "Image Uploaded.")
                    print(url)
                } else {
                    self!.showToast(message: "Unbale to upload Image. Please try again...")
                    //err
                }
            })
            
        }
        dismiss(animated: true, completion: nil)
    }
}
