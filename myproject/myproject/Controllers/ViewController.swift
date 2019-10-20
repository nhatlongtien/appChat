//
//  ViewController.swift
//  MyAppchat
//
//  Created by NGUYENLONGTIEN on 10/12/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true
        //hide keyboard when tap empty area on the view
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        //tat navigation bar
        navigationController?.isNavigationBarHidden = true
        //dang xuat tai khoan khi load ung dung
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("ban da dang xuat")
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        isLogin()
        
    }
    
    @IBAction func btn_ALogin(_ sender: UIButton) {
        let email = txtEmail.text!
        let pass = txtPassword.text!
        let alertActivity = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let activity:UIActivityIndicatorView = UIActivityIndicatorView()
        activity.frame = CGRect(x: (view.frame.width/2)-20, y: 25, width: 0, height: 0)
        alertActivity.view.addSubview(activity)
        activity.startAnimating()
        present(alertActivity, animated: true, completion: nil)
        //sign in to firebase
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error == nil {
                print("ban da dang nhap thanh cong")
                self!.gotoScreen(StoryBoardID: "HomeTapBar")
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
            }else{
                activity.stopAnimating()
                alertActivity.dismiss(animated: true, completion: nil)
                self!.notification(mess: "Your Email or Password is wrong")
            }
        }
    }
    @IBAction func btn_ARegister(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let screenRegister = sb.instantiateViewController(identifier: "ScreenRegister") as! ScreenRegisterViewController
        self.navigationController?.pushViewController(screenRegister, animated: true)
    }
    // function to show notification
    func notification(mess: String){
        let alert = UIAlertController(title: "Notification", message: mess, preferredStyle: UIAlertController.Style.alert)
        let btn_OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(btn_OK)
        present(alert, animated: true, completion: nil)
    }
    //function to check if user is login or not
    func isLogin(){
        if Auth.auth().currentUser != nil {
          // User is signed in.
          print("ban da dang nhap")
            gotoScreen(StoryBoardID: "HomeTapBar")
        } else {
          // No user is signed in.
          print("ban chua dang nhap")
        }
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    //function to move screen
    func gotoScreen(StoryBoardID: String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let newScreen = sb.instantiateViewController(identifier: StoryBoardID)
        self.navigationController?.pushViewController(newScreen, animated: true)
    }
    
    
    
    
}
