//
//  ScreenInformationViewController.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/22/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import Firebase

class ScreenInformationViewController: UIViewController {

    @IBOutlet weak var lbluserName: UILabel!
    
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //custom imgAvatar
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.borderColor = UIColor.lightGray.cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height/2
        imgAvatar.clipsToBounds = true
        imgAvatar.contentMode = .scaleAspectFill
        
        //load information of current user:
        lbluserName.text = "Full name: \(currentUser.fullName)"
        lblUserEmail.text = "Email: \(currentUser.email)"
        imgAvatar.loadAvatar(link: currentUser.linkAvatar)
    }
    @IBAction func acSingOut(_ sender: Any) {
        //dang xuat tai khoan
        let firebaseAuth = Auth.auth()
               do {
                 try firebaseAuth.signOut()
                 let alert:UIAlertController = UIAlertController(title: "Notification", message: "You have sign out successfully!", preferredStyle: UIAlertController.Style.alert)
                 let btn_OK:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newScreen = sb.instantiateViewController(withIdentifier: "HomeScreen")
                    self.navigationController?.pushViewController(newScreen, animated: true)
                }
                alert.addAction(btn_OK)
                present(alert, animated: true, completion: nil)
                
               } catch let signOutError as NSError {
                 print ("Error signing out: %@", signOutError)
               }
    }
}
