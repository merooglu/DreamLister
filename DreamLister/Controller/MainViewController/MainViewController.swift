//
//  MainViewController.swift
//  DreamLister
//
//  Created by Mehmet Eroğlu on 8.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ItemCell")
        
//        generateTestData()
        attemptFetch()
    }
    
    func generateTestData() {
        let item1 = Item(context: context)
        item1.title = "MacBook Pro"
        item1.price = 1800
        item1.details = "I can't wait until september event, I hope they will release new MBPs"
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "It's so nice to able to block out everyone with the noise cancalling tech"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "Oh man this is a beautiful car. And one day I will own it. Oh man this is a beautiful car. And one day I will own it. Oh man this is a beautiful car. And one day I will own it"
        ad.saveContext()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ItemDetailsViewController", sender: nil)
    }
    
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ItemDetailsViewController.self) {
            if let destination = segue.destination as? ItemDetailsViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableView.reloadData()
    }
    
    
    
}

// MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath) {
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
}

// MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objects = controller.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsViewController", sender: item)
        }
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension MainViewController: NSFetchedResultsControllerDelegate {
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
        default:
            break
        }
       
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexpath = newIndexPath {
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            break
        case .delete:
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            break
        case .move:
            if let indexpath = indexPath {
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            if let indexpaht = newIndexPath {
                tableView.insertRows(at: [indexpaht], with: .fade)
            }
            break
        case .update:
            if let indexpath = indexPath {
                let cell = tableView.cellForRow(at: indexpath) as! ItemCell
                configureCell(cell: cell, indexPath: indexpath)
            }
            break
        @unknown default:
            print("Apple added new didChange anObject type case")
        }
    }
}
