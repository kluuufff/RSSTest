//
//  CoreData.swift
//  RSSTest
//
//  Created by Надежда Возна on 06.12.2019.
//  Copyright © 2019 Надежда Возна. All rights reserved.
//

import UIKit
import CoreData

class CoreData {
    
    func save(link: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "RSS", in: context) else { return }
        
        let linkObject = NSManagedObject(entity: entity, insertInto: context)
        linkObject.setValue(link, forKey: "urls")
        
        do {
            try context.save()
            urlArray.append(linkObject)
        } catch {
            print("Error")
        }
    }
    
    func fetch(tableView: UITableView) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "RSS")
        do {
            urlArray = try context.fetch(fetch)
        } catch {
            print("Error")
        }
    }
    
    func delete(object: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(urlArray[object])
        urlArray.remove(at: object)
        do {
            try context.save()
        } catch {
            print("error when delete")
        }
    }
}
