//
//  CafeDetailViewController.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/15/23.
//

import UIKit

class CafeDetailViewController: UIViewController {
//    var configuration = UIButton.Configuration.self
    
    
    @IBOutlet weak var websiteButtonOutlet: UIButton!
    @IBOutlet weak var phoneNumberButtonOutlet: UIButton!
    
    @IBOutlet weak var cafeImageView: UIImageView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeHoursLabel: UILabel!
    @IBOutlet weak var cafePhoneLabel: UILabel!
    @IBOutlet weak var cafeWebsiteLabel: UILabel!
    
    var cafe : Cafe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cafeWebsiteLabel.isHidden = true
        cafePhoneLabel.isHidden = true
    
        guard let cafe = cafe else { return }
        guard let hoursArray = cafe.googlePlace?.openHoursWeekdayText else { return }
        
        if cafe.googlePlace?.website != nil {
            let website = cafe.googlePlace?.website!
            websiteButtonOutlet.setTitle(website, for: .normal)
            websiteButtonOutlet.setTitleColor(.link, for: .normal)
        }
        if cafe.googlePlace?.phoneNumber != nil {
            let phoneNumber = cafe.googlePlace?.phoneNumber!
            phoneNumberButtonOutlet.setTitle(phoneNumber, for: .normal)
            phoneNumberButtonOutlet.setTitleColor(.link, for: .normal)
        }
     
        let hoursDisplay = displayHours(arr: hoursArray)
        
        cafeNameLabel.text = cafe.name
        cafeImageView.image = cafe.googlePlace?.image
        cafeHoursLabel.text = hoursDisplay
        cafePhoneLabel.text = cafe.googlePlace!.phoneNumber
        cafeWebsiteLabel.text = cafe.googlePlace!.website
        
    } // END ViewDidLoad
    
    // MARK: - Helper Functions
    
    @IBAction func cafeWebsiteButtonTapped(_ sender: UIButton) {
        guard let cafe = cafe else { return }
        guard let website = cafe.googlePlace?.website else {return}
        UIApplication.shared.open(URL(string:"\(website)")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func phoneOutletTappen(_ sender: Any) {
        guard let cafe = cafe else { return }
        guard let phoneNumber = cafe.googlePlace?.phoneNumber else {return}
        let formattedNumber = "telprompt://" + phoneNumber.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        guard let number = URL(string: formattedNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    
    func displayHours(arr: [String]) -> String {
        let formattedHours = arr.joined(separator: "\n")
        return formattedHours
    }
    
    
} // END ViewController
