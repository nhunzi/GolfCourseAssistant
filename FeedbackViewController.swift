//
//  FeedbackViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit

class FeedbackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FeedbackTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedbackTable.delegate = self
        FeedbackTable.dataSource = self

        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellfeedback = tableView.dequeueReusableCell(withIdentifier: "cellfeedback", for: indexPath)
        cellfeedback.textLabel?.text = "Feedback"
        return cellfeedback
    }

}
