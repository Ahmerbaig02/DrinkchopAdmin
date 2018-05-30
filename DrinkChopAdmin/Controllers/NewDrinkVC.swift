////
//  NewDrinkVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

class NewDrinkVC: UIViewController {

    @IBOutlet var categoryTF: UITextField!
    @IBOutlet var drinkImgView: UIImageView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var descriptionTV: UITextView!
    @IBOutlet var alcoholTF: UITextField!
    @IBOutlet var itemsCollectionView: UICollectionView!
    @IBOutlet var ingredientsTF: UITextField!
    @IBOutlet var costTF: UITextField!
    
    var drinksTypes:[String] = []
    
    var extrasData:[DrinkExtras] = []
    var selectedExtras:[DrinkExtras] = []
    
    var fileURL:URL!
    var imgData:Data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        self.categoryTF.inputView = picker
        
        registerCells()
        getExtrasFromManager()
        
        self.drinkImgView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.getImageFromLibrary))
        self.drinkImgView.addGestureRecognizer(tapGesture)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.createNewDrinkFromManager))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.descriptionTV.getRounded(cornerRaius: 10)
        self.drinkImgView.getRounded(cornerRaius: 10)
        self.drinkImgView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationsUtil.setSuperView(navController: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationsUtil.removeFromSuperView()
    }
    
    func registerCells() {
        let cellNib = UINib(nibName: "HyveDrinkCVC", bundle: nil)
        itemsCollectionView.register(cellNib, forCellWithReuseIdentifier: HyveDrinkCellID)
    }
    
    @objc func getImageFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getExtrasFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        Manager.getSuperExtrasFromServer { [weak self] (rawExtras) in
            Manager.hideLoader()
            if let extras = rawExtras {
                self!.extrasData.removeAll(keepingCapacity: false)
                self!.extrasData = extras
                self!.itemsCollectionView.reloadData()
            } else {
                //err
                print("extras fetch error")
            }
        }
    }
    
    @objc func createNewDrinkFromManager() {
        Manager.showLoader(text: "Please Wait...", view: self.view)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self.selectedExtras) else {
            print("json encoding extras error")
            return
        }
        let param:[String: Data] = ["bar_id": DrinkUser.iUser.barId!.data(using: .utf8)!,
                                    "name": self.nameTF.text!.data(using: .utf8)!,
                                    "alcohol": self.alcoholTF.text!.data(using: .utf8)!,
                                    "description": self.descriptionTV.text!.data(using: .utf8)!,
                                    "ingredients": self.ingredientsTF.text!.data(using: .utf8)!,
                                    "cost": self.costTF.text!.data(using: .utf8)!,
                                    "category": self.categoryTF.text!.data(using: .utf8)!,
                                    "extras": data]
        Manager.addNewDrinkOnServer(imgData: imgData, fileURL: fileURL, params: param) { [weak self] (url) in
            Manager.hideLoader()
            if let url = url {
                print(url)
                _ = self!.navigationController?.popViewController(animated: true)
            } else {
                //err
                print("add drink error")
            }
        }
    }
    
    deinit {
        print("new drink vc deini")
    }
}

extension NewDrinkVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}


extension NewDrinkVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinksTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinksTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTF.text = drinksTypes[row]
    }
    
}


extension NewDrinkVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return extrasData.count
    }
    
    func configureCell(cell: HyveDrinkCVC, index: Int) {
        let selectedExtra = self.extrasData[index]
        cell.nameLbl.text = selectedExtra.extraName ?? ""
        cell.priceLbl.text = "+$\(selectedExtra.extraCost ?? "0")"
        cell.selectedImgView.isHidden = !self.selectedExtras.contains(where: { $0.extraId == selectedExtra.extraId })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HyveDrinkCellID, for: indexPath) as! HyveDrinkCVC
        
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width/4, aspectRatio: 75/100, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? HyveDrinkCVC {
            let selectedExtra = self.extrasData[indexPath.row]
            if self.selectedExtras.contains(where: { $0.extraId == selectedExtra.extraId }) {
                let RIndex = self.selectedExtras.index(where: { $0.extraId == selectedExtra.extraId })!
                self.selectedExtras.remove(at: RIndex)
            } else {
                self.selectedExtras.append(selectedExtra)
            }
            self.itemsCollectionView.reloadData()
        }
    }
}

extension NewDrinkVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            drinkImgView.contentMode = .scaleAspectFill
            drinkImgView.image = pickedImage
            
            fileURL = info[UIImagePickerControllerReferenceURL] as! URL
            imgData = UIImageJPEGRepresentation(pickedImage, 1)!
        }
        dismiss(animated: true, completion: nil)
    }
}

