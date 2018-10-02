//
//  ViewController.swift
//  Hygiene App 2
//
//  Created by Tony Mcdonagh on 20/03/2018.
//  Copyright © 2018 Tony McDonagh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate  {

    //Outlets for linking code to items on the app view
    @IBOutlet weak var searchBox: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var viewMapBtn: UIButton!
    @IBOutlet weak var refreshListBtn: UIButton!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var searchChoice: UISegmentedControl!
    @IBOutlet weak var searchBtn: UIButton!
    
    //Location manager for obtaining user location
    let locationManager = CLLocationManager()
    //Initialising variables
    var allTheRecords = [Place]()
    var current = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calls function to check authorisation
        getAuthorisation()
        
        //calls function when the app loads
        currentLocation()
        //hide search view at load
        searchBox.isHidden = true
        
        //adds custom settings to the display buttons
        viewMapBtn.layer.cornerRadius = 4
        refreshListBtn.layer.cornerRadius = 4
        refreshListBtn.layer.borderWidth = 1
        refreshListBtn.layer.borderColor = UIColor.black.cgColor
        searchBtn.layer.cornerRadius = 4
        searchChoice.layer.cornerRadius = 4
    }
    
    //returns number of rows to match the list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTheRecords.count
    }
    //handles the data to be displayed in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let col3 = UIColor.green
        let col2 = UIColor.orange
        let col1 = UIColor.red
        let colE = UIColor.lightGray
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = allTheRecords[indexPath.row].BusinessName
        let rating = allTheRecords[indexPath.row].RatingValue!
        //alters output of exempt busineses
        if rating == "-1" { cell.detailTextLabel?.text = "Exempt from rating"}
        else {cell.detailTextLabel?.text = "Rating " + rating}
        
        cell.imageView?.image = UIImage(named: rating)
        //alters background colour per rating
        if rating == "5" {
            cell.imageView?.backgroundColor = col3
        }
        else if rating == "4" || rating == "3" {
            cell.imageView?.backgroundColor = col2
        }
        else if rating == "-1" {
            cell.imageView?.backgroundColor = colE
        }
        else { cell.imageView?.backgroundColor = col1 }
        return cell
    }

    //checks for autherisation from the user and sets the locationMananger
    func getAuthorisation() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
    }

    //gets current location from device and makes a request for data based on this.
    func currentLocation()  {

        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude!)&long=\(longitude!)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { print("error with data"); return }
            do{
                self.allTheRecords = try JSONDecoder().decode([Place].self, from: data);
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData();
                }
                
            } catch let err {
                print("Error:", err)
            }
            }.resume()
        current = true
    }
    
    

    
    //passes data to the otherviews when the relavent button is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell{
            let i = myTableView.indexPath(for: cell)!.row
            if segue.identifier == "businessDetails" {
                let dvc = segue.destination as! BusinessDetailsViewController
                dvc.theBusiness = self.allTheRecords[i]
            }
        }
        
        if segue.identifier == "allMapView" {
            let dvc = segue.destination as! MapViewController
            dvc.locations = self.allTheRecords
            dvc.current = self.current
        }
    }
    
    
    //shows the view holding the search field
    @IBAction func showSearchbox(_ sender: Any) {
        searchBox.isHidden = false
    }

    //checks there is data entered in the search field
    func validation(){
        if searchInput.text! == "" {searchBtn.isEnabled = false }
        else {searchBtn.isEnabled = true}
    }

    //takes input data and based on the selection makes the relavent request for data
    @IBAction func searchAction(_ sender: Any) {
        allTheRecords = [Place]()
        var url :String?
        if searchInput.text != "" {
            let value = searchInput.text!
            let index = searchChoice.selectedSegmentIndex
            let encodeValue = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if index == 0 {
                //name
                url = "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(encodeValue!)"
            }
            else {
                //postcode
                url = "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(encodeValue!)"
            }
            
            let myurl = URL(string: url!)
            URLSession.shared.dataTask(with: myurl!) { (data, response, error) in
                guard let data = data else { print("error with data"); return }
                do{
                    self.allTheRecords = try JSONDecoder().decode([Place].self, from: data);
                    DispatchQueue.main.async {
                        self.myTableView.reloadData();
                    }
                } catch let err {
                    print("Error:", err)
                }
                }.resume()
            current = false
            self.view.endEditing(true)//the keyboard in hiden
            searchBox.isHidden = true
            searchInput.text = ""
        }
        
    }
    
    //search field is hiden when swiped away
    @IBAction func swipeRight(_ sender: Any) {
        
        searchBox.isHidden = true
        searchInput.text = ""
        self.view.endEditing(true)//the keyboard in hiden
    }
    
    //resets the list back to users location
    @IBAction func refreshBtnAction(_ sender: Any) {
        
        currentLocation()
    }
    
}

