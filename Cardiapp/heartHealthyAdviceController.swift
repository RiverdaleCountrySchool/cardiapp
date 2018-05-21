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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
