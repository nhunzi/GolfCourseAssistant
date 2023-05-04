//
//  FeedbackViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit
import GRDB

var myFeedback: [String] = []
var myComment: String = ""
var mycomments: [String] = []
class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var dbQueue: DatabaseQueue?
    
    var getholeid: Int = 0
    var time: [String] = []
    
    @IBOutlet weak var FeedbackTable: UITableView!
    @IBOutlet weak var CommentBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Database
         dbQueue = try? getDatabaseQueue()
        
    
        FeedbackTable.delegate = self
        FeedbackTable.dataSource = self
       
        //Adds the comments to theh database and to the Array mycomments
        addCommentData()
        
    }
    
    
    func addCommentData()
    {
        
        mycomments.removeAll()
        //Read the comments into the Feedback Table, each user, 1 comment per hole
         try? dbQueue?.read { db in
             let rows = try Row.fetchAll(db, sql: "SELECT Comment, Date FROM Feedback WHERE holeID = ?", arguments: [getholeid])
             for row in rows {
                 let comment: String  = row["Comment"]
                 let mytime: String = row["Date"]
                 print(comment)
                 mycomments.append(comment)
                 time.append(mytime)
             }
             
                 
         }
        print(mycomments)
        print(time)
        
        
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
    
    
    @IBAction func PostComment(_ sender: UIButton) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: Date())
        
        
        myFeedback.append(CommentBox.text)
        myComment = CommentBox.text
        print(myFeedback)
        CommentBox.text = ""
        
        try? dbQueue?.write { db in
            try Feedback(Userid: MyUserid, CourseID: courseID, holeID: getholeid, Comment: myComment, Date: dateString).insert(db);
        }
        
        addCommentData()
        FeedbackTable.reloadData()
       
        
    }
    
    
   
    //Customize cell size
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 50 //height
        } else {
            return 50//width
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mycomments.count
        //return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
    
        
        let cellfeedback = tableView.dequeueReusableCell(withIdentifier: "cellfeedback", for: indexPath)
        
        cellfeedback.textLabel?.text = mycomments[indexPath.row]
        cellfeedback.textLabel?.font = .systemFont(ofSize: 17)
        cellfeedback.textLabel?.textAlignment = .left
        cellfeedback.textLabel?.numberOfLines = 2
        
        // Create a UILabel for the time and set its properties
        let timeLabel = UILabel(frame: CGRect(x: cellfeedback.frame.width - 1, y: 0, width: -110, height: cellfeedback.frame.height))
        timeLabel.textAlignment = .right
        timeLabel.textColor = .gray
        timeLabel.font = UIFont.systemFont(ofSize: 9)
        timeLabel.text = time[indexPath.row]
        
        // Add the timeLabel as a subview of the cell's contentView
          cellfeedback.contentView.addSubview(timeLabel)
        
        return cellfeedback
    }
    
    //----------NEW CODE
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            //myFeedback.remove(at: indexPath.row)
            let myIndex = indexPath.row
            let myComm = mycomments[myIndex]
            
            try? dbQueue?.write{ db in
                try db.execute(sql: "DELETE from Feedback WHERE Comment = ?", arguments: [myComm])
             
            }
             
             mycomments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }

}
