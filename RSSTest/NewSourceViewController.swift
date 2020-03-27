//
//  NewSourceViewController.swift
//  RSSTest
//
//  Created by Надежда Возна on 06.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit

class NewSourceViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var urlField: UITextField!
    private let coredata = CoreData()
    private var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.becomeFirstResponder()
        urlField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        coredata.save(link: urlField.text!)
        coredata.fetch(tableView: tableView)
        flag = true
        dismiss(animated: true, completion: nil)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        coredata.save(link: urlField.text!)
        coredata.fetch(tableView: tableView)
    }
}
