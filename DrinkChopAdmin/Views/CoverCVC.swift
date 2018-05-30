////
//  CoverCVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

protocol CoverCVCDelegate : class {
    func verifyCover(cell: CoverCVC)
    func discardCover(cell: CoverCVC)
}


class CoverCVC: UICollectionViewCell {

    @IBOutlet var confirmationNumberLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    
    weak var delegate: CoverCVCDelegate?
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLbl.getRounded(cornerRaius: 10)
        self.nameLbl.giveShadow(cornerRaius: 10)
    }

    
    @IBAction func discardAction(_ sender: Any) {
        delegate?.discardCover(cell: self)
    }
    
    @IBAction func verifyAction(_ sender: Any) {
        delegate?.verifyCover(cell: self)
    }
    
}
