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
import GRDB

private var dbQueue: DatabaseQueue?
var mapView = GMSMapView()

//To switch between yards and meters
var myUnits: Int = 0

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    // testing frame size stuff
        let frameHeight = UIScreen.main.bounds.height
        let frameWidth = UIScreen.main.bounds.width
        var svar: Int = 0;
        //Unit variables
        var mynewhole: Double = 0
        var mynewpin: Double = 0
        
        @IBOutlet var getLocButton: UIButton!
        @IBOutlet var latitudeLabel: UILabel!
        @IBOutlet var longitudeLabel: UILabel!
        
        // class variables
        var holeNum: Int = 0
        var teeNum: Int = 0
        var holePar: Int = 0
        var holeYards: Int = 0
        var lat: Double = 0.0
        var long: Double = 0.0
        var userLat: Double = 0.0
        var userLong: Double = 0.0
        var teeLat: Double = 0.0
        var teeLong: Double = 0.0
        var yardsToPin: Int = 0
        var bearingDegrees: Double = 0.0
        var courseName: String = ""
        var myString: String = ""
        var receiverStr: String = ""
        var nameString: String = ""
        var holeid: Int = 0;
        
        
        // structs instances
        var courseMetaClassStruct: CourseMeta?
        var courseScorecardClassStruct: CourseScorecard?
        var courseDataClassStruct: CourseData?
        
        // location manager instance
        let locationManager = CLLocationManager()
    
    override func viewDidLoad()
        {
            
            // fetches data from Golfbert API and fills data structs
            fetchData()
            sleep(1)
            lat = (courseDataClassStruct?.resources[holeNum])!.flagcoords.lat
            long = (courseDataClassStruct?.resources[holeNum])!.flagcoords.long
            holePar = (courseScorecardClassStruct?.holeteeboxes[teeNum].par)!
            holeYards = (courseScorecardClassStruct?.holeteeboxes[teeNum].length)!
            print("flag lat \(lat)")
            print("flag long \(long)")
        
            super.viewDidLoad()
            
            //begin location manager
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
            //Database
             dbQueue = try? getDatabaseQueue()
        
            
            
            // first time getting distance to pin
            let coordinate1 = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let coordinate2 = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
            yardsToPin = distanceInYards(from: coordinate1, to: coordinate2)
            // this is some crazy bad code i should update - fetch takes a moment so i need to wait before
            print("This is where i am.")
            print((courseDataClassStruct?.resources[0].rotation)!)
            // loads map view and all components on top of it
        
            loadMapView()
            LoadDBView()
            
            let circleSize: CGFloat = 20
            let spacing: CGFloat = 10
            let startY: CGFloat = 200

            // Define the circle colors and labels
            let circleColors: [CGColor] = [UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.gray.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor]
            let labels: [String] = ["Eagle", "Birdie", "Par", "Bogey", "Bogey+"]

            // Loop through each circle and create a shape layer and label
            for i in 0..<circleColors.count {
                // Create the shape layer
                let circleLayer = CAShapeLayer()
                circleLayer.path = UIBezierPath(ovalIn: CGRect(x: view.bounds.width - circleSize - spacing,
                                                               y: startY + CGFloat(i) * (circleSize + spacing),
                                                               width: circleSize,
                                                               height: circleSize)).cgPath
                circleLayer.fillColor = circleColors[i]
                view.layer.addSublayer(circleLayer)
                
                // Create the label
                let label = UILabel(frame: CGRect(x: view.bounds.width - circleSize - spacing * 2 - 100,
                                                  y: startY + CGFloat(i) * (circleSize + spacing),
                                                  width: 100,
                                                  height: circleSize))
                label.text = labels[i]
                label.textColor = .white
                label.textAlignment = .right
                view.addSubview(label)
            }
        }
    
    
    
    func displayHoleShots(){
            print("Hi")
            print(holeNum)
            //Pull all the Userid's from the database and add it to mychecklist
            try! dbQueue!.read { db in
                let rows = try Row.fetchAll(db, sql: "SELECT * FROM GroupShotLocations WHERE course_id = 13607 AND hole = \(holeNum+1)")
                    for row in rows{
                        let responseLat: String = row["lat"]
                        let responseLong: String = row["long"]
                        let responsePar: Int = row["par"]
                        
                        let recordedPar = responsePar
                        let recordedLat = Double(responseLat)!
                        let recordedLong = Double(responseLong)!
                        print(recordedLat)
                        print(recordedLong)
                        print(recordedPar)
                        
                        
                        var recordedCoord = CLLocationCoordinate2D(latitude: recordedLat, longitude: recordedLong)
                        
                        if(recordedPar < holePar){
                            // place blue marker
                            let shotMarker = GMSMarker(position: recordedCoord)
                            shotMarker.icon = GMSMarker.markerImage(with: .blue)
                            shotMarker.map = mapView

                        }
                        else if(recordedPar == holePar){
                            // place green marker
                            let shotMarker = GMSMarker(position: recordedCoord)
                            shotMarker.icon = GMSMarker.markerImage(with: .green)
                            shotMarker.map = mapView
                            
                            
                        }
                        else if(recordedPar == holePar+1){
                            // place yellow marker
                            let shotMarker = GMSMarker(position: recordedCoord)
                            shotMarker.icon = GMSMarker.markerImage(with: .white)
                            shotMarker.map = mapView
                        }
                        else if(recordedPar == holePar+2){
                            // place orange marker
                            let shotMarker = GMSMarker(position: recordedCoord)
                            shotMarker.icon = GMSMarker.markerImage(with: .orange)
                            shotMarker.map = mapView
                        }
                        else{
                            // place red marker
                            let shotMarker = GMSMarker(position: recordedCoord)
                            shotMarker.icon = GMSMarker.markerImage(with: .red)
                            shotMarker.map = mapView
                        }
                        
                        
                        print(responseLat)
                        print("----------------")
                        print(responseLong)
                        
                        
                        
                    }
              }
        }
    
    func sendToDB(){
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        // creates random par that the user scored. obviously we need to change this.
        let parShot = Int.random(in: 3...7)

        
        
            do {
                try dbQueue!.write { db in
                    try db.execute(
                        //sql: "INSERT INTO Feedback (Userid, CourseID, holeID, comment) VALUES (?, ?, ?, ?)",
                        //arguments: [-1, -1, -1, "Testing database"])
                        
                        
                        sql: "INSERT INTO GroupShotLocations (course_id, user_id, date, lat, long, par, hole) VALUES (?, ?, ?, ?, ?, ?, ?)",
                        arguments: [courseID, MyUserid, dateString, String(userLat), String(userLong), parShot, holeNum+1])
                    }
            } catch {
                
                print(error)
            }
             
        }
    

    func LoadDBView()
    {
        
        try? dbQueue?.write { db in
            try Hole(CourseID: courseID, holeID: holeid, Holenumber: holeNum, flagLat: lat, flagLong: long).insert(db);
            print("Course data is in dB!!!")
            
        }
        
       
    }
    
    
    //Database
    private func getDatabaseQueue() throws -> DatabaseQueue{
        let fileManager = FileManager.default
        
        let dbPath = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("GCA_Database.db").path
    
       
        print(dbPath)
        if !fileManager.fileExists(atPath: dbPath)
        {
            let dbResourcePath = Bundle.main.path(forResource: "GCA_Database", ofType: "db")!
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
        
        return try DatabaseQueue(path: dbPath)
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            userLat = location.coordinate.latitude
            userLong = location.coordinate.longitude
            let coordinate1 = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let coordinate2 = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
            
            yardsToPin = distanceInYards(from: coordinate1, to: coordinate2)
            createThreeLabels()
           // distanceToPinLabel()
            //print("------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }
    
    // loads the map every update
       func loadMap() {
           // Making the map
           var flagPosition = CLLocationCoordinate2D(latitude: lat, longitude: long)
           let flagMarker = GMSMarker(position: flagPosition)
           flagMarker.icon = GMSMarker.markerImage(with: .brown)
           var teePosition = CLLocationCoordinate2D(latitude: teeLat, longitude: teeLong)
           let teeMarker = GMSMarker(position: teePosition)
           teeMarker.icon = GMSMarker.markerImage(with: .blue)
           let camera = GMSCameraPosition(
               target: flagPosition,
               zoom: 18,
               bearing: bearingDegrees,
               viewingAngle: 0
           )
           mapView = GMSMapView(frame: self.view.bounds, camera: camera)
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
        sendToDB()
        print("Button Pressed")
    }
    @objc func StatsButtonAction(button: UIButton)
    {
        displayHoleShots()
    }
    
    
    

    
    func createSettingsButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: frameWidth - 45, y: 90, width: 25, height: 25)
        button.configuration = .plain()
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
        left: 20,
          bottom: 10,
          right: 20
          )
        let customButtonTitle = NSMutableAttributedString(string: "", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            //NSAttributedString.Key.backgroundColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        button.configuration?.baseForegroundColor = .white
        button.configuration?.image = UIImage(systemName: "slider.horizontal.3")
        button.setAttributedTitle(customButtonTitle, for: .normal)
        
        button.addTarget(self, action: #selector(SettingsbuttonAction), for: .touchUpInside)
        self.view.addSubview(button)
       
       
    }
 
   
    func createStatisticsButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: frameHeight-60, width: 150, height: 60)
        button.backgroundColor = .white
        button.configuration = .plain()
        button.setTitle("Show Statistics", for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(
          top: 10,
          left: 20,
          bottom: 10,
          right: 20
          )
        let customButtonTitle = NSMutableAttributedString(string: "Show Stats", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.systemTeal
        ])
        button.configuration?.baseForegroundColor = .systemTeal
        button.configuration?.image = UIImage(systemName: "chart.bar")
        button.setAttributedTitle(customButtonTitle, for: .normal)
        
        button.addTarget(self, action: #selector(StatsButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
       
       
    }
    
   
    func createNextAndPrevious(){
        let prevButton = UIButton(type: .system)
                prevButton.setTitle("Previous", for: .normal)
                prevButton.configuration = .plain()
                prevButton.configuration?.baseForegroundColor = .white
        let customButtonTitle = NSMutableAttributedString(string: "Previous", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
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
        button.setTitle("Mark Shot", for: .normal)
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
        if (myUnits == 1)
        {
            mynewhole = Double(holeYards)*0.9144  //ADD
            lbl3.text = "Meters: \(Int(mynewhole))"
        }
        else if (myUnits == 0)
        {
            lbl3.text = "Yardage: \(holeYards)"
        }
       
       
        lbl3.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl3)
        
        
        let lbl4 = UILabel()
        lbl4.backgroundColor = .white
        lbl4.font = UIFont.boldSystemFont(ofSize: 20)
        lbl4.textColor = UIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1.0)
        if (myUnits == 1)
        {
            mynewpin = Double(yardsToPin)*0.9144  //ADD
           
            lbl4.text = "\(Int(mynewpin)) meters to pin"
        }
        else if (myUnits == 0)
        {
            lbl4.text = "\(yardsToPin) yards to pin"
        }
        
        lbl4.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl4)

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
            lbl3.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            // Set the top constraint of lbl4 to the bottom anchor of lbl3 with 8 points of padding
            lbl4.topAnchor.constraint(equalTo: lbl3.bottomAnchor, constant: 8),
            // Set the leading constraint of lbl4 to the leading anchor of the safe area with 8 points of padding
            lbl4.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
             
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
           destController.getholeid = self.holeid
        }
    }
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    // button to go backwards
        @objc func prevButtonTapped() {
            // Do something when the "Previous" button is tapped
            if (holeNum > 0){
                holeNum -= 1
                teeNum -= 4 // skip passed the rest of the tees
                
                teeLat = (courseDataClassStruct?.resources[holeNum])!.vectors[2].lat
                teeLong = (courseDataClassStruct?.resources[holeNum])!.vectors[2].long
                
                holePar = (courseScorecardClassStruct?.holeteeboxes[teeNum].par)!
                holeYards = (courseScorecardClassStruct?.holeteeboxes[teeNum].length)!
                bearingDegrees = rad2deg((courseDataClassStruct?.resources[holeNum])!.rotation)
                lat = (courseDataClassStruct?.resources[holeNum])!.flagcoords.lat
                long = (courseDataClassStruct?.resources[holeNum])!.flagcoords.long
                
                loadMapView()
                viewDidLoad()
            }
        }

    // button to go forward
        @objc func nextButtonTapped(){
            // Do something when the "Next" button is tapped
            // missing the last hole!!! doing some arithmetic wrong somewhere
            if (holeNum < 17 ){
                holeNum += 1
                teeNum += 4// skip passed the rest of the tees
                teeLat = (courseDataClassStruct?.resources[holeNum])!.vectors[2].lat
                teeLong = (courseDataClassStruct?.resources[holeNum])!.vectors[2].long
                holePar = (courseScorecardClassStruct?.holeteeboxes[teeNum].par)!
                holeYards = (courseScorecardClassStruct?.holeteeboxes[teeNum].length)!
                bearingDegrees = rad2deg((courseDataClassStruct?.resources[holeNum])!.rotation)
                lat = (courseDataClassStruct?.resources[holeNum])!.flagcoords.lat
                long = (courseDataClassStruct?.resources[holeNum])!.flagcoords.long
                loadMapView()
                viewDidLoad()
                
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
            let A_Key: String = "AKIAY4WGH3URC5UYE24U"
            let S_Key: String = "DYrgt+5aHCG33SfMiYEO8ny7NsRVGHNkcIx2Y9x7"
            let X_API_KEY: String = "xZsYxHwK7L9eiYeSzhBzf8svKqjOwwrUauEOKOKH"
            let courseMetaURL: String = "https://api.golfbert.com/v1/courses/13607/holes"
            let courseScorecardURL: String = "https://api.golfbert.com/v1/courses/13607/scorecard"
            let courseDataURL: String = "https://api.golfbert.com/v1/courses/13607/holes"
            
            
            // -------------------------------  START Fetching meta data -------------------------------
            let credentials = StaticCredential(accessKeyId: A_Key, secretAccessKey: S_Key)
            let signer = AWSSigner(credentials: credentials, name: "execute-api", region: "us-east-1")
            var signedURL = signer.signURL(
                url: URL(string: courseMetaURL)!,
                method: .GET)
            
            var request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
            request.addValue(X_API_KEY, forHTTPHeaderField: "x-api-key")
            
            request.httpMethod = "GET"
            
            var task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                //rint(String(data: data, encoding: .utf8)!)
                let courseMetaResponse = try? JSONDecoder().decode(CourseMeta.self, from: data)
                self.courseMetaClassStruct = courseMetaResponse
            }
            task.resume()
            // -------------------------------  END Fetching meta data -------------------------------
            
            
            // -------------------------------  START Fetching scorecard data -------------------------------
            signedURL = signer.signURL(
                url: URL(string:courseScorecardURL)!,
                method: .GET)
            request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
            request.addValue(X_API_KEY, forHTTPHeaderField: "x-api-key")
            
            request.httpMethod = "GET"
            
            task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                //rint(String(data: data, encoding: .utf8)!)
                let courseScorecardResponse = try? JSONDecoder().decode(CourseScorecard.self, from: data)
                self.courseScorecardClassStruct = courseScorecardResponse
            }
            task.resume()
            // -------------------------------  END Fetching scorecard data -------------------------------
            
            // -------------------------------  START Fetching actual data -------------------------------
            signedURL = signer.signURL(
                url: URL(string:courseDataURL)!,
                method: .GET)
            request = URLRequest(url: signedURL, timeoutInterval: Double.infinity)
            request.addValue(X_API_KEY, forHTTPHeaderField: "x-api-key")
            request.httpMethod = "GET"
            task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                let courseDataResponse = try? JSONDecoder().decode(CourseData.self, from: data)
                self.courseDataClassStruct = courseDataResponse
                self.holeid = (self.courseDataClassStruct?.resources[self.holeNum].id)!
                print("Holeid is \(self.holeid)")
                print("Hole number is \(self.holeNum)")
            
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
        createStatisticsButton()
        createThreeLabels()
       // distanceToPinLabel()
    }
}
