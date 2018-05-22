//
//  detailTableViewController2.swift
//  Cardiapp
//
//  Created by Sam Lack on 5/15/18.
//  Copyright © 2018 Riverdale Country School. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class detailTableViewController2: UITableViewController /*, UIPickerViewDataSource, UIPickerViewDelegate */ {

    @IBOutlet weak var editActivityTextField: UITextField!
    @IBOutlet weak var editStartTimeTextField: UITextField!
    @IBOutlet weak var editEndTimeTextField: UITextField!
    @IBOutlet weak var editStarSwitch: UISwitch!
    
    var index:Int?
    var activityArray:[String]!
    var editedActivity:String?
    
    var activityToolBar = UIToolbar()
    var activityPickerData = ["Soccer ⚽️","Running 🏃","Sleeping 💤","Eating 🍔","Drinking 🍸","Smoking 🚬","Watching TV 📺","Basketball 🏀","Football 🏈","Baseball ⚾️","Walking 🚶","Lifting Weights 🏋️‍♀️","Dancing 💃","Tennis 🎾","Volleyball 🏐","Ping Pong 🏓","Ice Hockey 🏒","Field Hockey 🏑","Archery 🏹","Fishing 🎣","Boxing 🥊","Martial Arts 🥋","Skiing ⛷","Snowboarding 🏂","Ice Skating ⛸","Wrestling 🤼‍♀️","Gymnastics 🤸‍♀️","Golf 🏌️","Surfing 🏄","Water Polo 🤽‍♀️","Swimming 🏊‍♀️","Rowing 🚣‍♀️","Horseback Riding 🏇","Biking 🚴","Mountain Biking 🚵‍♀️","Juggling 🤹‍♂️","Rugby 🏉","Pool 🎱","Badminton 🏸","Cricket 🏏","Bowling 🎳","Video Games 🎮","Darts 🎯","Fencing 🤺","Trumpet 🎺","Piano 🎹","Drums 🥁","Saxophone 🎷","Guitar 🎸","Violin 🎻","Dodgeball 🤾‍♂️","Singing 🎤"]
    
    var startTimeArray:[Date]!
    var editedStartTime:Date?
    var endTimeArray:[Date]!
    var editedEndTime:Date?
    var starArray:[Bool]!
    var editedStar:Bool?
    
    @IBAction func editStarSwitchClicked(_ sender: Any) {
        if editStarSwitch.isOn {
            editedStar = true
        }
        else {
            editedStar = false
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        activityPickerData.sort()
//        let activityPicker = UIPickerView()
//        createActivityToolBar()
//        view.addSubview(editActivityTextField)
//        activityPicker.delegate = self
//        editActivityTextField.inputView = activityPicker
//        editActivityTextField.inputAccessoryView = activityToolBar
        
        editActivityTextField.text = activityArray[index!]
        
        editStartTimeTextField.text = "\(startTimeArray[index!])"
        editEndTimeTextField.text = "\(endTimeArray[index!])"
        
        if starArray[index!] == true {
            editStarSwitch.isOn = true
        } else if starArray[index!] == false {
            editStarSwitch.isOn = false
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //ACTIVITY PICKER
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return activityPickerData.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return activityPickerData[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        editActivityTextField.text = activityPickerData[row]
//        editedActivity = editActivityTextField.text!
//    }
//    func createActivityToolBar() {
//        activityToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(activityDoneButtonPressed(sender:)))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
//        label.text = "Activity"
//        let labelButton = UIBarButtonItem(customView:label)
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        activityToolBar.setItems([flexibleSpace,labelButton,flexibleSpace,doneButton], animated: true)
//    }
//    @objc func activityDoneButtonPressed(sender: UIBarButtonItem) {
//        editActivityTextField.resignFirstResponder()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*override*/ func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            editActivityTextField.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            editStartTimeTextField.becomeFirstResponder()
        } else if indexPath.section == 2 && indexPath.row == 0 {
            editEndTimeTextField.becomeFirstResponder()
        } else if indexPath.section == 3 && indexPath.row == 0 {
            editStarSwitch.becomeFirstResponder()
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "save" {
            //saveToCoreData(data: (editedActivity, selectedStartDate, selectedEndDate, selectedStar))
            //loadFromCoreData()
            
            editedActivity = editActivityTextField.text
            
            //editedStartTime = DateFormatter().date(from: editStartTimeTextField.text!)
            //editedEndTime = DateFormatter().date(from: editStartTimeTextField.text!)
            
        }
    }
    

}
