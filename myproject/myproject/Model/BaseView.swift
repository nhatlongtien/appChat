//
//  BaseView.swift
//  myproject
//
//  Created by NGUYENLONGTIEN on 10/17/19.
//  Copyright © 2019 NGUYENLONGTIEN. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func loadAvatar(link:String){
        let queue:DispatchQueue = DispatchQueue(label: "loadImage")
        let activity:UIActivityIndicatorView = UIActivityIndicatorView()
        activity.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        activity.color = UIColor.blue
        self.addSubview(activity)
        activity.startAnimating()
        
        queue.async {
            let url:URL = URL(string: link)!
            do{
                let data:Data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                }
                
            }catch{
                activity.stopAnimating()
                print("khong load dc hinh")
            }
            
        }
        
    }
}

extension UIButton{
    func skin(y: Bool){
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        self.layer.cornerRadius = 10
        if y {
            self.layer.borderColor = UIColor.blue.cgColor
            self.layer.borderWidth = 1
            self.tintColor = UIColor.blue
            self.backgroundColor = UIColor.white
        }
    }
}



/*extension UIButton
{
    func skin(b:Bool)
    {
        self.titleLabel?.numberOfLines = 1;
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        self.layer.cornerRadius = 10
        if(b)
        {
            self.layer.borderColor = UIColor.red().cgColor
            self.layer.borderWidth = 1
            self.tintColor = UIColor.red()
            self.backgroundColor = UIColor.white()
        }
        
    }
} */

