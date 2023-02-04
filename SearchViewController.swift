//
//  SearchViewController.swift
//  iOS UIKit Login
//
//  Created by Cara du Preez on 1/29/23.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    var receiverStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = "Hello " + receiverStr
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
