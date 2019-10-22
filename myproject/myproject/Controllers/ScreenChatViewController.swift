//
//  ScreenChatViewController.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/17/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class ScreenChatViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var iMessage: UITextField!
    var tableName: DatabaseReference!
    
    var arrIDChat:Array<String> = Array<String>()
    var arrtxtChat:Array<String> = Array<String>()
    var arrUserChat:Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide bother of cell in UITableView
        tblChat.separatorColor = UIColor.clear
        tblChat.dataSource = self
        tblChat.delegate = self
        arrIDChat.append(currentUser.id)
        arrIDChat.append(visitor.id)
        arrIDChat.sort()
        let key:String = "\(arrIDChat[0])\(arrIDChat[1]))"
        print(key)
        //show navigation bar
        navigationController?.isNavigationBarHidden = false
        //tao table Chat tren firebase
        tableName = ref.child("Chat").child(key)
        iMessage.delegate = self
        //viet ham nhan du lieu ve
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String:AnyObject]
            if postDict != nil{
                if postDict!["id"] as! String == currentUser.id{
                    self.arrUserChat.append(currentUser)
                }else{
                    self.arrUserChat.append(visitor)
                }
                self.arrtxtChat.append(postDict!["message"] as! String)
                self.tblChat.reloadData()
            }
        })
        
        // listen for keyboard event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
   
    @objc func keyboardwillChange(notification: Notification){
        print("keyboard Will Show \(notification.name.rawValue)")
        // to get the hight of keyboard
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            //print(keyboardHeight)
            //change the y of view when keyboad appearing
            if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
                view.frame.origin.y = -(keyboardHeight)
            }else{
                view.frame.origin.y = 0
            }
            
        }
    }
    func hideKeyboard(){
        iMessage.resignFirstResponder()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("press return")
        hideKeyboard()
        view.frame.origin.y = 0
        return true
    }

    @IBAction func btnASend(_ sender: Any) {
        let mess:Dictionary<String,String> =
            ["id":currentUser.id,
             "message":iMessage.text!
        ]
        tableName.childByAutoId().setValue(mess)
        iMessage.text = ""
        //make table list Chat on fireBase
        if arrtxtChat.count == 0{
            addListChat(user1: currentUser, user2: visitor)
            addListChat(user1: visitor, user2: currentUser)
        }
    }
    //them du lieu vao table list chat tren firebase
    func addListChat(user1: User,user2: User){
        let tableNameListChat = ref.child("Listchat").child(user1.id).child(user2.id)
        let user:Dictionary<String,String> = ["id": user2.id,"fullName":user2.fullName,"email":user2.email,"linkAvatar":user2.linkAvatar]
        tableNameListChat.setValue(user)
    }
}
extension ScreenChatViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrtxtChat.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentUser.id == arrUserChat[indexPath.row].id{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ScreenChat2TableViewCell
            cell.lblMessage.text = arrtxtChat[indexPath.row]
            cell.imgAvatar.loadAvatar(link: currentUser.linkAvatar)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ScreenChat1TableViewCell
            cell.lblMessage.text = arrtxtChat[indexPath.row]
            cell.imgAvatar.image = visitor.avatar
            return cell
        }
       
    }
}
