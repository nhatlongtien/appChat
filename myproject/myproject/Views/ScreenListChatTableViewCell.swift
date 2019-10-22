//
//  ScreenListChatTableViewCell.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/21/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit

class ScreenListChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom imgAvatar
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.lightGray.cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height/2
        imgAvatar.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
