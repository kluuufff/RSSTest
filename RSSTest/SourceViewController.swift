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
    public var urlStringArray = [String]()

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
        
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "showSelected")
        coredata.fetch(tableView: tableView)
    }
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func addSource() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "searchNB") as! UINavigationController
        if #available(iOS 13.0, *) {
            vc.modalPresentationStyle = .automatic
        } else {
            vc.modalPresentationStyle = .fullScreen
        }
        present(vc, animated: true, completion: nil)
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
                cell.textLabel?.text = "URLs Not found"
            }
        } else {
            cell.textLabel?.text = "Show All Feed"
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    private func getRSSLink(myURL: String) -> String {
//        let myURL = "https://9to5mac.com"
        var strFull = String()
        var strShort = String()
        var finalString = String()
        
        if let url = URL(string: myURL) {
            do {
                let contents = try String(contentsOf: url, encoding: .ascii)
                strFull = contents
                print(contents)
                if
                    let hashtag = strFull.range(of: "rss"),
                    let word = strFull.range(of: ">", range: hashtag.upperBound..<strFull.endIndex)
                {
                    let hashtagWord = strFull[hashtag.upperBound..<word.upperBound]
                    strShort = String(hashtagWord)
                    print(strShort)
                    if
                        let firstWord = strShort.range(of: "href=\""),
                        let lastWord = strShort.range(of: ">", range: firstWord.lowerBound..<strShort.endIndex)
                    {
                        let finalStr = strShort[firstWord.upperBound..<lastWord.upperBound]
                        finalString = String(finalStr)
                        let result = finalString.components(separatedBy: "\"")
                        print(finalString)
                        print(result[0])
                        return result[0]
                    }
                }
            } catch {
                print("error when get contents from URL")
            }
        } else {
            print("error")
        }
        return "error"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = self.storyboard?.instantiateViewController(withIdentifier: "feedVC") as! FeedViewController
        if indexPath.section == 1 {
            guard let index = tableView.indexPathForSelectedRow else { return }
            guard let currentCell = tableView.cellForRow(at: index) else { return }
            
            
            
            if currentCell.textLabel!.text! != "" {
                
                if !currentCell.textLabel!.text!.contains("https://") {
                    web.source = getRSSLink(myURL: "https://" + currentCell.textLabel!.text!)
//                    web.source = "https://" + currentCell.textLabel!.text! + "/feed/"
                }
            }
            self.navigationController?.pushViewController(web, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if urlArray.count >= 1 {
            return 44.0
        } else {
            return 0
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                coredata.delete(object: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    

}

extension SourceViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
