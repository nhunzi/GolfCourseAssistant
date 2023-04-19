//
//  UserNameViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 4/1/23.
//

import UIKit
import GRDB

private var dbQueue: DatabaseQueue?

var MyUserName: String = "" ;

class UserNameViewController: UIViewController {
    
    
    @IBOutlet weak var Username: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Database
         dbQueue = try? getDatabaseQueue()
        
        try? dbQueue?.write {db in try
            db.create (table: "myGolfer"){ t in
                t.column("Userid", .text ).primaryKey()
                t.column("UserName", .text ).notNull()
                t.column("Email", .text ).notNull()
                
            }
            print("Golfer data is in db")
        }

       
    }
    
    
    @IBAction func SaveUserName(_ sender: UIButton) {
        MyUserName = Username.text ?? "";
        print("!!!!!!!!!!!! USERNAME: \((MyUserName))")
        
        try! dbQueue!.write { db in
            try myGolfer(Userid: "\(MyUserid)", UserName: "\(MyUserName)", Email: "\(MyEmail)").insert(db)
            print("Golfer data is in database!!!!!2")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
       
            //let destController = segue.destination as! ViewController
            //destController.receiverStr = self.userNameLabel.text ?? ""
           //destController.nameString = self.CourseName.text ?? ""
    
       
    }
    //Database
    
    private func getDatabaseQueue() throws -> DatabaseQueue{
        let fileManager = FileManager.default
        
        let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("GCA_Database.db").path
    
       
        
        if !fileManager.fileExists(atPath: dbPath)
        {
            let dbResourcePath = Bundle.main.path(forResource: "GCA_Database", ofType: "db")!
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        
        return try DatabaseQueue(path: dbPath)
    }

   
}
