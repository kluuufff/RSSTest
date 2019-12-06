//
//  Data.swift
//  RSSTest
//
//  Created by Надежда Возна on 05.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import CoreData

var urlArray = [NSManagedObject]()
var flag = false //for reload table after press add button

struct Item {
    var title: String
    var link: String
    var pubDate: String
}
