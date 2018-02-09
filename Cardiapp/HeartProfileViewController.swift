//
//  HeartProfileViewController.swift
//  
//
//  Created by Sam Lack on 12/13/17.
//
import UIKit
import Foundation
import HealthKit
import HealthKitUI

class HeartProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biologicalSexDataLabel: UILabel!
    @IBOutlet weak var heightDataLabel: UILabel!
    @IBOutlet weak var bodyMassDataLabel: UILabel!
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        self.getFirstName()
        self.getLastName()
        self.getAge()
        self.getBiologicalSex()
        self.getHeight()
        self.getBodyMass()
        completion(nil)
    }
    
    func getFirstName(){
        
    }
    
    func getLastName(){
        
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
    
    
}
