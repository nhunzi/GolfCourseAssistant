//
//  UserNameViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 4/1/23.
//

import UIKit

var MyUserName: String = "" ;

class UserNameViewController: UIViewController {
    
    
    @IBOutlet weak var Username: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func SaveUserName(_ sender: UIButton) {
        MyUserName = Username.text ?? "";
        print("!!!!!!!!!!!! USERNAME: \((MyUserName))")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
       
            //let destController = segue.destination as! ViewController
            //destController.receiverStr = self.userNameLabel.text ?? ""
           //destController.nameString = self.CourseName.text ?? ""
    
       
    }
    

   
}
