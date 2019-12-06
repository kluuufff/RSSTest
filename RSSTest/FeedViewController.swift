//
//  ViewController.swift
//  RSSTest
//
//  Created by Надежда Возна on 05.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit
import CoreData

class FeedViewController: UITableViewController {
    
    private var xmlParser = XMLParser()
    private var items: [Item] = []
    private var itemTitle = String()
    private var itemLink = String()
    private var itemDate = String()
    private var elementName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rssResponse()
    }
    
    //RSS Response
    private func rssResponse() {
        if let url = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss") {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                parser.parse()
                print("success to parse")
            } else {
                print("failed to parse")
            }
        } else {
            print("url error")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.pubDate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func addSourceButton(_ sender: UIBarButtonItem) {
        let str = "http://images.apple.com/main/rss/hotnews/hotnews.rss"
        let coredata = CoreData()
        coredata.save(link: str)
        flag = true
//        print(urlArray[0].value(forKey: "urls") as? String ?? "fetch error")
    }
    

}

//MARK: - RSS Parser

extension FeedViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "item" {
            itemTitle = String()
            itemLink = String()
            itemDate = String()
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = Item(title: itemTitle, link: itemLink, pubDate: itemDate)
            items.append(item)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            switch elementName {
            case "title":
                itemTitle += data
            case "link":
                itemLink += data
            case "pubDate":
                itemDate += data
                print("\(itemDate)")
            default:
                print("elementName error")
            }
            #if DEBUG
            print("\(items)")
            #endif
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
}
