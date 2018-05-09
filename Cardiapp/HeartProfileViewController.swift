//
//  HeartProfileViewController.swift
//  
//
//
import UIKit
import Foundation
import HealthKit
import HealthKitUI

class HeartProfileViewController: UIViewController {
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexDataLabel: UILabel!
    @IBOutlet weak var heightDataLabel: UILabel!
    @IBOutlet weak var bodyMassDataLabel: UILabel!
    @IBOutlet weak var maxBPMLabel: UILabel!
    @IBOutlet weak var MaxBPM50Label: UILabel!
    @IBOutlet weak var MaxBPM85Label: UILabel!
    @IBOutlet weak var moderateExerciseLabel: UILabel!
    @IBOutlet weak var intenseExerciseLabel: UILabel!
    
    @IBAction func unwindToHeartProfileViewController(segue:UIStoryboardSegue) { }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let healthStore = HKHealthStore()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //get Biological data
        getBioData(){ (error) in
            if let error = error{
                print("Error (40): \(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getUserDefaults()
        optimalHeartRate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //HAMBURGER SLIDER
        //viewXPosition.constant = -500
        //viewFront.isHidden = true
    }
    
    //var hamburgerMenuIsVisable = false
    //@IBOutlet weak var viewXPosition: NSLayoutConstraint!
    //@IBAction func hamburgerBttnTppd(_ sender: Any) {
        //if !hamburgerMenuIsVisable {
            //mainView.bringSubview(toFront: viewFront)
            //viewXPosition.constant = 0
            //hamburgerMenuIsVisable = true
            //viewFront.isHidden = false
        //} else {
            //viewXPosition.constant = -500
            //hamburgerMenuIsVisable = false
        //}
        
        //UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { self.view.layoutIfNeeded()}) { (animationComplete) in
        //}
    //}
    
    func getUserDefaults(){
        let userAge = defaults.integer(forKey: "Age"),
        userSex = defaults.string(forKey: "Sex"),
        userHeight_Numerical = defaults.integer(forKey: "Height"),
        userHeight_String = defaults.string(forKey: "HeightString"),
        userWeight_Numerical = defaults.double(forKey: "Weight"),
        userWeight_String = defaults.string(forKey: "WeightString")
        
        print("User Age: \(userAge)")
        print("User Sex: \(userSex ?? "Unknown")")
        print("User Numerical Height: \(userHeight_Numerical)")
        print("User String Height: \(userHeight_String ?? "Unknown")") //may need to figure out unwrapping this later
        print("User Numerical Weight: \(userWeight_Numerical)")
        print("User String Weight: \(userWeight_String ?? "Unknown")") //may need to figure out unwrapping this later
    }
    
    func getBioData(completion: @escaping (Error?) -> Void){
        self.getAge()
        self.getBiologicalSex()
        self.getHeight()
        self.getBodyMass()
        self.getWorkoutType()
        completion(nil)
    }
    
    func getWorkoutType(){
//        getMostRecentSample(for: HKSampleType.workoutType()) { (sample, error) in
//            guard let sample = sample else{
//                print("ERROR – COULD NOT ESTABLISH SAMPLE IN getWorkoutType (95)")
//                return
//            }
//            let workoutSample = sample?.quantity
//            print("WORKOUT SAMPLE TYPE: \(workoutSample)")
//        }
    }
    
    func getAge() {
        var age: Int?
        var birthComponents: DateComponents
        do {
            birthComponents = try healthStore.dateOfBirthComponents()
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year],
                                                              from: today)
            let thisYear = todayDateComponents.year!
            age = thisYear - birthComponents.year!
            if let unwrappedAge = age{
                defaults.set(unwrappedAge, forKey: "Age")
                DispatchQueue.main.async {
                    self.ageLabel.text = "\(unwrappedAge)"
                }
            }
        } catch{
            print("CAN'T GET AGE (80)")
        }
    }
    
