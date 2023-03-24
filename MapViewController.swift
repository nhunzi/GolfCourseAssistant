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
import MapKit

// testing frame size stuff
let frameHeight = UIScreen.main.bounds.height
let frameWidth = UIScreen.main.bounds.width
var svar: Int = 0;


// user coordinates
var userLat: Double = 0.0
var userLong: Double = 0.0

// yards to the pin, obviously
var yardsToPin: Int = 0


class MapViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet var getLocButton: UIButton!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //begin location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // first time getting distance to pin
        let coordinate1 = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let coordinate2 = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
        yardsToPin = distanceInYards(from: coordinate1, to: coordinate2)
    
        // fetches data from Golfbert API and fills data structs
        fetchData()
        // loads map view and all components on top of it
        loadMapView()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            userLat = location.coordinate.latitude
            userLong = location.coordinate.longitude
            let coordinate1 = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let coordinate2 = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
            
            yardsToPin = distanceInYards(from: coordinate1, to: coordinate2)
            distanceToPinLabel()
            //print("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }
    
    // loads the map every update
    func loadMap() {
        // Making the map
        var flagPosition = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let flagMarker = GMSMarker(position: flagPosition)
        var teePosition = CLLocationCoordinate2D(latitude: teeLat, longitude: teeLong)
        let teeMarker = GMSMarker(position: teePosition)
        teeMarker.icon = GMSMarker.markerImage(with: .blue)
        let camera = GMSCameraPosition(
            target: flagPosition,
            zoom: 18,
            bearing: bearingDegrees,
            viewingAngle: 0
        )
        var mapView = GMSMapView(frame: self.view.bounds, camera: camera)
            //this will eventually be used to change icon to flag....but the sizing is off and needs fixing
            //flagMarker.icon = UIImage(named: "flag")
            flagMarker.map = mapView
            //teeMarker.map = mapView
            mapView.settings.scrollGestures = true
            // commenting out because the accuracy is shit 
            //mapView.settings.zoomGestures = true
            self.view = mapView
            mapView.mapType = .satellite
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
        print("Button Pressed")
    }

    func createSettingsButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: frameHeight-60, width: 120, height: 60)
        button.backgroundColor = .white
        button.configuration = .plain()
        button.setTitle("Settings", for: .normal)
      //  button.setAttributedTitle(attributedString, for: .normal)
       // button.configuration?.image = UIImage(systemName: "figure.golf")
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
        let customButtonTitle = NSMutableAttributedString(string: "Settings", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
            //NSAttributedString.Key.backgroundColor: UIColor.red,
            NSAttributedString.Key.foregroundColor: UIColor.systemTeal
        ])
        button.configuration?.baseForegroundColor = .systemTeal
        button.configuration?.image = UIImage(systemName: "house.circle")
        button.setAttributedTitle(customButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(SettingsbuttonAction), for: .touchUpInside)
        self.view.addSubview(button)
       
       
    }
    
    func createNextAndPrevious(){
        let prevButton = UIButton(type: .system)
                prevButton.setTitle("Previous", for: .normal)
                //prevButton.frame = CGRect(x: 0, y: frameHeight-60, width: 120, height: 60)
               // prevButton.backgroundColor = .white
                prevButton.configuration = .plain()
                prevButton.configuration?.baseForegroundColor = .white
        let customButtonTitle = NSMutableAttributedString(string: "Previous", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            //NSAttributedString.Key.backgroundColor: UIColor.red,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
             prevButton.setAttributedTitle(customButtonTitle, for: .normal)
                prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
                prevButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(prevButton)

                NSLayoutConstraint.activate([
                    prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
                ])

                let nextButton = UIButton(type: .system)
                nextButton.setTitle("Next", for: .normal)
                nextButton.configuration = .plain()
                nextButton.configuration?.baseForegroundColor = .white
               let customButtonTitleNext = NSMutableAttributedString(string: "Next", attributes: [
               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
               NSAttributedString.Key.foregroundColor: UIColor.white
        ])
             nextButton.setAttributedTitle(customButtonTitleNext, for: .normal)
                nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
                nextButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(nextButton)

                NSLayoutConstraint.activate([
                    nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
                ])
    }
    
    
    func createEmptyButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: frameWidth/2 - 87, y: frameHeight-60, width: 175, height: 60)
        button.backgroundColor = .white
        button.setTitle("Hole \(holeNum+1)", for: .normal)
        button.layer.cornerRadius = 8
        button.configuration = .plain()
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
       
        button.configuration?.image = UIImage(systemName: "figure.golf")
        button.addTarget(self, action: #selector(EmptybuttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
       
    }
    
    func createThreeLabels() {
        let lbl1 = UILabel()
        lbl1.backgroundColor = .white
        lbl1.font = UIFont.boldSystemFont(ofSize: 20)
        lbl1.textColor = UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1.0)
        lbl1.text = "Hole Number: \(holeNum+1)"
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl1)

        let lbl2 = UILabel()
        lbl2.backgroundColor = .white
        lbl2.font = UIFont.boldSystemFont(ofSize: 20)
        lbl2.textColor = UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1.0)
        lbl2.text = "Par: \(holePar)"
        lbl2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl2)

        let lbl3 = UILabel()
        lbl3.backgroundColor = .white
        lbl3.font = UIFont.boldSystemFont(ofSize: 20)
        lbl3.textColor = UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1.0)
        lbl3.text = "Yardage: \(holeYards)"
        lbl3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl3)

        NSLayoutConstraint.activate([
            // Set the top constraint of lbl1 to the top anchor of the safe area with 8 points of padding
            lbl1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            // Set the leading constraint of lbl1 to the leading anchor of the safe area with 8 points of padding
            lbl1.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),

            // Set the top constraint of lbl2 to the bottom anchor of lbl1 with 8 points of padding
            lbl2.topAnchor.constraint(equalTo: lbl1.bottomAnchor, constant: 8),
            // Set the leading constraint of lbl2 to the leading anchor of the safe area with 8 points of padding
            lbl2.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),

            // Set the top constraint of lbl3 to the bottom anchor of lbl2 with 8 points of padding
            lbl3.topAnchor.constraint(equalTo: lbl2.bottomAnchor, constant: 8),
            // Set the leading constraint of lbl3 to the leading anchor of the safe area with 8 points of padding
            lbl3.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
    }
    
    func distanceToPinLabel() {
        let lbl1 = UILabel()
        lbl1.backgroundColor = .white
        lbl1.font = UIFont.boldSystemFont(ofSize: 20)
        lbl1.textColor = UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1.0)
        lbl1.text = "\(yardsToPin) yards to pin"
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl1)


        NSLayoutConstraint.activate([
            // Set the top constraint of lbl1 to the top anchor of the safe area with 8 points of padding
            lbl1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            // Set the trailing constraint of lbl1 to the trailing anchor of the safe area with 8 points of padding
            lbl1.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
        ])
    }

    
    func createFeedbackButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: frameWidth-120, y: frameHeight-60, width: 130, height: 60)
        button.backgroundColor = .white
        button.configuration = .plain()
        button.setTitle("Feedback", for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
       
        let customButtonTitle = NSMutableAttributedString(string: "Feedback", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13),
            //NSAttributedString.Key.backgroundColor: UIColor.red,
            NSAttributedString.Key.foregroundColor: UIColor.purple
        ])
        button.configuration?.baseForegroundColor = .purple
        button.configuration?.image = UIImage(systemName: "quote.bubble")
        button.setAttributedTitle(customButtonTitle, for: .normal)
    
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
    
    
    // button to go backwards
    @objc func prevButtonTapped() {
        // Do something when the "Previous" button is tapped
        if (holeNum > 0){
            holeNum -= 1
            teeNum -= 4 // skip passed the rest of the tees
            
            teeLat = (courseData?.resources[holeNum])!.vectors[2].lat
            teeLong = (courseData?.resources[holeNum])!.vectors[2].long
            
            holePar = (courseScorecard?.holeteeboxes[teeNum].par)!
            holeYards = (courseScorecard?.holeteeboxes[teeNum].length)!
            bearingDegrees = rad2deg((courseData?.resources[holeNum])!.rotation)
            lat = (courseData?.resources[holeNum])!.flagcoords.lat
            long = (courseData?.resources[holeNum])!.flagcoords.long
            loadMapView()
        }
    }

    // button to go forward
    @objc func nextButtonTapped(){
        // Do something when the "Next" button is tapped
        // missing the last hole!!! doing some arithmetic wrong somewhere
        if (holeNum < 17 ){
            print(holeNum)
            holeNum += 1
            teeNum += 4// skip passed the rest of the tees
            
            teeLat = (courseData?.resources[holeNum])!.vectors[2].lat
            teeLong = (courseData?.resources[holeNum])!.vectors[2].long
            
            print("HERE --------------------------------")
            print(teeLat)
            print(teeLong)
            
            holePar = (courseScorecard?.holeteeboxes[teeNum].par)!
            holeYards = (courseScorecard?.holeteeboxes[teeNum].length)!
            bearingDegrees = rad2deg((courseData?.resources[holeNum])!.rotation)
            lat = (courseData?.resources[holeNum])!.flagcoords.lat
            long = (courseData?.resources[holeNum])!.flagcoords.long
            loadMapView()
        }
    }
    
    func distanceInYards(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Int {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        let distanceInMeters = fromLocation.distance(from: toLocation)
        let distanceInYards = distanceInMeters * 1.09361
        
        return Int(distanceInYards)
    }
    
    func fetchData(){
        // -------------------------------  START Fetching meta data -------------------------------
        let credentials = StaticCredential(accessKeyId: "AKIAY4WGH3URC5UYE24U", secretAccessKey: "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")
        let signer = AWSSigner(credentials: credentials, name: "execute-api", region: "us-east-1")
        var signedURL = signer.signURL(
            url: URL(string:"https://api.golfbert.com/v1/courses/13028")!,
            method: .GET)
        
        var request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
        request.addValue("xZsYxHwK7L9eiYeSzhBzf8svKqjOwwrUauEOKOKH", forHTTPHeaderField: "x-api-key")
        
        request.httpMethod = "GET"
        
        var task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            //rint(String(data: data, encoding: .utf8)!)
            let courseMetaResponse = try? JSONDecoder().decode(CourseMeta.self, from: data)
            courseMeta = courseMetaResponse
            print("!!!!!!!!!!!! course name: \((courseMeta?.id)!))")
        }
        task.resume()
        // -------------------------------  END Fetching meta data -------------------------------
        
        
        // -------------------------------  START Fetching actual data -------------------------------
        signedURL = signer.signURL(
            url: URL(string:"https://api.golfbert.com/v1/courses/13028/holes")!,
            method: .GET)
        request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
        request.addValue("xZsYxHwK7L9eiYeSzhBzf8svKqjOwwrUauEOKOKH", forHTTPHeaderField: "x-api-key")
        
        request.httpMethod = "GET"
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            //rint(String(data: data, encoding: .utf8)!)
            let courseDataResponse = try? JSONDecoder().decode(CourseData.self, from: data)
            courseData = courseDataResponse
        }
        task.resume()
        // -------------------------------  END Fetching meta data -------------------------------
    }
    
    
    // function loads the map + other view components sitting on top of the map
    func loadMapView(){
        loadMap()
        createNextAndPrevious()
        createSettingsButton()
        createFeedbackButton()
        createEmptyButton()
        createThreeLabels()
        distanceToPinLabel()
    }
    
}


