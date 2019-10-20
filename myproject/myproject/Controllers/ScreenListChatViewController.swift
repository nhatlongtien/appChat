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
class ScreenListChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var btnMemu:UIButton = UIButton()
    var viewMenu:UIView = UIView()
    var tableViewSlideMenu:UITableView = UITableView()
    var mang:Array<String> = ["A", "B","C"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setMenu()
        setupViewMenu()
        SwipeGesture()
        setupTableViewSlideMenu()
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
    }
    

    func setMenu(){
        btnMemu = UIButton(frame: CGRect(x: 5, y: 25, width: 30, height: 30))
        btnMemu.setBackgroundImage(UIImage(named: "iconMenu"), for: UIControl.State.normal)
        view.addSubview(btnMemu)
        btnMemu.addTarget(self, action: #selector(showMenu), for: UIControl.Event.touchUpInside)
    }
    func setupViewMenu(){
        viewMenu = UIView(frame: CGRect(x: -view.frame.width/1.5, y: 55, width: view.frame.size.width/1.5, height: view.frame.height - 55 - (tabBarController?.tabBar.frame.height)! ))
        viewMenu.backgroundColor = UIColor.lightGray
        navigationController?.view.addSubview(viewMenu)
        
    }
    @objc func showMenu(){
        print("showwww")
        if viewMenu.frame.origin.x < 0{
            UIView.animate(withDuration: 1) {
                self.viewMenu.frame.origin.x += self.view.frame.width / 1.5
            }
        }else{
            UIView.animate(withDuration: 1) {
                self.viewMenu.frame.origin.x -= self.view.frame.width / 1.5
            }
        }
        
    }
    
    func SwipeGesture(){
        let right:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRight))
        right.direction = .right
        view.addGestureRecognizer(right)
        let left:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeft))
        left.direction = .left
        view.addGestureRecognizer(left)
    }
    @objc func SwipeRight(){
        UIView.animate(withDuration: 1) {
            self.viewMenu.frame.origin.x += self.view.frame.width/1.5
        }
    }
    @objc func SwipeLeft(){
        UIView.animate(withDuration: 1) {
            self.viewMenu.frame.origin.x -= self.view.frame.width/1.5
        }
    }
    func setupTableViewSlideMenu(){
        tableViewSlideMenu = UITableView(frame: CGRect(x: 0, y: 0, width: viewMenu.frame.size.width, height: viewMenu.frame.size.height))
        viewMenu.addSubview(tableViewSlideMenu)
        tableViewSlideMenu.register(cellTableView.self, forCellReuseIdentifier: "cellInSlide")
        tableViewSlideMenu.backgroundColor = UIColor.lightGray
        tableViewSlideMenu.delegate = self
        tableViewSlideMenu.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mang.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewSlideMenu.dequeueReusableCell(withIdentifier: "cellInSlide", for: indexPath) as! cellTableView
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.text = mang[indexPath.row]
        return cell
        
    }
  
    
    
}
class cellTableView: UITableViewCell {
    
}