    func getBiologicalSex(){
        var bioSexObject: HKBiologicalSexObject?
        do {
            bioSexObject = try healthStore.biologicalSex()
        } catch {
            print("CAN'T GET BIOLOGICAL SEX DATA (60)")
        }
        
        if let bioSex = bioSexObject?.biologicalSex{
            defaults.set(bioSex.stringRepresentation, forKey: "Sex")
            DispatchQueue.main.async {
                self.biologicalSexDataLabel.text = "\(bioSex.stringRepresentation)"
            }
        }
    }
    
    func getHeight(){
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("COULD NOT INITIALIZE HEIGHT QUANTITY TYPE (110)")
            return
        }
        getMostRecentSample(for: heightSampleType) { (sample, error) in
            guard let sample = sample else{
                if let error = error{
                    print(error)
                    print("ERROR THROW GRABBING SAMPLE (117)")
                }
                return
            }
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            let heightFormatter = LengthFormatter()
            heightFormatter.isForPersonHeightUse = true
            defaults.set(heightInMeters, forKey: "Height")
            defaults.set(heightFormatter.string(fromMeters: heightInMeters), forKey: "HeightString")
            
            DispatchQueue.main.async {
                self.heightDataLabel.text = heightFormatter.string(fromMeters: heightInMeters)
            }
        }
        
    }
    
    func getBodyMass (){
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else{
            print("COULD NOT ESTABLISH WEIGHT SAMPLE TYPE (133)")
            return
        }
        getMostRecentSample(for: weightSampleType) {(sample, error) in
            guard let sample = sample else{
                if let error = error {
                    print("COULD NOT GET WEIGHT SAMPLE (139)")
                    print(error)
                }
                return
            }
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            let weightFormatter = MassFormatter()
            weightFormatter.isForPersonMassUse = true
            defaults.set(weightInKilograms, forKey: "Weight")
            defaults.set(weightFormatter.string(fromKilograms: weightInKilograms), forKey: "WeightString")
            DispatchQueue.main.async{
                self.bodyMassDataLabel.text = weightFormatter.string(fromKilograms: weightInKilograms)
            }
        }
        
    }
    
    func getMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
                guard let samples = samples,
                    let mostRecentSample = samples.first as? HKQuantitySample else {
                        completion(nil, error)
                        return
                }
                completion(mostRecentSample, nil)
            }
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    
    func optimalHeartRate() {
        
        var heartRange50 = 0
        var heartRange85 = 0
        
        let userAge = Int(defaults.string(forKey: "Age")!)!
        switch userAge {
            case 0..<30:
                heartRange50 = 100
                heartRange85 = 170
            case  30..<35 :
                heartRange50 = 95
                heartRange85 = 162
            case  35..<40 :
                heartRange50 = 93
                heartRange85 = 157
            case  40..<45 :
                heartRange50 = 90
                heartRange85 = 153
            case 45..<50:
                heartRange50 = 88
                heartRange85 = 149
            case 50..<55:
                heartRange50 = 85
                heartRange85 = 145
            case 55..<60:
                heartRange50 = 83
                heartRange85 = 140
            case 60..<65:
                heartRange50 = 80
                heartRange85 = 136
            case 65..<70:
                heartRange50 = 78
                heartRange85 = 132
            case 70..<100000:
                heartRange50 = 75
                heartRange85 = 128
            default:
                print("Problem setting target heart rate")
        }
        let maxHeartRate = 220 - userAge
        maxBPMLabel.text = "\(maxHeartRate)"
        MaxBPM50Label.text = "\(heartRange50)"
        MaxBPM85Label.text = "\(heartRange85)"
        
        //moderate activity
        let BPM50HeartRate = (maxHeartRate) / 2
        let BPM70HeartRate = (maxHeartRate * 10) / 7
        let BPM85HeartRate = (maxHeartRate * 100) / 85
        
        moderateExerciseLabel.text = "\(BPM50HeartRate) to \(BPM70HeartRate)"
        intenseExerciseLabel.text = "\(BPM70HeartRate) to \(BPM85HeartRate)"
    }
    
    
}

///**** on this page use https://healthyforgood.heart.org/move-more/articles/target-heart-rates to calculate the optimal bpm ; if under 20, put them in the 20 yr group
