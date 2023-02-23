//
//  SearchViewController.swift
//  iOS UIKit Login
//
//  Created by Cara du Preez on 1/29/23.
//

import UIKit
import MapKit

class SearchViewController : UIViewController, UISearchResultsUpdating
{
    
    
   
    @IBOutlet weak var userName: UILabel!
    var receiverStr: String = ""
    let mapView =  MKMapView()
    let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        view.addSubview(mapView)
        
        userName.text = "Hello " + receiverStr
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
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
}
    
    extension SearchViewController: SearchResultsViewControllerDelegate{
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
    





/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
