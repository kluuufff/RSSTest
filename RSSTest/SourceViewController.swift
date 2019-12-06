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
        
        if #available(iOS 13.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addSource))
        }
        else {
            tableView = UITableView(frame: .zero, style: .grouped)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addSource))
        }
        
        let search = UISearchController(searchResultsController: nil)
               search.searchResultsUpdater = self
               self.navigationItem.searchController = search
               search.dimsBackgroundDuringPresentation = false
               definesPresentationContext = true
               self.navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "showSelected")
        coredata.fetch(tableView: tableView)
    }
    
    @objc func addSource() {
        let str = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
        let indexPath = IndexPath(row: 0, section: 1)
        coredata.save(link: str)
        coredata.fetch(tableView: tableView)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return urlArray.count
        } else {
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showSelected", for: indexPath)
        let section = indexPath.section
        if section == 1 {
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

extension SourceViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
