//
//  ScreenListFriendViewController.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/15/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

var currentUser = User()

var ref: DatabaseReference!

//ref = Database.database().reference()
class ScreenListChatViewController: UIViewController {
    
    var listChat:Array<User> = Array<User>()
    
    @IBOutlet weak var tblListchat: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide border of cell in UITableView
       tblListchat.separatorColor = UIColor.clear
       tblListchat.dataSource = self
       tblListchat.delegate = self
        navigationController?.isNavigationBarHidden = true
       
        //lay thong tin current user
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
            let name = user.displayName
            currentUser = User(id: uid, email: email!, fullName: name!, linkAvatar: String(describing: photoURL!))
            ref = Database.database().reference()
            let tableName = ref.child("ListFriend")
            let userId = tableName.child(currentUser.id)
            let user:Dictionary<String,String> =
                ["email": currentUser.email,
                 "fullname": currentUser.fullName,
                 "LinkAvatar": currentUser.linkAvatar
                ]
            
            userId.setValue(user)
            
            
        }else{
            print("khong co user")
        }
        let tableName = ref.child("Listchat").child(currentUser.id)
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as! [String:AnyObject]
            if postDict != nil{
                let email:String = postDict["email"] as! String
                let fullName:String = postDict["fullName"] as! String
                let linkAvatar:String = postDict["linkAvatar"] as! String
                let user = User(id: snapshot.key, email: email, fullName: fullName, linkAvatar: linkAvatar)
                self.listChat.append(user)
                print(self.listChat)
                self.tblListchat.reloadData()
            }
        })
    }
}

extension ScreenListChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listChat.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView:UIView = UIView()
        headView.backgroundColor = UIColor.clear
        return headView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListChat", for: indexPath) as! ScreenListChatTableViewCell
        cell.lblName.text = listChat[indexPath.section].fullName
        cell.imgAvatar?.loadAvatar(link: listChat[indexPath.section].linkAvatar)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        visitor = listChat[indexPath.section]
        let url:URL = URL(string: listChat[indexPath.section].linkAvatar)!
        do{
            let data:Data = try Data(contentsOf: url)
            visitor.avatar = UIImage(data: data)!
        }catch{
            print("loi load hinh")
        }
       
    }
}

