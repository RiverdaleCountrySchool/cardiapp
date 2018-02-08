//
//  ViewController.swift
//  heartRateAppMockUp
//
//  Created by Sam Lack on 11/28/17.
//  Copyright © 2017 Riverdale Country School. All rights reserved.
//

import UIKit
import HealthKit

//establishes userdefaults for the app (lets you save certain values for the user that will be used frequently throughout the app)
let defaults = UserDefaults.standard

class ViewController: UIViewController {

    @IBOutlet weak var viewFront: UIView!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var hourButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    
    @IBAction func hourPressed(_ sender: UIButton) {
        hourButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 168/255, alpha: 1)
        dayButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        weekButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        monthButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        yearButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
    }
    @IBAction func dayPressed(_ sender: UIButton) {
        hourButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        dayButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 168/255, alpha: 1)
        weekButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        monthButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        yearButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
    }
    @IBAction func weekPressed(_ sender: UIButton) {
        hourButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        dayButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        weekButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 168/255, alpha: 1)
        monthButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        yearButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
    }
    @IBAction func monthPressed(_ sender: UIButton) {
        hourButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        dayButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        weekButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        monthButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 168/255, alpha: 1)
        yearButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
    }
    @IBAction func yearPressed(_ sender: UIButton) {
        hourButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        dayButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        weekButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        monthButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1)
        yearButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 168/255, alpha: 1)
    }
    
    var hamburgerMenuIsVisable = false
    @IBOutlet weak var viewXPosition: NSLayoutConstraint!
    @IBAction func hamburgerBttnTppd(_ sender: Any) {
        if !hamburgerMenuIsVisable {
            mainView.bringSubview(toFront: viewFront)
            viewXPosition.constant = 0
            hamburgerMenuIsVisable = true
            viewFront.isHidden = false
        } else {
            viewXPosition.constant = -500
            hamburgerMenuIsVisable = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { self.view.layoutIfNeeded()}) { (animationComplete) in
        }
    }
    
    //function to get authorization from healthkit for certain datatypes in the application
    
    let healthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: @escaping (Error?) -> Void) {
        if HKHealthStore.isHealthDataAvailable(){
            print("HEALTH DATA AVAILABLE (19)")
        } else{ print("HEALTH DATA UNAVAILABLE (20)") }
        
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)
            else {
                print("HKObjectType INITIALIZATION ERROR (29)")
                return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, biologicalSex, height, bodyMass, heartRate, HKObjectType.workoutType()]
        
        healthStore.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) -> Void in
            if success == false{
                print("AUTHORIZATION FAIL (37)")
            }
            else{
                print("AUTHORIZATION SUCCESS(41)")
                print("–––––––––––––––––––––––––––––––––––––––––")
                
                //Deprecated:
                //self.checkAuthorizationStatus()
            }
        }
        completion(nil)
    }
    
    //get heart rate samples from a start date
    func getHeartRates(startDate: Date?){
        var startDate = startDate
        
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else{
            print("could not establish quantity type (46)")
            return
        }
        //*** TIME IS BASED ON GREENWICH MEAN TIME --> NEED TO CHANGE WHEN GRAPHING OR SOMETHING B/C YOU CAN'T SET IT HERE
        let now = NSDate()
        
        if startDate == nil{
            print("NO STARTDATE PASSED, PULLING ALL THE DATA")
            startDate = NSDate.distantPast as Date
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now as Date, options: [])
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: sortDescriptors) {
            query, results, error in
            
            guard error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            
            //saving parsed heart rate data to local variable
            //self.hrDataLoad = self.parseHKSampleArray(results: results) as! [(Int, Date, Date)]
            let arrayConvertedFromHealthStore = self.parseHKSampleArray(results: results) as! [(Int, Date, Date)]
            let arrayForGraph = self.parsedHKSampleArrayForGraphs(dataSet: arrayConvertedFromHealthStore)
            self.createGraph(heartRateDataSet: arrayForGraph)
        }
        healthStore.execute(heartRateQuery)
    }
    
    func parseHKSampleArray(results: [HKSample]?) -> Array<Any>{
        var finalArray = [Any]()
        for currData in results!{
            let currDataString = "\(currData)"
            let parsedCurrDataStringArray = currDataString.components(separatedBy: " count/min")
            let BPM = Int(parsedCurrDataStringArray[0])
            
            //            print("BPM: \(BPM!)")
            //            print("Start Date: \(currData.startDate)")
            //            print("End Date: \(currData.endDate)")
            //            print("UUID: \(currData.uuid)")
            //            print("Source: \(currData.sourceRevision)")
            
            finalArray.append((BPM!, currData.startDate, currData.endDate))
        }
        
        return finalArray
    }
    
    
    //Parsing for Graphs --> Jessica's section
    func parsedHKSampleArrayForGraphs(dataSet: Array<Any>) -> ([String], [Double]){
        
        var xArray = [String]()
        var yArray = [Double]()
        for set in dataSet{
            let setArray = set as! (Int, Date, Date)
            let dateTime = setArray.1
            
            //***TRY TO CHANGE THE DATETIME TO THE LOCAL DATETIME
            //let localDateTimeDescription = dateTime.description(with: .current)
            
            xArray.append("\(dateTime)")
            
            let y = "\(setArray.0).0"
            let finalY = Double(y)
            yArray.append(finalY!)
        }
        //returning a reversed array so that the array goes from oldest to newest
        return (xArray.reversed(), yArray.reversed())
    }
    
    
    //Jessica's section
    func createGraph(heartRateDataSet: Any){
        //Graphing Code Goes Here
        print("THIS IS THE HEART RATE DATA: \(heartRateDataSet)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //run authorization
        authorizeHealthKit(){ (error) in
            if let error = error{
                print("Error (32): \(error)")
            }
        }
        getHeartRates(startDate: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewXPosition.constant = -500
        viewFront.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

