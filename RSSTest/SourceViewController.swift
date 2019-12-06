//
//  SourceViewController.swift
//  RSSTest
//
//  Created by Надежда Возна on 06.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit

class SourceViewController: UITableViewController {
    
    private let coredata = CoreData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "showSelected")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if flag {
            coredata.fetch(tableView: tableView)
            if urlArray.count >= 1 {
                print(urlArray[0].value(forKey: "urls") as? String ?? "url error in cell")
            } else {
                print("URL Array is Empty")
            }
            flag = false
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showSelected", for: indexPath)
        let section = indexPath.section
        if section == 0 {
            if urlArray.count >= 1 {
                cell.textLabel?.text = urlArray[indexPath.row].value(forKey: "urls") as? String
            } else {
                cell.textLabel?.text = "..."
            }
        } else {
            cell.textLabel?.text = "Show All Feed"
        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = self.storyboard?.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        if indexPath.section == 0 {
            self.navigationController?.pushViewController(web, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
