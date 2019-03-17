/*
  LocationPickerViewController.swift
  Weather wear

  Created by Joel Beilis on 2019-03-10.
  Copyright © 2019 Joel Beilis. All rights reserved.
*/

import UIKit

class LocationPickerViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locations : Array<[String:NSObject]> = []
    var filteredLocations : Array<[String:NSObject]> = []
    
//    var locations : Array<[String:String]>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = getDataForCity()
        filteredLocations = locations
    
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search location"

        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.leftBarButtonItem = self.ba
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // code
        let input : String = searchController.searchBar.text!
        print ("typed: " + input)
        
        let namePredicate: NSPredicate = NSPredicate(format: "SELF.city contains[cd] %@", input)
        let nsLocations : NSArray = (locations as NSArray)
        filteredLocations = nsLocations.filtered(using:namePredicate) as! Array<[String : NSObject]>
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell
        let row = indexPath.row
        var cityData = filteredLocations[row]
        let city = cityData["city"] as! String?
        let country = cityData["iso2"] as! String?
        let state = cityData["State"] as! String?
        cell.textLabel?.text = city! + ", " + state! + ", " + country!

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let city = cell?.textLabel?.text
        print ("Selected city : " + city!)
        self.navigationController?.popViewController(animated: true)
    }
    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
     Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getSwiftArrayFromPlist(name: String)->(Array<Dictionary<String,NSObject>>) {
        
        let path = Bundle.main.path(forResource: name, ofType: "plist")
        var arr : NSArray?
        arr = NSArray(contentsOfFile: path!)
        return (arr as? Array<Dictionary<String,NSObject>>)!
            as (Array<Dictionary<String, NSObject>>)
    }
    
    func getDataForCity()->(Array<[String:NSObject]>) {
        let array = getSwiftArrayFromPlist(name: "worldcities")
//        let namePredicate = NSPredicate(format: "OrderDate = %@" , city)
//        return[array.filter {namePredicate.evaluate(with: $0)}[0]]
        return array
    }

}
