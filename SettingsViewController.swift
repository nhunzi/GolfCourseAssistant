//
//  SettingsViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit



class SettingsViewController: UIViewController {
    var db: OpaquePointer?
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstName.text = userNameSettings
        Email.text = MyEmail
       
        
    }
    
    
    
    @IBAction func SavePass(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue)
    {
        
    }

    
    
}
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


