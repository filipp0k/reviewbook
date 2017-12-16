//
//  TableViewController.swift
//  Reviewbook
//
//  Created by Филипп Дюдин on 16.12.2017.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit
import os.log
class TableViewController: UITableViewController {

    var reviews = [Review]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleReviews()
        navigationItem.leftBarButtonItem = editButtonItem
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        cell.ImageCell.image = review.photo
        cell.LabelCell.text = review.name
        cell.RatingCell.rating = review.rating
        return cell
    }
    

    @IBAction func unwindToReviewList(sender: UIStoryboardSegue) {
        if let source = sender.source as? ReviewViewController, let review = source.review {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                reviews[selectedIndexPath.row] = review
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: reviews.count, section: 0)
                
                reviews.append(review)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            reviews.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new review.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let DetailViewController = segue.destination as? ReviewViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedReviewCell = sender as? ReviewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedReviewCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReview = reviews[indexPath.row]
            DetailViewController.review = selectedReview
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Importing some data
    
    
    
    
    private func loadSampleReviews() {
        
        let photo1 = UIImage(named: "Igor1")
        let photo2 = UIImage(named: "Igor2")
        let photo3 = UIImage(named: "Igor3")
        guard let review1 = Review(name: "Igor in Lipton Glasses", description: """
He is awesome
I am sure in it
and in him
""", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let review2 = Review(name: "Igor in IELTS", description: "", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let review3 = Review(name: "Igor in IELTS",description:"Is it gay to use your mates pics?", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        reviews += [review1, review2, review3]
    }

}
