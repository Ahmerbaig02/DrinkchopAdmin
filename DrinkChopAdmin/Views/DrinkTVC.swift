////
//  DrinkTVC.swift
//  DrinkChopAdmin
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit

protocol DrinkTVCDelegate: class {
    func selectItem(cell: DrinkTVC, indexPath: IndexPath)
}

class DrinkTVC: UITableViewCell {

    @IBOutlet var selectionImgView:UIImageView!
    @IBOutlet var titleLbl:UILabel!
    
    weak var delegate: DrinkTVCDelegate?
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionImgView.isUserInteractionEnabled = true
        self.selectionImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectItemAction)))
    }
    
    @objc func selectItemAction() {
        delegate?.selectItem(cell: self, indexPath: self.indexPath)
    }
    
}
