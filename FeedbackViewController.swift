//
//  FeedbackViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit


var myFeedback: [String] = ["Watch out for the left bunker near the green.", "Stay below the pin! There is water damage above the hole.", "Watch out for the steep slope at the green."]
class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FeedbackTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedbackTable.delegate = self
        FeedbackTable.dataSource = self
        
        
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
        
       
        return cellfeedback
    }

}
