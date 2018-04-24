//
//  ChatCVC.swift
//  Momentum
//
//  Created by Mac on 24/10/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ChatCVC: UICollectionViewCell {

    @IBOutlet var dateTimeLbl: UILabel!
    @IBOutlet var chatMessageLabel:UILabel!
    @IBOutlet var chatBGView: UIView!
    
    
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
        
        self.chatBGView.getRounded(cornerRaius: 10.0)
        self.chatMessageLabel.getRounded(cornerRaius: 10.0)
    }

    deinit {
        print("chat cvc deinit")
    }
}
