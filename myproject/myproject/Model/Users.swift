//
//  Users.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/16/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
import UIKit
struct User {
    var id = String()
    var email = String()
    var fullName = String()
    var linkAvatar = String()
    var avatar = UIImage()
    
    init() {
        id = ""
        email = ""
        fullName = ""
        linkAvatar = ""
        avatar = UIImage(named: "personicon")!
    }
    
    init(id: String, email: String, fullName:String, linkAvatar:String) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "personicon")!
    }
}
