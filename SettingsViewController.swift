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
    @IBOutlet weak var MyUnitSegment: UISegmentedControl!
    
    var yards: Int = 0
    var meters: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          if (myUnits == 1)
           {
              MyUnitSegment.selectedSegmentIndex = 1
              MyUnitSegment.selectedSegmentTintColor = UIColor.white
           }
        else if (myUnits == 0)
          {
              MyUnitSegment.selectedSegmentIndex = 2
              MyUnitSegment.selectedSegmentTintColor = UIColor.white
          }
            
        
        FirstName.text = userNameSettings
        Email.text = MyEmail
        
        
    }
    
    
    @IBAction func ChangeUnits(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
           
            yards = 1
            print("Yards", yards)
            myUnits = 0;
            print ("Units ", myUnits)
          
           
        }
        else if sender.selectedSegmentIndex == 1
        {
            
            myUnits = 1
            meters = 1
            MyUnitSegment.selectedSegmentTintColor = UIColor.white
            print ("Units ", myUnits)
          }
        
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


