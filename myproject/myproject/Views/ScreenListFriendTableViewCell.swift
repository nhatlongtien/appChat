//
//  ScreenListFriendTableViewCell.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/17/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ScreenListFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        let margins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
               contentView.frame = contentView.frame.inset(by: margins)
        //custom imgAvatar
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height/2
        imgAvatar.clipsToBounds = true
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.lightGray.cgColor
        imgAvatar.contentMode = .scaleAspectFill
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
