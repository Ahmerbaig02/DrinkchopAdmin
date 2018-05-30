//
//  EditDrinkVC.swift
//  DrinkChopAdmin
//
//  Created by Mahnoor Fatima on 4/25/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class BourbonVC: UIViewController {
    
    @IBOutlet weak var drinkNameLbl: UILabel!
    @IBOutlet weak var drinkImgView: UIImageView!
    @IBOutlet weak var percentAlcoholLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var ingredientLbl: UILabel!
    @IBOutlet var priceCollectionView: UICollectionView!
    
    var selectedDrinkData: Drink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setDataInViews()
    }
    
    func setDataInViews() {
        self.drinkNameLbl.text = self.selectedDrinkData.drinkName ?? ""
        self.drinkImgView.pin_setImage(from: URL(string: self.selectedDrinkData.drinkPicture ?? ""))
        self.descriptionLbl.text = self.selectedDrinkData.drinkDescription ?? ""
        self.ingredientLbl.text = self.selectedDrinkData.drinkIngredients ?? ""
        self.percentAlcoholLbl.text = "\(self.selectedDrinkData.drinkAlcohal ?? "0")% Alcohol"
        self.priceCollectionView.reloadData()
        
    }
    
    func registerCells() {
        let cellNib = UINib(nibName: "HyveDrinkCVC", bundle: nil)
        priceCollectionView.register(cellNib, forCellWithReuseIdentifier: HyveDrinkCellID)
        
    }
    
    deinit {
        print("deinit EditDrinkVC")
    }
    
}

extension BourbonVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedDrinkData.extras?.count ?? 0
    }
    
    func configureCell(cell: HyveDrinkCVC, index: Int) {
        let selectedExtra = self.selectedDrinkData.extras![index]
        cell.nameLbl.text = selectedExtra.extraName ?? ""
        cell.priceLbl.text = "+$\(selectedExtra.extraCost ?? "0")"
        cell.selectedImgView.isHidden = true
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
        
    }
    
}

