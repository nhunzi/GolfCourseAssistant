//
//  ViewController.swift
//  GCA
//
//  Created by Nick Hunziker on 1/22/23.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AWSSigner

var lat: Double = 0.0
var long: Double = 0.0
let frameHeight = UIScreen.main.bounds.height
let frameWidth = UIScreen.main.bounds.width
var svar: Int = 0;


class MapViewController: UIViewController, CLLocationManagerDelegate //,UITabBarController
{
    
    @IBOutlet weak var Settings: UIButton!
    
    // ------------------------- START Hole Data Struct --------------------------------------
    // MARK: - Course
    struct Course: Codable {
        let resources: [Resource]
    }

    // MARK: - Resource
    struct Resource: Codable {
        let id, number, courseid: Int
        let rotation: Double
        let range: Range
        let dimensions: Dimensions
        let vectors: [Vector]
        let flagcoords: Flagcoords
    }

    // MARK: - Dimensions
    struct Dimensions: Codable {
        let width, height: Int
    }

    // MARK: - Flagcoords
    struct Flagcoords: Codable {
        let lat, long: Double
    }

    // MARK: - Range
    struct Range: Codable {
        let x, y: X
    }

    // MARK: - X
    struct X: Codable {
        let min, max: Double
    }

    // MARK: - Vector
    struct Vector: Codable {
        let type: TypeEnum
        let lat, long: Double
    }

    enum TypeEnum: String, Codable {
        case blue = "Blue"
        case flag = "Flag"
        case red = "Red"
        case white = "White"
        case yellow = "Yellow"
    }
    
    // ------------------------- END Hole Data Struct --------------------------------------
    
    @IBOutlet var getLocButton: UIButton!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad()
    {
        
        
        
        // Fetching the data
        let credentials = StaticCredential(accessKeyId: "AKIAY4WGH3URC5UYE24U", secretAccessKey: "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")
        let signer = AWSSigner(credentials: credentials, name: "execute-api", region: "us-east-1")
        let signedURL = signer.signURL(
            url: URL(string:"https://api.golfbert.com/v1/courses/13607/holes")!,
            method: .GET)
        
        var request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
        request.addValue("xZsYxHwK7L9eiYeSzhBzf8svKqjOwwrUauEOKOKH", forHTTPHeaderField: "x-api-key")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            //rint(String(data: data, encoding: .utf8)!)
            let course = try? JSONDecoder().decode(Course.self, from: data)
            //print("hole one flag coords:\((course?.resources.first)!.flagcoords.lat))")
            lat = (course?.resources.first)!.flagcoords.lat
            long = (course?.resources.first)!.flagcoords.long
            print((course?.resources.first)!.flagcoords.lat)
            print((course?.resources.first)!.flagcoords.long)
        }

        task.resume()
        
        
        
        // Making the map
        let position = CLLocationCoordinate2D(latitude: 40.980249328485, longitude: -73.75963698733936)
        let marker = GMSMarker(position: position)
        let camera = GMSCameraPosition(
            target: position,
            zoom: 18
        )
            let mapView = GMSMapView(frame: self.view.bounds, camera: camera)
            marker.map = mapView
            self.view = mapView
        mapView.mapType = .satellite
        
        super.viewDidLoad()
        createSettingsButton()
        createFeedbackButton()
        createEmptyButton()
        
     
       
    }
    @objc func SettingsbuttonAction(button: UIButton)
    {
        print("button Pressed")
        svar = 5;
        
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    @objc func FeedbackbuttonAction(button: UIButton)
    {
        print("button Pressed")
        svar = 10;
        performSegue(withIdentifier: "FeedbackSegue", sender: self)
    }
    
    @objc func EmptybuttonAction(button: UIButton)
    {
        print("button Pressed")
       // svar = 10;
        //performSegue(withIdentifier: "FeedbackSegue", sender: self)
    }
    
    func createSettingsButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: frameHeight-60, width: 120, height: 60)
        button.backgroundColor = .white
        button.setTitle("Settings", for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
    
        button.addTarget(self, action: #selector(SettingsbuttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
       
    }
    
    func createEmptyButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: frameWidth/2 - 87, y: frameHeight-60, width: 175, height: 60)
        button.backgroundColor = .white
        button.setTitle("Hole 1", for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
    
        button.addTarget(self, action: #selector(EmptybuttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
       
    }
    
    
    
    func createFeedbackButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: frameWidth-120, y: frameHeight-60, width: 120, height: 60)
        button.backgroundColor = .white
        button.setTitle("Feedback", for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
    
        button.addTarget(self, action: #selector(FeedbackbuttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
       
    }
    override func prepare (for segue: UIStoryboardSegue, sender: Any!) {
      super.prepare(for:segue,sender:sender)
       if (svar == 5)
        {
           let destController = segue.destination as! SettingsViewController
       }
       else if (svar == 10)
        {
           let destController = segue.destination as! FeedbackViewController
        }
    }
  
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destController = segue.destination as! SettingsViewController
        //let newDestController = segue.destination as! FeedbackViewController
        //destController.receiverStr = self.userNameLabel.text ?? ""
    }
    
   */
    
    
    
    
    
   
}

