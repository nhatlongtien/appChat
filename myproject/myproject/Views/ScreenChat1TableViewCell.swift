//
//  ScreenChat1TableViewCell.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/19/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ScreenChat1TableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom lblMessage
        lblMessage.numberOfLines = 0
        lblMessage.layer.cornerRadius = 10
        lblMessage.clipsToBounds = true
        lblMessage.sizeToFit()
        
        //custom lblimgAvatar
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.lightGray.cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height/2
        imgAvatar.clipsToBounds = true
        imgAvatar.contentMode = .scaleAspectFill
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
