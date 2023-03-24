//
//  SearchViewController.swift
//  iOS UIKit Login
//
//  Created by Cara du Preez on 1/29/23.
//

import UIKit
import MapKit
import AWSSigner
import CoreLocation



// var for testing fetching for a specific hole. Hardcoded data for hole number
var holeNum: Int = 0
// tee number - different from hole # as 4 tees per hole so need to incremement by 4 to get to next holes tees.
// can explain if need to
var teeNum: Int = 0
var holePar: Int = 0
var holeYards: Int = 0

// flag coordinates
var lat: Double = 0.0
var long: Double = 0.0

// tee coordinates
var teeLat: Double = 0.0
var teeLong: Double = 0.0

// for angle of rotation for each hole
var bearingDegrees: Double = 0.0

// testing CGRect for map boundaries
var northEastCorner: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
var southWestCorner: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

// instances of structs
var courseScorecard: CourseScorecard?
var courseMeta: CourseMeta?
var courseData: CourseData?

var rectT: CGRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
var courseName: String = ""



class SearchViewController : UIViewController, CLLocationManagerDelegate //, UISearchResultsUpdating
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
        
        // fetches data from Golfbert API and fills data structs
        fetchData()
        
        
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
    
    
    
    
   /*func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty ,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController
        else{
            return
        }
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query){ result in
            switch result{
            case .success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    */
}
    
    
     /*extension SearchViewController: SearchResultsViewControllerDelegate{
        func didTapPlace(with coordinates: CLLocationCoordinate2D){
            searchVC.searchBar.resignFirstResponder()
            searchVC.dismiss(animated: true, completion: nil)
            
            let annotations = mapView.annotations
            mapView.removeAnnotations(annotations)
            let pin = MKPointAnnotation()
            pin.coordinate = coordinates
            mapView.addAnnotation(pin)
            mapView.setRegion(
                MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(
                latitudeDelta: 0.2,
                longitudeDelta: 0.2
                    )),
                animated: true
            )
        }
    
    }

     */
    
    // used to convert rad to deg for bearing variable
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }





func fetchData(){
    // -------------------------------  START Fetching scorecard data -------------------------------
    let credentials = StaticCredential(accessKeyId: "AKIAY4WGH3URC5UYE24U", secretAccessKey: "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")
    let signer = AWSSigner(credentials: credentials, name: "execute-api", region: "us-east-1")
    var signedURL = signer.signURL(
        url: URL(string:"https://api.golfbert.com/v1/courses/13028/holes")!,
        method: .GET)
    
    var request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
    request.addValue("xZsYxHwK7L9eiYeSzhBzf8svKqjOwwrUauEOKOKH", forHTTPHeaderField: "x-api-key")
    
    request.httpMethod = "GET"
    
    var task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
        }
        print(String(data: data, encoding: .utf8)!)
        
        guard let courseDataResponse = try? JSONDecoder().decode(CourseData.self, from: data) else {
            print("Error decoding course meta data")
            return
        }
        
        print("hi")
        print(courseDataResponse.resources[0].rotation)
        courseData = courseDataResponse // assign the decoded courseMetaResponse to the global variable
    }
    task.resume()
    
}
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
