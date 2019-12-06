//
//  ViewController.swift
//  RSSTest
//
//  Created by Надежда Возна on 05.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit

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
