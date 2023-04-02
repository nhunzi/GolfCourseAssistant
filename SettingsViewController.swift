//
//  SettingsViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit
import SQLite3


class SettingsViewController: UIViewController {
    var db: OpaquePointer?
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Database Connection
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroesDatabase.sqlite")
        
        
        //opening the database
        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return
        }

       
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, Firstname TEXT, LastName TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        
    }
    
    
    
    @IBAction func SavePass(_ sender: UIButton) {
        
        //getting values from textfields
               let Firstname = FirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
              // let Lastname = LastName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //validating that values are not empty
                if(Firstname?.isEmpty)!{
                    FirstName.layer.borderColor = UIColor.red.cgColor
                    return
                }
         
               // if(Lastname?.isEmpty)!{
               //     LastName.layer.borderColor = UIColor.red.cgColor
               //     return
               // }
        //creating a statement
                var stmt: OpaquePointer?
         
                //the insert query
                let queryString = "INSERT INTO Heroes (Firstname, Lastname) VALUES (?,?)"
         
        //preparing the query
                if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                    return
                }
         
                //binding the parameters
                if sqlite3_bind_text(stmt, 1, Firstname, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding name: \(errmsg)")
                    return
                }
         
               // if sqlite3_bind_int(stmt, 2, (Lastname! as NSString).intValue) != SQLITE_OK{
                //    let errmsg = String(cString: sqlite3_errmsg(db)!)
                //    print("failure binding name: \(errmsg)")
                //    return
               // }
         
                //executing the query to insert values
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting hero: \(errmsg)")
                    return
                }
         
                //emptying the textfields
                FirstName.text=""
                LastName.text=""
         
         
                //readValues()
         
                //displaying a success message
                print("Herro saved successfully")
        
        
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


