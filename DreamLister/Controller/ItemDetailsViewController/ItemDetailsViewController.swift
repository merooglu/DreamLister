//
//  ItemDetailsViewController.swift
//  DreamLister
//
//  Created by Mehmet Eroğlu on 21.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var priceTextField: CustomTextField!
    @IBOutlet weak var detailsTextField: CustomTextField!
    @IBOutlet weak var storePickerView: UIPickerView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    
    var imagePickerController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        storePickerView.dataSource = self
        storePickerView.delegate = self
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
//        generateStores()
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func generateStores() {
        let store1 = Store(context: context)
        store1.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Tesla Dealership"
        let store3 = Store(context: context)
        store3.name = "Fry Electronics"
        let store4 = Store(context: context)
        store4.name = "Amazon"
        let store5 = Store(context: context)
        store5.name = "Target"
        let store6 = Store(context: context)
        store6.name = "K Mart"
        ad.saveContext()
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePickerView.reloadAllComponents()
        } catch {
            // handle errors
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleTextField.text = item.title
            priceTextField.text = "\(item.price)"
            detailsTextField.text = item.details
            thumbImageView.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePickerView.selectRow(index, inComponent: 0, animated: false)
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImageView.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleTextField.text {
            item.title = title
        }
        if let price = priceTextField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsTextField.text {
            item.details = details
        }
        item.toStore = stores[storePickerView.selectedRow(inComponent: 0)]
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: UIButton) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

// MARK: - UIPickerViewDataSource
extension ItemDetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    
}

// MARK: - UIPickerViewDelegate
extension ItemDetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Update when selected
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ItemDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            thumbImageView.image = image
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
