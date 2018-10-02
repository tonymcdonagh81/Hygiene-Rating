//
//  BusinessDetailsViewController.swift
//  Hygiene App 2
//
//  Created by Tony Mcdonagh on 20/03/2018.
//  Copyright © 2018 Tony McDonagh. All rights reserved.
//

import UIKit

class BusinessDetailsViewController: UIViewController {
    
   //Outlets for linking code to items on the app view
    @IBOutlet weak var buisnessName: UILabel!
    @IBOutlet weak var addLine1: UILabel!
    @IBOutlet weak var addLine2: UILabel!
    @IBOutlet weak var addLine3: UILabel!
    @IBOutlet weak var postCode: UILabel!
    @IBOutlet weak var ratingDate: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var backG: UIView!
    @IBOutlet weak var mapBtn: UIButton!
    var rating: String!
    var fhrsImage: String!
    
    //Initialising variables
    var theBusiness: Place?
    let col3 = UIColor.green
    let col2 = UIColor.orange
    let col1 = UIColor.init(red: 205/255, green: 226/255, blue: 71/255, alpha: 1.0)
    let colE = UIColor.lightGray

    override func viewDidLoad() {
        super.viewDidLoad()
        //adds custom settings to the display button
        mapBtn.layer.cornerRadius = 4
        
        //sets the data to be displayed in the app view
        buisnessName.text = theBusiness?.BusinessName
        addLine1.text = theBusiness?.AddressLine1
        addLine2.text = theBusiness?.AddressLine2
        addLine3.text = theBusiness?.AddressLine3
        postCode.text = theBusiness?.PostCode
        rating = theBusiness?.RatingValue
        ratingDate.text = theBusiness?.RatingDate
        fhrsImage = "fhrs\(rating!)"
        
        
        if rating == "-1" {
            backG.backgroundColor = colE
            fhrsImage = "exempt"
        }
        else { backG.backgroundColor = col1 }
        
        ratingImage.image  = UIImage(named: fhrsImage)
       
    }

    //passes the business data to the mapview to show the location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "oneMapView" {
            let dvc = segue.destination as! MapViewController
            dvc.oneLocation = self.theBusiness
        }
    }


}
