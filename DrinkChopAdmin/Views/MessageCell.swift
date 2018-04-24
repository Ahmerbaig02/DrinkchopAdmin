//
//  MessageCell.swift
//  Momentum
//
//  Created by Mac on 29/03/2017.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var MessageLabel: UILabel!

    @IBOutlet var senderImageView: UIImageView!
    
    @IBOutlet var readImageView: UIImageView!
    
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
        //self.senderImageView.getRounded(cornerRaius: senderImageView.frame.width/2)
    }
    
}
