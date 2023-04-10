//
//  SearchViewController.swift
//  iOS UIKit Login
//
//  Created by Cara du Preez on 1/29/23.
//

import UIKit
import SQLite
import GRDB

private var dbQueue: DatabaseQueue?
var mygolfer: myGolfer?

var userNameSettings: String = ""
class SearchViewController : UIViewController
{
    //Database
    //private var dbQueue: DatabaseQueue?
    
    
    //Get user email address
    @IBOutlet weak var userName: UILabel!
    //Get the name of the course
    @IBOutlet weak var CourseName: UILabel!
  
    
    //Receive the username through Segue
    var getusername: String = ""
   
    
    //Receive the user email through a segue
    var receiverStr: String = ""
    
    //Receive the course name through a segue
    var nameString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = "Welcome  " + getusername
        userNameSettings =   getusername
        print(getusername)
        title = "Golf Courses"
        CourseName.text = "" + nameString
        CourseName.font = .boldSystemFont(ofSize: 15)
        
        //Database
         dbQueue = try? getDatabaseQueue()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    @IBAction func ClickGo(_ sender: UIButton) {

        let golfers: [myGolfer] = try! dbQueue!.read { db in
            try myGolfer.fetchAll(db)
        }
        let courses: [Course] = try! dbQueue!.read { db in
                try Course.fetchAll(db)
               
            }
        
        
      

    }
    
    
    
    
    //Database
    
    private func getDatabaseQueue() throws -> DatabaseQueue{
        let fileManager = FileManager.default
        
        let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("GCA_Database.db").path
    
       
        print(dbPath)
        if !fileManager.fileExists(atPath: dbPath)
        {
            let dbResourcePath = Bundle.main.path(forResource: "GCA_Database", ofType: "db")!
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        
        return try DatabaseQueue(path: dbPath)
    }
    

  
}

