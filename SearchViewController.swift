//
//  SearchViewController.swift
//  iOS UIKit Login
//
//  Created by Cara du Preez on 1/29/23.
//

import UIKit
import SQLite
import GRDB

class SearchViewController : UIViewController
{
    
    
    //Database
private var players: [Player] = []
   private var dbQueue: DatabaseQueue?
    
    
    //Get user email address
    @IBOutlet weak var userName: UILabel!
    //Get the name of the course
    @IBOutlet weak var CourseName: UILabel!
    
    //Receive the user email through a segue
    var receiverStr: String = ""
    
    //Receive the course name through a segue
    var nameString: String = ""
    
    //let mapView =  MKMapView()
    //let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Golf Courses"
        //view.addSubview(mapView)
        //userName.text = "Hello " + receiverStr
        userName.text = "Welcome  " + MyUserName
        CourseName.text = "" + nameString
        CourseName.font = .boldSystemFont(ofSize: 15)
        
        //Database
        dbQueue = try? getDatabaseQueue()
        //print("database path!!!!!!!!!!!!!!!!!!!")
        print(dbQueue)
        //print("!!!!!!!!10!!!!!")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    @IBAction func ClickGo(_ sender: UIButton) {
        /*
         try? dbQueue?.write { db in
         try db.execute(sql: """
         CREATE TABLE Player (
         Userid TEXT PRIMARY KEY ,
         UserName TEXT NOT NULL,
         Email TEXT NOT NULL)
         """)
         try db.execute(
         sql: "INSERT INTO Player (Userid, UserName, Email) VALUES (?, ?, ?)", arguments: [MyUserid, MyUserName, MyEmail])
         print("!!!!!!!!!!!!!!!!!Write into DB!!!!!!!5")
         
         }
         */
        try? dbQueue?.write { db in
            try db.execute(sql: """
                CREATE TABLE Users (
                    Userid TEXT PRIMARY KEY ,
                    UserName TEXT NOT NULL,
                    Email TEXT NOT NULL)
                """)
            
            print("!!!!!!!!!!!!!!!!!Write into DB!!!!!!!2")
            
            try db.execute(
                sql: "INSERT INTO Users (Userid, UserName, Email) VALUES (?, ?, ?)", arguments: ["Userid", "UserName", "Email"])
            print("!!!!!!!!!!!!!!!!!Write into DB!!!!!!!5")
            
        }
        
        try? dbQueue?.write { db in
            try db.execute(sql: "INSERT INTO User (UserID, UserName, Email) VALUES (?, ?, ?)", arguments: ["cara07","caradup","cara07@gmail"])
            
            print("!!!!!mydatabases !!!!!!")
        }
    }
    
    
    @IBAction func GetData(_ sender: UIButton) {
        
        try? dbQueue?.read { db in
            if let row = try Row.fetchOne(db, sql: "SELECT * FROM Player WHERE id = ?", arguments: [1]) {
                let name: String = row["UserName"]
                let email: String = row["Email"]
                print(name, email)
            }
            print("!!!!!!!!!!!!!!!!!Write into DB!!!!!!!10")
            try db.execute(
                literal: "UPDATE Player SET UserName = \(MyUserName) WHERE id = \(1)")
            
            
            
        }
        try? dbQueue?.read { db in
            if let row = try Row.fetchOne(db, sql: "SELECT UserName FROM User") {
                let username: String = row["UserName"]
                print(username)
            }
            
            print("THIS WILL PRINT THE USERNAME HOPEFULLY")
        }

        
        
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

