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
        //generateTestData()
        attemptFetch()
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
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
    
    func generateTestData() {
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "need money"
        
        let item2 = Item(context: context)
        item2.title = "Banana"
        item2.price = 2000
        item2.details = "real deal"
        
        let item3 = Item(context: context)
        item3.title = "book"
        item3.price = 5000
        item3.details = "with very loooooooooooooong text and a lot of words and costs a lot"
        
        ad.saveContext()
    }
}
