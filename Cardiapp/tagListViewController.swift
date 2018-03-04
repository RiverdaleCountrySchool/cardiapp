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
    
    @IBAction func unwindToTagList(segue:UIStoryboardSegue) { }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tag = tags[indexPath.row]
            context.delete(tag)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                tags = try context.fetch(PersonalTag.fetchRequest())
            } catch {
                print("Fetching Failed")
            }
        }
        tableViewTagList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        performSegue(withIdentifier: "editTagSegue", sender: self)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
