//
//  NewSourceViewController.swift
//  RSSTest
//
//  Created by Надежда Возна on 06.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit

class NewSourceViewController: UITableViewController {

    @IBOutlet weak var urlField: UITextField!
    private let coredata = CoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        coredata.save(link: urlField.text!)
        coredata.fetch(tableView: tableView)
    }
}
