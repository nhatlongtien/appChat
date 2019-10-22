//
//  ScreenListChatViewController.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/15/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
var visitor:User!
class ScreenListFriendViewController: UIViewController {
    @IBOutlet weak var tblistFriend: UITableView!
    var listFriend:Array<User>! = Array<User>()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //hide bother of cell in UITableWiew
        tblistFriend.separatorColor = UIColor.clear
        //to show navigation bar
        navigationController?.isNavigationBarHidden = false
        tblistFriend.dataSource = self
        tblistFriend.delegate = self
        let tableName = ref.child("ListFriend")
        tableName.observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String:AnyObject]
            if postDict != nil {
                //print(postDict)
                let email:String = postDict?["email"] as! String
                let fullname:String = postDict?["fullname"] as! String
                let linkAvatar:String = postDict?["LinkAvatar"] as! String
                let user = User(id: snapshot.key, email: email, fullName: fullname, linkAvatar: linkAvatar)
                //kiem tra UserID co trung voi currentUserID neu trung thi khong them vao danh sach
                if user.id != currentUser.id{
                    self.listFriend.append(user)
                }
                
                self.tblistFriend.reloadData()
                print(self.listFriend)
            }
        })
        // Do any additional setup after loading the view.
    }
    
   

}

extension ScreenListFriendViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return listFriend.count
    }
    //set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    //make the background color show thought
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(listFriend.count)
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListFriend", for: indexPath) as! ScreenListFriendTableViewCell
        // note that indexPath.section is used rather than indexPath.row
        cell.lbl_name.text =  listFriend[indexPath.section].fullName
        cell.imgAvatar.loadAvatar(link: listFriend[indexPath.section].linkAvatar)
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        visitor = listFriend[indexPath.section]
        //nen phan luon de ap chay nhanh hon (lam sau)
        let url:URL = URL(string: visitor.linkAvatar)!
        do{
            let data:Data = try Data(contentsOf: url)
            visitor.avatar = UIImage(data: data)!
        }catch{
            print("khong load dc hinh tu visitor")
        }
        
        print(visitor)
    }
    
    
}
