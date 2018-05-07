//
//  Created by Sam Lack on 1/14/18.
//  Copyright © 2018 Riverdale Country School. All rights reserved.
//
import UIKit
import Foundation

class tagListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewTagList: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tags: [PersonalTag] = []
    var coreDataStartDates: [Date?] = []
    var coreDataEndDates: [Date?] = []
    var coreDataActivities: [String] = []
    var coreDataStar: [Bool] = []
    
    @IBAction func unwindToTagList(segue:UIStoryboardSegue) { }
    
    @IBAction func saveToTagListController (segue:UIStoryboardSegue) {
        let detailViewController = segue.source as! DetailTableViewController
        
        let index = detailViewController.index
        
        let activityString = detailViewController.editedActivity
        
        coreDataActivities[index!] = activityString!
        
        tableViewTagList.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let tag = tags[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let startDateAppear = dateFormatter.string(from: tag.startDate!)
        let endDateAppear = dateFormatter.string(from: tag.endDate!)
        cell.textLabel?.numberOfLines = 0
        var star = ""
        if tag.star == true {
            star = "🚩"
        } else {
            star = ""
        }
        cell.textLabel?.text = "ACTIVITY: \((tag.activity)!)\nSTART TIME: \(startDateAppear)\nEND TIME: \(endDateAppear)\n\(star)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let tag = tags[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let startDateAppear = dateFormatter.string(from: tag.startDate!)
        let endDateAppear = dateFormatter.string(from: tag.endDate!)
        print("ACTIVITY: \((tag.activity)!)\nSTART TIME: \(startDateAppear)\nEND TIME: \(endDateAppear)\n\(tag.star)")
        //performSegue(withIdentifier: "edit", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let tag = tags[indexPath.row]
            tags.remove(at: indexPath.row)
            context.delete(tag)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTagList.delegate = self
        tableViewTagList.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableViewTagList.reloadData()
    }
    
    func getData() {
        do {
            tags = try context.fetch(PersonalTag.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    func prepareForSegue(for segue: UIStoryboardSegue, sender: AnyObject?, indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        print("HELLO")
        if segue.identifier == "edit" {
            print("GOODBYE")
            var path = tableViewTagList.indexPathForSelectedRow

            var detailViewController = segue.destination as! DetailTableViewController

            detailViewController.index = path?.row

            for tag in tags{
                coreDataStartDates.append(tag.startDate)
                coreDataEndDates.append(tag.endDate)
                coreDataActivities.append(tag.activity!)
                coreDataStar.append(tag.star)
            }
            print("BEFORE: \(coreDataActivities)")
            detailViewController.activityArray = coreDataActivities
            print("AFTER: \(detailViewController.activityArray)")

        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
