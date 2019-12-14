//
//  DescriptionViewController.swift
//  RSSTest
//
//  Created by Надежда Возна on 06.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit

class DescriptionViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    public var titleMore = String()
    public var descriptionMore = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        titleLabel.text = titleMore
        descriptionLabel.text = descriptionMore
        tableView.rowHeight = UITableView.automaticDimension
    }
}
