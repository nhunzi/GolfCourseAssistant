//
//  SettingsViewController.swift
//  GCALogin
//
//  Created by Cara du Preez on 2/21/23.
//

import UIKit


var myComments: [String] = ["Watch out for the water puddle on the green.", "Hit the ball over the trees from the tee. "]

class SettingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
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
        return myComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = myComments[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 2
        
        
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
