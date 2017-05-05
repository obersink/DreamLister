//
//  MainVC.swift
//  DreamLister
//
//  Created by Simon Zhen on 5/4/17.
//  Copyright © 2017 Simon Zhen. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptFetch()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        itemTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
            case .insert:
                if let indexPath = newIndexPath {
                    itemTableView.insertRows(at: [indexPath], with: .fade)
                }
                break
            case .delete:
                if let indexPath = indexPath {
                    itemTableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            case .update:
                if let indexPath = indexPath {
                    let cell = itemTableView.cellForRow(at: indexPath) as! ItemCell
                    configureCell(cell: cell, indexPath: indexPath)
                }
                break
            case .move:
                if let indexPath = indexPath {
                    itemTableView.deleteRows(at: [indexPath], with: .fade)
                }
                if let indexPath = newIndexPath {
                    itemTableView.insertRows(at: [indexPath], with: .fade)
                }
                break
        }
    }
}
