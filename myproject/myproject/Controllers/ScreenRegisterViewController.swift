//
//  ScreenRegisterViewController.swift
//  MyAppchat
//
//  Created by NGUYENLONGTIEN on 10/12/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://appchat-6c2cd.appspot.com")
class ScreenRegisterViewController: UIViewController, UITextFieldDelegate {
    var imgData:Data!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPasword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //chosse event from keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        navigationController?.isNavigationBarHidden = false
        txtPasword.isSecureTextEntry = true
        txtRePassword.isSecureTextEntry = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    func notification(mess:String){
        let alert = UIAlertController(title: "Notification", message: mess, preferredStyle: UIAlertController.Style.alert)
        let btn_OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(btn_OK)
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func btnARegister(_ sender: Any) {
        
        //dang ky
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPasword.text!) { authResult, error in
            if error == nil {
                //thong bao dang ky thanh cong
                self.notification(mess: "Dang ky tai khoan thanh cong")
                //dang nhap
                Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPasword.text!) { [weak self] authResult, error in
                  guard let strongSelf = self else { return }
                    if error == nil{
                        print("Dang nhap thanh cong")
                    }
                }
                // upload file hinh len firebase
                let avatarRef = storageRef.child("images/\(self.txtEmail.text!).jpg")
                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { (metadata, error) in
                  guard let metadata = metadata else {
                    print("loi up hinh")
                    return
                  }
                  // Metadata contains file metadata such as size, content-type.
                  let size = metadata.size
                  // You can also access to download URL after upload.
                  avatarRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                      // Uh-oh, an error occurred!
                        print("Image URL is not exist")
                      return
                    }
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.txtName.text!
                    changeRequest?.photoURL = downloadURL
                    changeRequest?.commitChanges { (error) in
                        if error == nil {
                            print("upload profile thanh cong")
                            self.gotoScreen(StoryBoardID: "HomeTapBar")
                        }else{
                            print("upload profile khong thanh cong")
                        }
                    }
                  }
                }
                
                uploadTask.resume()
                
            }else{
                print("Dang ky khong thanh cong")
                self.notification(mess: "Dang ky khong thanh cong")
                
            }
          
        }
    }
    
    
    @IBAction func tapAvatar(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Notification", message: "Please choose your photo from:", preferredStyle: UIAlertController.Style.alert)
        let btnPhoto = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
        let btnCamera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let imgPicker = UIImagePickerController()
                imgPicker.sourceType = UIImagePickerController.SourceType.camera
                imgPicker.delegate = self
                imgPicker.allowsEditing = false
                self.present(imgPicker, animated: true, completion: nil)
            }else{
                print("Camera is not available")
            }
            
        }
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
        self.present(alert, animated: true, completion: nil)
    }
    // func chuyen man hinh
    func gotoScreen(StoryBoardID: String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let newScreen = sb.instantiateViewController(identifier: StoryBoardID)
        navigationController?.pushViewController(newScreen, animated: true)
    }
    // func tat keyboard khi cham vao ngoai text fields
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    //function move textfield up when we keyboad appearing
    @objc func keyboardwillChange(notification: Notification){
        print("keyboard Will Show \(notification.name.rawValue)")
        // to get the hight of keyboard
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            //change the y of view when keyboad appearing
            if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
                view.frame.origin.y = -100
            }else{
                view.frame.origin.y = 0
            }
            
        }
    }

}

extension ScreenRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chooseImg = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        var imgvalue = max(chooseImg.size.width, chooseImg.size.height)
        if imgvalue >= 3000{
            imgData = chooseImg.jpegData(compressionQuality: 0.1)
        }else if imgvalue >= 2000{
            imgData = chooseImg.jpegData(compressionQuality: 0.3)
        }else{
            imgData = chooseImg.jpegData(compressionQuality: 1.0)
        }
        
        imgAvatar.image = UIImage(data: imgData)
        dismiss(animated: true, completion: nil)
    }
}
 


