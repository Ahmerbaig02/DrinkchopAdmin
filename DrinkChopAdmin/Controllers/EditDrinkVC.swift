//
//  EditDrinkVC.swift
//  DrinkChopAdmin
//
//  Created by Mahnoor Fatima on 4/25/18.
//  Copyright © 2018 Mahnoor Fatima. All rights reserved.
//

import UIKit

class EditDrinkVC: UIViewController {

    @IBOutlet weak var drinkNameLbl: UILabel!
    @IBOutlet weak var drinkImgView: UIImageView!
    @IBOutlet weak var percentAlcoholLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var ingredientLbl: UILabel!
    @IBOutlet var priceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }

    func registerCells() {
        let cellNib = UINib(nibName: "HyveDrinkCVC", bundle: nil)
        priceCollectionView.register(cellNib, forCellWithReuseIdentifier: HyveDrinkCellID)
        
    }
    
    deinit {
         print("deinit EditDrinkVC")
    }

}

extension EditDrinkVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HyveDrinkCellID, for: indexPath) as! HyveDrinkCVC
        cell.priceLbl.text = "+$\(arc4random() % 100)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellHeaderSize(Width: self.view.frame.width/4, aspectRatio: 75/75, padding: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
