//
//  FeedbackViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit
import GRDB


//var myFeedback: [String] = ["Watch out for the left bunker near the green.", "Stay below the pin! There is water damage above the hole.", "Watch out for the steep slope at the green."]
var myFeedback: [String] = []
var myComment: String = ""
class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Database
   // private var players: [Player] = []
    private var dbQueue: DatabaseQueue?
    
    var getholeid: Int = 0
    
    @IBOutlet weak var FeedbackTable: UITableView!
    @IBOutlet weak var CommentBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Database
         dbQueue = try? getDatabaseQueue()
        
    
        FeedbackTable.delegate = self
        FeedbackTable.dataSource = self
        
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
    
    /*
    private func loadAllData()
    {
        players = []
        try? dbQueue?.read { db in
            let rows = try Row.fetchAll (db, sql: "SELECT UserID, UserName, Email FROM Player ORDER BY UserName")
            for row in rows {
                players.append(Player (userID: row[0], userName: row[1], userEmail: row[2]))
                FeedbackTable.reloadData ()
            }
        }
    }
  
    */
    
    
    @IBAction func PostComment(_ sender: UIButton) {
        
        myFeedback.append(CommentBox.text)
        myComment = CommentBox.text
        print(myFeedback)
        CommentBox.text = ""
        
        try? dbQueue?.write { db in
            try Feedback(Userid: MyUserid, CourseID: courseID, holeID: getholeid, Comment: myComment).insert(db);
        }
        
          //  loadAllData()
        }
    
    
    
    
    
    @IBAction func ReadBtn(_ sender: UIButton) {
        
       //Read the comments into the Feedback Table, each user, 1 comment per hole
        try? dbQueue?.read { db in
            if let row = try Row.fetchOne(db, sql: "SELECT Comment FROM Feedback WHERE holeID = ?", arguments: [getholeid]) {
                let comment: String = row["Comment"]
                print(comment)
            }
            print("Comments!!!")
        }
        
    }
    
    
   
    //Customize cell size
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 70 //height
        } else {
            return 50//width
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeedback.count
        //return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellfeedback = tableView.dequeueReusableCell(withIdentifier: "cellfeedback", for: indexPath)
    
        cellfeedback.textLabel?.text = myFeedback[indexPath.row]
        cellfeedback.textLabel?.font = .systemFont(ofSize: 17)
        cellfeedback.textLabel?.textAlignment = .left
        cellfeedback.textLabel?.numberOfLines = 2
        
        //let player = players[indexPath.row]
       // cell.textLabel.text = player.getName()
       
        return cellfeedback
    }

}