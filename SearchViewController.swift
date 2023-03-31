//
//  SearchViewController.swift
//  iOS UIKit Login
//
//  Created by Cara du Preez on 1/29/23.
//

import UIKit

class SearchViewController : UIViewController
{
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
        userName.text = "Hello " + receiverStr
        CourseName.text = "" + nameString
        CourseName.font = .boldSystemFont(ofSize: 15)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }

}
