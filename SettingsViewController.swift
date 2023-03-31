//
//  SettingsViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit

class SettingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Feedback"
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
