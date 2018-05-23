//
//  heartHealthyAdviceController.swift
//  Cardiapp
//
//  Created by Wesley Penn on 5/17/18.
//  Copyright © 2018 Riverdale Country School. All rights reserved.
//

import UIKit
import CoreData

class heartHealthyAdviceController: UIViewController {

    @IBAction func unwindToHHA(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var coreDataTags = [PersonalTag]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PersonalTag> = PersonalTag.fetchRequest()
        do {
            coreDataTags = try context.fetch(fetchRequest)
        } catch {
            print("Fetching Failed")
        }
        
        var parsedCoreData = [(String?, Date?, Date?, Bool)]()
        for val in coreDataTags{
            parsedCoreData.append((val.activity, val.startDate, val.endDate, val.star))
        }
        
        
        cartegorizeTags(tags: parsedCoreData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cartegorizeTags(tags:[(String?, Date?, Date?, Bool)] ){
        
        let sepTags = tags[0].0!.components(separatedBy: " ")
        var activityText = sepTags[0]
        
        let tagList = tags[0].0!
        
        
    
        for i in tagList{
            
            let j = String(i)
            
            //different types of activity categories
            var active = 0
            var sedentary = 0
            var music = 0
            var vices = 0
            var eating = 0
            
            var categories: [String:Int] = ["active":active,"sedentary":sedentary,"music":music,"vices":vices,"eating":eating]
            
            if (j == "Soccer ⚽️") || (j == "Running 🏃") || (j=="Basketball 🏀") || (j=="Football 🏈") || (j=="Baseball ⚾️") || (j=="Walking 🚶") || (j=="Lifting Weights 🏋️‍♀️") || (j=="Dancing 💃") || (j=="Tennis 🎾") || (j=="Volleyball 🏐") || (j=="Ping Pong 🏓") || (j=="Ice Hockey 🏒") || (j=="Field Hockey 🏑") || (j=="Archery 🏹") || (j=="Fishing 🎣") || (j=="Boxing 🥊") || (j=="Martial Arts 🥋") || (j=="Skiing ⛷") || (j=="Snowboarding 🏂") || (j=="Ice Skating ⛸") || (j=="Wrestling 🤼‍♀️") || (j=="Gymnastics 🤸‍♀️") || (j=="Golf 🏌️") || (j=="Surfing 🏄") || (j=="Water Polo 🤽‍♀️") || (j=="Swimming 🏊‍♀️") || (j=="Rowing 🚣‍♀️") || (j=="Horseback Riding 🏇") || (j=="Biking 🚴") || (j=="Mountain Biking 🚵‍♀️") || (j=="Juggling 🤹‍♂️") || (j=="Rugby 🏉") || (j=="Pool 🎱") || (j=="Badminton 🏸") || (j=="Cricket 🏏") || (j=="Bowling 🎳") || (j=="Darts 🎯") || (j=="Fencing 🤺") || (j=="Dodgeball 🤾‍♂️") {
                active = active + 1
            }
            else if (j == "Eating 🍔"){
                eating = eating + 1
            }
            else if (j == "Sleeping 💤") || (j=="Watching TV 📺") || (j=="Video Games 🎮"){
                sedentary = sedentary + 1
            }
            else if (j=="Drinking 🍸") || (j=="Smoking 🚬"){
                vices = vices + 1
            }
            else if (j=="Trumpet 🎺") || (j=="Piano 🎹") || (j=="Drums 🥁") || (j=="Saxophone 🎷") || (j=="Guitar 🎸") || (j=="Violin 🎻") || (j=="Singing 🎤"){
                music = music + 1
            }
            

            
            categories = ["active":active,"sedentary":sedentary,"music":music,"vices":vices,"eating":eating]
            //categories = categories.sorted()
        }
        
    }
    
    func pickArticles(list: [Int]){
        print("pickedArticles")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
